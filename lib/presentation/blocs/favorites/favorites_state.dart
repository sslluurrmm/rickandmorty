import 'package:equatable/equatable.dart';
import 'package:rick_and_morty_app/domain/entities/character.dart';
import 'package:rick_and_morty_app/domain/entities/sort_option.dart';

class FavoritesState extends Equatable {
  final List<Character> favorites;
  final bool isLoading;
  final bool isError;
  final String errorMessage;
  final SortOption sortOption;

  const FavoritesState({
    required this.favorites,
    required this.isLoading,
    required this.isError,
    this.errorMessage = '',
    this.sortOption = SortOption.nameAsc,
  });

  factory FavoritesState.initial() => const FavoritesState(
    favorites: [],
    isLoading: false,
    isError: false,
    sortOption: SortOption.nameAsc,
  );

  FavoritesState copyWith({
    List<Character>? favorites,
    bool? isLoading,
    bool? isError,
    String? errorMessage,
    SortOption? sortOption,
  }) => FavoritesState(
    favorites: favorites ?? this.favorites,
    isLoading: isLoading ?? this.isLoading,
    isError: isError ?? this.isError,
    errorMessage: errorMessage ?? this.errorMessage,
    sortOption: sortOption ?? this.sortOption,
  );

  @override
  List<Object> get props => [favorites, isLoading, isError, errorMessage, sortOption];
}