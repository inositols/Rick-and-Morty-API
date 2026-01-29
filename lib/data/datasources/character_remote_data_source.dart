import 'package:dio/dio.dart';
import '../../core/constants.dart';
import '../models/character_model.dart';

abstract class CharacterRemoteDataSource {
  Future<List<CharacterModel>> getAllCharacters(int page);
}

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final Dio dio;

  CharacterRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CharacterModel>> getAllCharacters(int page) async {
    // [cite: 3, 5] Fetching from Rick and Morty API
    final response = await dio.get(
      AppConstants.baseUrl + AppConstants.characterEndpoint,
      queryParameters: {'page': page},
    );

    if (response.statusCode == 200) {
      final List<dynamic> results = response.data['results'];
      return results.map((json) => CharacterModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load characters from API');
    }
  }
}
