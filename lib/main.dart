import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rick_and_morty_app/data/datasources/character_remote_data_source.dart';
import 'package:rick_and_morty_app/data/models/hive_character.dart';
import 'package:rick_and_morty_app/data/repositories/character_repository_impl.dart';
import 'package:rick_and_morty_app/domain/repositories/character_repository.dart';
import 'package:rick_and_morty_app/presentation/blocs/characters/characters_cubit.dart';
import 'package:rick_and_morty_app/presentation/blocs/favorites/favorites_cubit.dart';
import 'package:rick_and_morty_app/presentation/blocs/theme/theme_cubit.dart';
import 'package:rick_and_morty_app/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(HiveCharacterAdapter());
  final favoritesBox = await Hive.openBox<HiveCharacter>('favorites');
  final preferencesBox = await Hive.openBox('preferences');

  final remoteDataSource = CharacterRemoteDataSource();
  final repository = CharacterRepositoryImpl(
    remoteDataSource: remoteDataSource,
    favoritesBox: favoritesBox,
  );

  runApp(MyApp(
    repository: repository,
    favoritesBox: favoritesBox,
    preferencesBox: preferencesBox,
  ));
}

class MyApp extends StatelessWidget {
  final CharacterRepository repository;
  final Box<HiveCharacter> favoritesBox;
  final Box preferencesBox;

  const MyApp({
    super.key,
    required this.repository,
    required this.favoritesBox,
    required this.preferencesBox,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CharactersCubit(repository)),
        BlocProvider(create: (_) => FavoritesCubit(repository, favoritesBox)..loadFavorites()),
        BlocProvider(create: (_) => ThemeCubit(preferencesBox)),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Rick and Morty',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              useMaterial3: true,
              cardColor: const Color(0xFF1e1e1e),
              scaffoldBackgroundColor: const Color(0xFF121212),
              colorScheme: ColorScheme.dark().copyWith(primary: Colors.purple),
            ),
            themeMode: themeMode,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}