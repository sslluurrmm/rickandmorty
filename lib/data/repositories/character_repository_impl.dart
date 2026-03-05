import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:rick_and_morty_app/data/datasources/character_remote_data_source.dart';
import 'package:rick_and_morty_app/data/models/hive_character.dart';
import 'package:rick_and_morty_app/domain/entities/character.dart';
import 'package:rick_and_morty_app/domain/repositories/character_repository.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;
  final Box<HiveCharacter> favoritesBox;

  CharacterRepositoryImpl({
    required this.remoteDataSource,
    required this.favoritesBox,
  });

  @override
  Future<List<Character>> getCharacters({int page = 1}) async {
    try {
      final characters = await remoteDataSource.getCharacters(page: page);

      return characters.map((character) {
        return Character(
          id: character.id,
          name: character.name,
          status: character.status,
          species: character.species,
          gender: character.gender,
          image: character.image,
          location: character.location,
        );
      }).toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw Exception('Нет подключения к интернету');
      }
      rethrow;
    }
  }

  @override
  Future<void> addToFavorites(Character character) async {
    final exists = favoritesBox.values.any((h) => h.id == character.id);
    if (!exists) {
      await favoritesBox.add(HiveCharacter.fromCharacter(character));
    }
  }

  @override
  Future<void> removeFromFavorites(int characterId) async {
    final key = favoritesBox.keys.firstWhere(
            (k) => favoritesBox.get(k)!.id == characterId,
        orElse: () => null
    );
    if (key != null) {
      await favoritesBox.delete(key);
    }
  }

  @override
  Future<List<Character>> getFavorites() async {
    return favoritesBox.values
        .map((h) => h.toCharacter())
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Future<bool> isFavorite(int characterId) async {
    return favoritesBox.values.any((h) => h.id == characterId);
  }
}