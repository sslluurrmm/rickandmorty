class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String image;
  final String location;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.image,
    required this.location,
  });

  factory Character.fromMap(Map<String, dynamic> json) => Character(
    id: json['id'] as int,
    name: json['name'] as String,
    status: json['status'] as String,
    species: json['species'] as String,
    gender: json['gender'] as String,
    image: json['image'] as String? ?? 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
    location: (json['location'] as Map<String, dynamic>)['name'] as String? ?? 'Unknown',
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'status': status,
    'species': species,
    'gender': gender,
    'image': image,
    'location': location,
  };
}