import 'dart:math';
import 'package:dio/dio.dart';
import 'package:rick_and_morty_app/domain/entities/character.dart';

class CharacterRemoteDataSource {
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'https://rickandmortyapi.com/api/',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    responseType: ResponseType.json,
  ));

  final Random _random = Random();

  Future<List<Character>> getCharacters({int page = 1}) async {
    int attempt = 0;
    const maxAttempts = 5;
    const baseDelay = Duration(seconds: 2);

    while (attempt < maxAttempts) {
      try {
        final response = await dio.get(
          '/character',
          queryParameters: {'page': page},
        );

        if (response.data == null ||
            response.data['results'] == null ||
            !(response.data['results'] is List)) {
          throw Exception('API: no "results"');
        }

        final results = response.data['results'] as List;
        return results
            .where((json) => json != null)
            .map((json) => Character.fromMap(json as Map<String, dynamic>))
            .toList();
      } on DioException catch (e) {
        attempt++;

        if (e.type == DioExceptionType.connectionError) {
          throw Exception('Нет подключения к интернету');
        }

        if (e.type == DioExceptionType.connectionTimeout) {
          if (attempt < maxAttempts) {
            final expDelay = baseDelay * (1 << (attempt - 1));
            final jitter = Duration(milliseconds: _random.nextInt(1000));
            final delay = expDelay + jitter;
            await Future.delayed(delay);
            continue;
          }
          throw Exception('Таймаут соединения. Проверьте интернет.');
        }

        if (e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          if (attempt < maxAttempts) {
            final expDelay = baseDelay * (1 << (attempt - 1));
            final jitter = Duration(milliseconds: _random.nextInt(1000));
            final delay = expDelay + jitter;
            await Future.delayed(delay);
            continue;
          }
          throw Exception('Таймаут загрузки. Проверьте интернет.');
        }

        if (e.response?.statusCode == 429 && attempt < maxAttempts) {
          final expDelay = baseDelay * (1 << (attempt - 1));
          final jitter = Duration(milliseconds: _random.nextInt(1000));
          final delay = expDelay + jitter;
          await Future.delayed(delay);
          continue;
        }

        if (attempt < maxAttempts) {
          final expDelay = baseDelay * (1 << (attempt - 1));
          final jitter = Duration(milliseconds: _random.nextInt(1000));
          final delay = expDelay + jitter;
          await Future.delayed(delay);
          continue;
        }

        rethrow;
      }
    }

    throw Exception('Не удалось загрузить данные после нескольких попыток');
  }
}