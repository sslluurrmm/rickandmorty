import 'package:hive/hive.dart';
import 'package:rick_and_morty_app/domain/entities/character.dart';

part 'hive_character.g.dart';

@HiveType(typeId: 0)
class HiveCharacter extends HiveObject {
  @HiveField(0) final int id;
  @HiveField(1) final String name;
  @HiveField(2) final String status;
  @HiveField(3) final String species;
  @HiveField(4) final String gender;
  @HiveField(5) final String image;
  @HiveField(6) final String location;

  HiveCharacter({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.image,
    required this.location,
  });

  factory HiveCharacter.fromCharacter(Character character) => HiveCharacter(
    id: character.id,
    name: character.name,
    status: character.status,
    species: character.species,
    gender: character.gender,
    image: character.image,
    location: character.location,
  );

  Character toCharacter() => Character(
    id: id,
    name: name,
    status: status,
    species: species,
    gender: gender,
    image: image,
    location: location,
  );
}