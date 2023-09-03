class Attraction {
  final int id;
  final String name;
  final String description;
  final String imagePath;

  Attraction(
      {required this.id,
      required this.name,
      required this.description,
      required this.imagePath});

  factory Attraction.fromMap(Map<String, dynamic> json) => Attraction(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        imagePath: json["imagePath"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "imagePath": imagePath,
      };
}
