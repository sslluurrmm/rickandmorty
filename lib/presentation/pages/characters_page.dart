import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/domain/entities/character.dart';
import 'package:rick_and_morty_app/presentation/blocs/characters/characters_cubit.dart';
import 'package:rick_and_morty_app/presentation/blocs/characters/characters_state.dart';
import 'package:rick_and_morty_app/presentation/widgets/character_card.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<CharactersCubit>();
      if (cubit.state.characters.isEmpty && !cubit.state.isLoading) {
        cubit.loadCharacters(clear: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!context.read<CharactersCubit>().state.isLoading) {
        context.read<CharactersCubit>().loadCharacters();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CharactersCubit, CharactersState>(
      listener: (context, state) {
        if (state.error != null && !state.isLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Повторить',
                onPressed: () => context.read<CharactersCubit>().loadCharacters(),
              ),
            ),
          );
        }
      },
      child: BlocBuilder<CharactersCubit, CharactersState>(
        builder: (context, state) {
          if (state is CharactersInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.characters.isEmpty && !state.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    state.isOffline ? Icons.wifi_off : Icons.person_outline,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.isOffline
                        ? 'Нет избранных персонажей для офлайн-просмотра'
                        : 'Нет персонажей',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<CharactersCubit>().loadCharacters(clear: true);
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                if (state.isOffline)
                  SliverToBoxAdapter(
                    child: Container(
                      color: Colors.orange.shade100,
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Icon(Icons.wifi_off, color: Colors.orange.shade800),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              state.error ?? 'Нет подключения к интернету. Показаны избранные персонажи.',
                              style: TextStyle(color: Colors.orange.shade800),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      if (index >= state.characters.length) {
                        if (state.isLoading && state.hasMore) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return const SizedBox.shrink();
                      }
                      final character = state.characters[index];
                      final isFavorite = context.read<CharactersCubit>().isCharacterFavorite(character.id);
                      return CharacterCard(
                        character: character,
                        isFavorite: isFavorite,
                        onFavoriteTap: () => context.read<CharactersCubit>().toggleFavorite(character),
                      );
                    },
                    childCount: state.characters.length + (state.isLoading && state.hasMore ? 1 : 0),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}