import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:rick_and_morty_app/data/models/hive_character.dart';
import 'package:rick_and_morty_app/domain/entities/character.dart';
import 'package:rick_and_morty_app/domain/entities/sort_option.dart';
import 'package:rick_and_morty_app/domain/repositories/character_repository.dart';
import 'package:rick_and_morty_app/presentation/blocs/favorites/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final CharacterRepository repository;
  final Box<HiveCharacter> favoritesBox;

  FavoritesCubit(this.repository, this.favoritesBox) : super(FavoritesState.initial()) {
    favoritesBox.watch().listen((_) {
      loadFavorites();
    });
  }

  Future<void> loadFavorites({SortOption? sortOption}) async {
    final currentSort = sortOption ?? state.sortOption;
    emit(state.copyWith(isLoading: true, sortOption: currentSort));

    try {
      final favorites = await repository.getFavorites();
      final sortedFavorites = _sortCharacters(favorites, currentSort);

      emit(state.copyWith(
        favorites: sortedFavorites,
        isLoading: false,
        sortOption: currentSort,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        errorMessage: e.toString(),
        sortOption: currentSort,
      ));
    }
  }

  Future<void> removeFromFavorites(int characterId) async {
    await repository.removeFromFavorites(characterId);
  }

  Future<void> changeSort(SortOption sortOption) async {
    await loadFavorites(sortOption: sortOption);
  }

  List<Character> _sortCharacters(List<Character> characters, SortOption sortOption) {
    final sorted = List<Character>.from(characters);

    switch (sortOption) {
      case SortOption.nameAsc:
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.nameDesc:
        sorted.sort((a, b) => b.name.compareTo(a.name));
        break;
      case SortOption.status:
        sorted.sort((a, b) => a.status.compareTo(b.status));
        break;
      case SortOption.species:
        sorted.sort((a, b) => a.species.compareTo(b.species));
        break;
    }

    return sorted;
  }
}