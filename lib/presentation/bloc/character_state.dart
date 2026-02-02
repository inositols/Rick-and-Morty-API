import 'package:equatable/equatable.dart';
import '../../domain/entities/character.dart';

abstract class CharacterState extends Equatable {
  const CharacterState();

  @override
  List<Object?> get props => [];
}

class CharacterLoading extends CharacterState {}

class CharacterLoaded extends CharacterState {
  final List<Character> characters;
  final bool hasReachedMax;
  final int page;
  final String? errorMessage;
  final String searchQuery;
  final String? status;
  final String? species;

  const CharacterLoaded({
    required this.characters,
    this.hasReachedMax = false,
    this.page = 1,
    this.errorMessage,
    this.searchQuery = '',
    this.status,
    this.species,
  });

  CharacterLoaded copyWith({
    List<Character>? characters,
    bool? hasReachedMax,
    int? page,
    String? errorMessage,
    String? searchQuery,
    String? status,
    String? species,
  }) {
    return CharacterLoaded(
      characters: characters ?? this.characters,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      status: status ?? this.status,
      species: species ?? this.species,
    );
  }

  @override
  List<Object?> get props => [
    characters,
    hasReachedMax,
    page,
    errorMessage,
    searchQuery,
    status,
    species,
  ];
}

class CharacterError extends CharacterState {
  final String message;

  const CharacterError(this.message);

  @override
  List<Object> get props => [message];
}
