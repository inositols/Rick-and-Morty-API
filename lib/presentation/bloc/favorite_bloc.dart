import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/character.dart';
import '../../domain/repositories/character_repository.dart';

// EVENTS
abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();
  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoriteEvent {}

class ToggleFavorite extends FavoriteEvent {
  final Character character;
  const ToggleFavorite(this.character);
  @override
  List<Object> get props => [character];
}

// STATES
abstract class FavoriteState extends Equatable {
  const FavoriteState();
  @override
  List<Object> get props => [];
}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<Character> favorites;
  const FavoriteLoaded(this.favorites);

  // Helper to check if a specific character is a favorite
  bool isFavorite(int id) {
    return favorites.any((element) => element.id == id);
  }

  @override
  List<Object> get props => [favorites];
}

// BLOC
class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final CharacterRepository repository;

  FavoriteBloc({required this.repository}) : super(FavoriteLoading()) {
    on<LoadFavorites>((event, emit) {
      final favorites = repository.getFavorites();
      emit(FavoriteLoaded(favorites));
    });

    on<ToggleFavorite>((event, emit) async {
      final currentState = state;
      if (currentState is FavoriteLoaded) {
        final isFav = currentState.isFavorite(event.character.id);

        if (isFav) {
          await repository.removeFavorite(event.character);
        } else {
          await repository.addFavorite(event.character);
        }

        // Reload list to update UI
        final updatedFavorites = repository.getFavorites();
        emit(FavoriteLoaded(updatedFavorites));
      }
    });
  }
}
