import 'package:equatable/equatable.dart';
import 'package:rick_and_morty_app/domain/entities/character.dart';

abstract class CharactersState extends Equatable {
  final List<Character> characters;
  final int currentPage;
  final bool hasMore;
  final bool isLoading;
  final String? error;
  final Map<int, bool> favoriteStatus;
  final bool isOffline;

  const CharactersState({
    required this.characters,
    required this.currentPage,
    required this.hasMore,
    required this.isLoading,
    this.error,
    this.favoriteStatus = const {},
    this.isOffline = false,
  });

  @override
  List<Object?> get props => [
    characters,
    currentPage,
    hasMore,
    isLoading,
    error,
    favoriteStatus,
    isOffline,
  ];
}

class CharactersInitial extends CharactersState {
  const CharactersInitial()
      : super(
    characters: const [],
    currentPage: 0,
    hasMore: true,
    isLoading: false,
    error: null,
  );
}

class CharactersLoaded extends CharactersState {
  const CharactersLoaded({
    required super.characters,
    required super.currentPage,
    required super.hasMore,
    required super.favoriteStatus,
    super.isLoading = false,
    super.error,
    super.isOffline = false,
  });
}