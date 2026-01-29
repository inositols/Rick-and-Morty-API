import 'package:equatable/equatable.dart';

abstract class CharacterEvent extends Equatable {
  const CharacterEvent();

  @override
  List<Object> get props => [];
}

// Triggered when the user first opens the screen
class CharacterFetch extends CharacterEvent {}

// Triggered when the user scrolls to the bottom (Pagination)
class CharacterLoadMore extends CharacterEvent {}
