import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/character_repository.dart';
import 'character_event.dart';
import 'character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final CharacterRepository repository;

  CharacterBloc({required this.repository}) : super(CharacterLoading()) {
    on<CharacterFetch>(_onCharacterFetch);
    on<CharacterLoadMore>(_onCharacterLoadMore);
  }

  Future<void> _onCharacterFetch(
    CharacterFetch event,
    Emitter<CharacterState> emit,
  ) async {
    try {
      // Load Page 1
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

    // Only load more if we are currently in a "Loaded" state
    if (currentState is CharacterLoaded) {
      if (currentState.hasReachedMax) return;

      try {
        final nextPage = currentState.page + 1;
        final newCharacters = await repository.getAllCharacters(nextPage);

        if (newCharacters.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          emit(
            CharacterLoaded(
              characters:
                  currentState.characters + newCharacters, // Append list
              page: nextPage,
              hasReachedMax: false,
            ),
          );
        }
      } catch (e) {
        // If pagination fails (e.g. offline and no cached next page),
        // we keep the current list but maybe show a snackbar (handled in UI).
        // For now, we don't emit Error state to avoid replacing the list with an error screen.
      }
    }
  }
}
