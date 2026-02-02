import 'package:equatable/equatable.dart';

class Character extends Equatable {
  final int id;
  final String name;
  final String status;
  final String species;
  final String imageUrl;
  final String locationName;
  final String gender;
  final String type;
  final String originName;
  final List<String> episodes;

  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.imageUrl,
    required this.locationName,
    required this.gender,
    required this.type,
    required this.originName,
    required this.episodes,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    status,
    species,
    imageUrl,
    locationName,
    gender,
    type,
    originName,
    episodes,
  ];
}
