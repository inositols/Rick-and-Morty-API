import 'package:hive/hive.dart';
import '../../domain/entities/character.dart';

// This line is required for build_runner to generate the adapter
part 'character_model.g.dart';

@HiveType(typeId: 0)
class CharacterModel extends Character {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String status;
  @HiveField(3)
  final String species;
  @HiveField(4)
  final String imageUrl;
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
      // Safe extraction of nested location name
      locationName: json['location']?['name'] ?? 'Unknown',
    );
  }
}
