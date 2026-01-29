import 'package:equatable/equatable.dart';

class Character extends Equatable {
  final int id;
  final String name;
  final String status;
  final String species;
  final String imageUrl;
  final String locationName;

  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.imageUrl,
    required this.locationName,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    status,
    species,
    imageUrl,
    locationName,
  ];
}
