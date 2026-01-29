import 'package:hive/hive.dart';
import '../../core/constants.dart';
import '../models/character_model.dart';

abstract class CharacterLocalDataSource {
  Future<List<CharacterModel>> getLastCharacters(int page);
  Future<void> cacheCharacters(List<CharacterModel> characters, int page);
}

class CharacterLocalDataSourceImpl implements CharacterLocalDataSource {
  final Box box;

  CharacterLocalDataSourceImpl({required this.box});

  @override
  Future<List<CharacterModel>> getLastCharacters(int page) async {
    // Try to get data for this specific page key
    // We cast it because Hive stores dynamic types
    final List<dynamic>? jsonList = box.get('page_$page');

    if (jsonList != null) {
      // Convert Hive List back to CharacterModels
      return jsonList.cast<CharacterModel>();
    } else {
      // If no cache exists, return empty list or throw exception based on preference
      return [];
    }
  }

  @override
  Future<void> cacheCharacters(
    List<CharacterModel> characters,
    int page,
  ) async {
    // Save the list of characters with a key like "page_1", "page_2"
    await box.put('page_$page', characters);
  }
}
