import '../entities/character.dart';

abstract class CharacterRepository {
  Future<List<Character>> getAllCharacters(int page);
  List<Character> getFavorites();
  Future<void> addFavorite(Character character);
  Future<void> removeFavorite(Character character);
}
