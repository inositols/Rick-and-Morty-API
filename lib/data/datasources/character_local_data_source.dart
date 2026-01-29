import 'package:hive/hive.dart';
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
    final List<dynamic>? jsonList = box.get('page_$page');
    if (jsonList != null) {
      return jsonList.cast<CharacterModel>();
    } else {
      return [];
    }
  }

  @override
  Future<void> cacheCharacters(
    List<CharacterModel> characters,
    int page,
  ) async {
    await box.put('page_$page', characters);
  }
}
