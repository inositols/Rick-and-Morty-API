import 'package:equatable/equatable.dart';

abstract class CharacterEvent extends Equatable {
  const CharacterEvent();

  @override
  List<Object> get props => [];
}

// Triggered when the user first opens the screen or pulls to refresh
class CharacterFetch extends CharacterEvent {
  final bool reset;
  const CharacterFetch({this.reset = false});
  @override
  List<Object> get props => [reset];
}

// Triggered when the user scrolls to the bottom (Pagination)
class CharacterLoadMore extends CharacterEvent {}

// Triggered when the user types in the search bar
class CharacterSearchChanged extends CharacterEvent {
  final String query;
  const CharacterSearchChanged(this.query);
  @override
  List<Object> get props => [query];
}

// Triggered when the user changes status or species filters
class CharacterFilterChanged extends CharacterEvent {
  final String? status;
  final String? species;
  const CharacterFilterChanged({this.status, this.species});
  @override
  List<Object> get props => [status ?? '', species ?? ''];
}
