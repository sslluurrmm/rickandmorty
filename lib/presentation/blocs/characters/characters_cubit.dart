import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/domain/entities/character.dart';
import 'package:rick_and_morty_app/domain/repositories/character_repository.dart';
import 'package:rick_and_morty_app/presentation/blocs/characters/characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final CharacterRepository repository;
  bool _isLoading = false;

  CharactersCubit(this.repository) : super(const CharactersInitial());

  Future<Map<int, bool>> _loadFavoriteStatus(List<Character> characters) async {
    final statusMap = <int, bool>{};
    for (final character in characters) {
      statusMap[character.id] = await repository.isFavorite(character.id);
    }
    return statusMap;
  }

  Future<void> loadCharacters({bool clear = false}) async {
    if (_isLoading || (!clear && (!state.hasMore || state.isOffline))) return;

    final page = clear ? 1 : state.currentPage + 1;
    final currentCharacters = clear ? <Character>[] : state.characters.toList();
    final currentStatus = clear ? <int, bool>{} : Map<int, bool>.from(state.favoriteStatus);

    _isLoading = true;

    emit(CharactersLoaded(
      characters: currentCharacters,
      currentPage: state.currentPage,
      hasMore: state.hasMore,
      favoriteStatus: currentStatus,
      isLoading: true,
      error: null,
      isOffline: false,
    ));

    try {
      if (!clear && page > 1) {
        await Future.delayed(const Duration(seconds: 1));
      }

      final newCharacters = await repository.getCharacters(page: page);
      final allCharacters = [...currentCharacters, ...newCharacters];
      final newStatus = await _loadFavoriteStatus(newCharacters);
      final updatedStatus = {...currentStatus, ...newStatus};

      emit(CharactersLoaded(
        characters: allCharacters,
        currentPage: page,
        hasMore: newCharacters.length == 20,
        favoriteStatus: updatedStatus,
        isLoading: false,
      ));
    } catch (e) {
      final errorMsg = e.toString().toLowerCase();
      final isConnectionError = errorMsg.contains('интернет') ||
          errorMsg.contains('network') ||
          errorMsg.contains('connection') ||
          errorMsg.contains('timeout');

      if (isConnectionError) {
        try {
          final favorites = await repository.getFavorites();
          final offlineStatus = <int, bool>{};
          for (final c in favorites) {
            offlineStatus[c.id] = true;
          }

          emit(CharactersLoaded(
            characters: favorites,
            currentPage: 0,
            hasMore: false,
            favoriteStatus: offlineStatus,
            isLoading: false,
            error: 'Нет подключения к интернету. Показаны избранные персонажи.',
            isOffline: true,
          ));
        } catch (favError) {
          emit(CharactersLoaded(
            characters: currentCharacters,
            currentPage: state.currentPage,
            hasMore: state.hasMore,
            favoriteStatus: currentStatus,
            isLoading: false,
            error: 'Ошибка при загрузке избранного: $favError',
            isOffline: false,
          ));
        }
      } else {
        emit(CharactersLoaded(
          characters: currentCharacters,
          currentPage: state.currentPage,
          hasMore: state.hasMore,
          favoriteStatus: currentStatus,
          isLoading: false,
          error: e.toString(),
          isOffline: false,
        ));
      }
    } finally {
      _isLoading = false;
    }
  }

  Future<void> toggleFavorite(Character character) async {
    final isNowFavorite = !(await repository.isFavorite(character.id));

    if (isNowFavorite) {
      await repository.addToFavorites(character);
    } else {
      await repository.removeFromFavorites(character.id);
    }

    if (state is CharactersLoaded) {
      final currentState = state as CharactersLoaded;
      final updatedStatus = Map<int, bool>.from(currentState.favoriteStatus);
      updatedStatus[character.id] = isNowFavorite;

      emit(CharactersLoaded(
        characters: currentState.characters,
        currentPage: currentState.currentPage,
        hasMore: currentState.hasMore,
        favoriteStatus: updatedStatus,
        isOffline: currentState.isOffline,
      ));
    }
  }

  bool isCharacterFavorite(int characterId) {
    return state.favoriteStatus[characterId] ?? false;
  }
}