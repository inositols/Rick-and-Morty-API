import 'package:equatable/equatable.dart';
import '../../domain/entities/character.dart';

abstract class CharacterState extends Equatable {
  const CharacterState();

  @override
  List<Object> get props => [];
}

class CharacterLoading extends CharacterState {}

class CharacterLoaded extends CharacterState {
  final List<Character> characters;
  final bool hasReachedMax;
  final int page;

  const CharacterLoaded({
    required this.characters,
    this.hasReachedMax = false,
    this.page = 1,
  });

  // Helper to copy state but change specific fields (Pagination magic)
  CharacterLoaded copyWith({
    List<Character>? characters,
    bool? hasReachedMax,
    int? page,
  }) {
    return CharacterLoaded(
      characters: characters ?? this.characters,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
    );
  }

  @override
  List<Object> get props => [characters, hasReachedMax, page];
}

class CharacterError extends CharacterState {
  final String message;

  const CharacterError(this.message);

  @override
  List<Object> get props => [message];
}
