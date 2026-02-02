import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'injection_container.dart' as di;
import 'presentation/bloc/character_bloc.dart';
import 'presentation/bloc/character_event.dart';
import 'presentation/bloc/connectivity_bloc.dart';
import 'presentation/bloc/favorite_bloc.dart';
import 'data/models/character_model.dart';
import 'presentation/bloc/theme_cubit.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CharacterModelAdapter());

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<CharacterBloc>()..add(const CharacterFetch()),
        ),
        BlocProvider(
          create: (context) => di.sl<FavoriteBloc>()..add(LoadFavorites()),
        ),
        BlocProvider(create: (_) => di.sl<ThemeCubit>()),
        BlocProvider(create: (_) => di.sl<ConnectivityBloc>()),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDark) {
          return MaterialApp(
            title: 'Rick and Morty',
            debugShowCheckedModeBanner: false,
            theme: isDark ? ThemeData.dark() : ThemeData.light(),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
