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
  @override
  @HiveField(6)
  final String gender;
  @override
  @HiveField(7)
  final String type;
  @override
  @HiveField(8)
  final String originName;
  @override
  @HiveField(9)
  final List<String> episodes;

  const CharacterModel({
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
  }) : super(
         id: id,
         name: name,
         status: status,
         species: species,
         imageUrl: imageUrl,
         locationName: locationName,
         gender: gender,
         type: type,
         originName: originName,
         episodes: episodes,
       );

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      imageUrl: json['image'],
      locationName: json['location']?['name'] ?? 'Unknown',
      gender: json['gender'] ?? 'Unknown',
      type: json['type'] ?? '',
      originName: json['origin']?['name'] ?? 'Unknown',
      episodes: List<String>.from(json['episode'] ?? []),
    );
  }
}
