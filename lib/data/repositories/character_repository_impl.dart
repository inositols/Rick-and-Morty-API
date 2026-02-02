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
  Future<List<Character>> getAllCharacters(
    int page, {
    String? name,
    String? status,
    String? species,
  }) async {
    try {
      final remoteCharacters = await remoteDataSource.getAllCharacters(
        page,
        name: name,
        status: status,
        species: species,
      );
      if (name == null && status == null && species == null) {
        await localDataSource.cacheCharacters(remoteCharacters, page);
      }
      return remoteCharacters;
    } catch (e) {
      if (name != null || status != null || species != null) {
        rethrow;
      }

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
    return favoritesBox.values.cast<CharacterModel>().toList();
  }

  @override
  Future<void> addFavorite(Character character) async {
    final model = CharacterModel(
      id: character.id,
      name: character.name,
      status: character.status,
      species: character.species,
      imageUrl: character.imageUrl,
      locationName: character.locationName,
      gender: character.gender,
      type: character.type,
      originName: character.originName,
      episodes: character.episodes,
    );
    await favoritesBox.put(character.id, model);
  }

  @override
  Future<void> removeFavorite(Character character) async {
    await favoritesBox.delete(character.id);
  }
}
