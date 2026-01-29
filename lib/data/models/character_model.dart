// ignore_for_file: overridden_fields

import 'package:hive/hive.dart';
import '../../domain/entities/character.dart';
part 'character_model.g.dart';

@HiveType(typeId: 0)
class CharacterModel extends Character {
  @override
  @HiveField(0)
  final int id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final String status;
  @override
  @HiveField(3)
  final String species;
  @override
  @HiveField(4)
  final String imageUrl;
  @override
  @HiveField(5)
  final String locationName;

  const CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.imageUrl,
    required this.locationName,
  }) : super(
         id: id,
         name: name,
         status: status,
         species: species,
         imageUrl: imageUrl,
         locationName: locationName,
       );

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      imageUrl: json['image'],
      locationName: json['location']?['name'] ?? 'Unknown',
    );
  }
}
