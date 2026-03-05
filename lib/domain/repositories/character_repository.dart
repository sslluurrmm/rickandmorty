import 'package:rick_and_morty_app/domain/entities/character.dart';

abstract class CharacterRepository {
  Future<List<Character>> getCharacters({int page = 1});
  Future<void> addToFavorites(Character character);
  Future<void> removeFromFavorites(int characterId);
  Future<List<Character>> getFavorites();
  Future<bool> isFavorite(int characterId);
}