import 'package:dio/dio.dart';
import '../../core/constants.dart';
import '../models/character_model.dart';

abstract class CharacterRemoteDataSource {
  Future<List<CharacterModel>> getAllCharacters(
    int page, {
    String? name,
    String? status,
    String? species,
  });
}

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final Dio dio;

  CharacterRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CharacterModel>> getAllCharacters(
    int page, {
    String? name,
    String? status,
    String? species,
  }) async {
    final Map<String, dynamic> queryParameters = {'page': page};
    if (name != null && name.isNotEmpty) queryParameters['name'] = name;
    if (status != null && status.isNotEmpty) queryParameters['status'] = status;
    if (species != null && species.isNotEmpty) {
      queryParameters['species'] = species;
    }

    try {
      final response = await dio.get(
        AppConstants.baseUrl + AppConstants.characterEndpoint,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];
        return results.map((json) => CharacterModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load characters from API');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return []; // No characters found for this search
      }
      rethrow;
    }
  }
}
