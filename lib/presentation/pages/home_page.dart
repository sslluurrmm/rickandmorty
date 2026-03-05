import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/presentation/blocs/theme/theme_cubit.dart';
import 'package:rick_and_morty_app/presentation/pages/characters_page.dart';
import 'package:rick_and_morty_app/presentation/pages/favorites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final _pages = const [
    CharactersPage(),
    FavoritesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick and Morty'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_medium),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
            tooltip: 'Переключить тему',
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Персонажи',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Избранное',
          ),
        ],
      ),
    );
  }
}