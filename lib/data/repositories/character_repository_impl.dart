import 'package:hive/hive.dart' show Box;
import 'package:rick_and_morty_app/data/models/character_model.dart';

import '../../domain/entities/character.dart';
import '../../domain/repositories/character_repository.dart';
import '../datasources/character_local_data_source.dart';
import '../datasources/character_remote_data_source.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;
  final CharacterLocalDataSource localDataSource;
  final Box favoritesBox;

  CharacterRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.favoritesBox,
  });

  @override
  Future<List<Character>> getAllCharacters(int page) async {
    try {
      // 1. Try to fetch from API (Network)
      final remoteCharacters = await remoteDataSource.getAllCharacters(page);

      // 2. If successful, save to Local DB (Caching)
      await localDataSource.cacheCharacters(remoteCharacters, page);

      return remoteCharacters;
    } catch (e) {
      // 3. If API fails (No Internet), fetch from Local DB
      // Ideally, check specifically for DioExceptionType.connectionError
      try {
        final localCharacters = await localDataSource.getLastCharacters(page);
        if (localCharacters.isEmpty) {
          throw Exception("No offline data available");
        }
        return localCharacters;
      } catch (cacheError) {
        throw Exception("Failed to fetch data: $e");
      }
    }
  }

  @override
  List<Character> getFavorites() {
    // Hive values are dynamic, cast them to CharacterModel
    return favoritesBox.values.cast<CharacterModel>().toList();
  }

  @override
  Future<void> addFavorite(Character character) async {
    // We use the ID as the key so we don't add duplicates
    // Convert Character entity to Model to save it
    final model = CharacterModel(
      id: character.id,
      name: character.name,
      status: character.status,
      species: character.species,
      imageUrl: character.imageUrl,
      locationName: character.locationName,
    );
    await favoritesBox.put(character.id, model);
  }

  @override
  Future<void> removeFavorite(Character character) async {
    await favoritesBox.delete(character.id);
  }
}
