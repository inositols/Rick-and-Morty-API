import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants.dart';
import 'data/datasources/character_local_data_source.dart';
import 'data/datasources/character_remote_data_source.dart';
import 'data/repositories/character_repository_impl.dart';
import 'domain/repositories/character_repository.dart';
import 'presentation/bloc/character_bloc.dart';
import 'presentation/bloc/favorite_bloc.dart';
import 'presentation/bloc/theme_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final box = await Hive.openBox(AppConstants.hiveBoxName);
  sl.registerLazySingleton(() => box);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton<CharacterRemoteDataSource>(
    () => CharacterRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<CharacterLocalDataSource>(
    () => CharacterLocalDataSourceImpl(box: sl()),
  );
  sl.registerFactory(() => CharacterBloc(repository: sl()));
  await Hive.initFlutter();

  final favoritesBox = await Hive.openBox(AppConstants.favoritesBoxName);

  sl.registerLazySingleton(() => favoritesBox, instanceName: 'favoritesBox');
  sl.registerLazySingleton<CharacterRepository>(
    () => CharacterRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      favoritesBox: sl(instanceName: 'favoritesBox'),
    ),
  );
  sl.registerFactory(() => FavoriteBloc(repository: sl()));
  sl.registerFactory(() => ThemeCubit());
}
