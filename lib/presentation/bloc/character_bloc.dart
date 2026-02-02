import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import '../../domain/repositories/character_repository.dart';
import 'character_event.dart';
import 'character_state.dart';

EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final CharacterRepository repository;

  CharacterBloc({required this.repository}) : super(CharacterLoading()) {
    on<CharacterFetch>(_onCharacterFetch, transformer: restartable());
    on<CharacterLoadMore>(_onCharacterLoadMore, transformer: droppable());
    on<CharacterSearchChanged>(
      _onCharacterSearchChanged,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
    on<CharacterFilterChanged>(
      _onCharacterFilterChanged,
      transformer: restartable(),
    );
  }

  Future<void> _onCharacterFetch(
    CharacterFetch event,
    Emitter<CharacterState> emit,
  ) async {
    // If it's a reset (like pull-to-refresh), we show loading
    if (event.reset) {
      emit(CharacterLoading());
    }

    try {
      final characters = await repository.getAllCharacters(1);
      emit(CharacterLoaded(characters: characters, page: 1));
    } catch (e) {
      emit(CharacterError("Failed to fetch data: $e"));
    }
  }

  Future<void> _onCharacterLoadMore(
    CharacterLoadMore event,
    Emitter<CharacterState> emit,
  ) async {
    final currentState = state;
    if (currentState is CharacterLoaded) {
      if (currentState.hasReachedMax) return;

      try {
        final nextPage = currentState.page + 1;
        final newCharacters = await repository.getAllCharacters(
          nextPage,
          name: currentState.searchQuery,
          status: currentState.status,
          species: currentState.species,
        );

        if (newCharacters.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          emit(
            currentState.copyWith(
              characters: currentState.characters + newCharacters,
              page: nextPage,
              hasReachedMax: false,
              errorMessage: null,
            ),
          );
        }
      } catch (e) {
        emit(
          currentState.copyWith(
            errorMessage: "Failed to load more: ${e.toString()}",
          ),
        );
      }
    }
  }

  Future<void> _onCharacterSearchChanged(
    CharacterSearchChanged event,
    Emitter<CharacterState> emit,
  ) async {
    emit(CharacterLoading());
    try {
      final characters = await repository.getAllCharacters(1, name: event.query);
      emit(
        CharacterLoaded(
          characters: characters,
          page: 1,
          searchQuery: event.query,
          hasReachedMax: characters.length < 20, // Simple heuristic
        ),
      );
    } catch (e) {
      emit(CharacterError("Search failed: $e"));
    }
  }

  Future<void> _onCharacterFilterChanged(
    CharacterFilterChanged event,
    Emitter<CharacterState> emit,
  ) async {
    emit(CharacterLoading());
    try {
      final characters = await repository.getAllCharacters(
        1,
        status: event.status,
        species: event.species,
      );
      emit(
        CharacterLoaded(
          characters: characters,
          page: 1,
          status: event.status,
          species: event.species,
          hasReachedMax: characters.length < 20,
        ),
      );
    } catch (e) {
      emit(CharacterError("Filtering failed: $e"));
    }
  }
}
