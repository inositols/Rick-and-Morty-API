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
        final newCharacters = await repository.getAllCharacters(nextPage);

        if (newCharacters.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          emit(
            CharacterLoaded(
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
}
