import 'package:rick_and_morty_app/domain/entities/character.dart';

class CharacterModel {
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String image;
  final Map<String, dynamic> location;

  CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.image,
    required this.location,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) => CharacterModel(
    id: json['id'],
    name: json['name'],
    status: json['status'],
    species: json['species'],
    gender: json['gender'],
    image: json['image'],
    location: json['location'],
  );

  Character toEntity() => Character(
    id: id,
    name: name,
    status: status,
    species: species,
    gender: gender,
    image: image,
    location: location['name'] ?? 'Unknown',
  );
}