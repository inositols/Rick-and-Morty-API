import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants.dart';
import 'data/datasources/character_local_data_source.dart';
import 'data/datasources/character_remote_data_source.dart';
import 'data/models/character_model.dart';
import 'data/repositories/character_repository_impl.dart';
import 'domain/repositories/character_repository.dart';
import 'presentation/bloc/character_bloc.dart';
import 'presentation/bloc/favorite_bloc.dart';
import 'presentation/bloc/theme_cubit.dart';

final sl = GetIt.instance; // sl = Service Locator

Future<void> init() async {
  // 1. External (Libraries)
  final box = await Hive.openBox(AppConstants.hiveBoxName);
  sl.registerLazySingleton(() => box);
  sl.registerLazySingleton(() => Dio());

  // 2. Data Sources
  sl.registerLazySingleton<CharacterRemoteDataSource>(
    () => CharacterRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<CharacterLocalDataSource>(
    () => CharacterLocalDataSourceImpl(box: sl()),
  );

  // 4. BLoC (State Management)
  // We will create this in the next Phase
  sl.registerFactory(() => CharacterBloc(repository: sl()));
  // Inside init() function...

  // 1. External
  await Hive.initFlutter();

  final favoritesBox = await Hive.openBox(
    AppConstants.favoritesBoxName,
  ); // <--- OPEN THIS

  sl.registerLazySingleton(() => favoritesBox, instanceName: 'favoritesBox');

  // 2. Repository
  // Update the repository registration
  sl.registerLazySingleton<CharacterRepository>(
    () => CharacterRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      favoritesBox: sl(instanceName: 'favoritesBox'), // <--- INJECT IT HERE
    ),
  );
  sl.registerFactory(() => FavoriteBloc(repository: sl()));
  sl.registerFactory(() => ThemeCubit());
}
