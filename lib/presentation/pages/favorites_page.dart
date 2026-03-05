import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/domain/entities/character.dart';
import 'package:rick_and_morty_app/domain/entities/sort_option.dart';
import 'package:rick_and_morty_app/presentation/blocs/favorites/favorites_cubit.dart';
import 'package:rick_and_morty_app/presentation/blocs/favorites/favorites_state.dart';
import 'package:rick_and_morty_app/presentation/widgets/character_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star_border, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'Нет избранных персонажей',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  'Добавьте персонажей в избранное на главном экране',
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            _buildSortPanel(context, state.sortOption),
            Expanded(
              child: ListView.builder(
                itemCount: state.favorites.length,
                itemBuilder: (context, index) {
                  final character = state.favorites[index];
                  return Dismissible(
                    key: Key(character.id.toString()),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      context.read<FavoritesCubit>().removeFromFavorites(character.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${character.name} удален из избранного'),
                          action: SnackBarAction(
                            label: 'Отмена',
                            onPressed: () {
                              context.read<FavoritesCubit>().loadFavorites();
                            },
                          ),
                        ),
                      );
                    },
                    child: CharacterCard(
                      character: character,
                      isFavorite: true,
                      onFavoriteTap: () {
                        context.read<FavoritesCubit>().removeFromFavorites(character.id);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSortPanel(BuildContext context, SortOption currentSort) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1e1e1e)
          : Colors.grey[100],
      child: Row(
        children: [
          const Text('Сортировка:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButton<SortOption>(
              value: currentSort,
              items: SortOption.values.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option.label),
                );
              }).toList(),
              onChanged: (SortOption? newValue) {
                if (newValue != null) {
                  context.read<FavoritesCubit>().changeSort(newValue);
                }
              },
              isExpanded: true,
              underline: Container(),
              icon: const Icon(Icons.arrow_drop_down),
            ),
          ),
        ],
      ),
    );
  }
}