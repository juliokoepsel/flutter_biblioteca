class Genre {
  final int? id;
  final String name;

  const Genre({
    this.id,
    required this.name,
  });

  Genre.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'genre{id: $id, name: $name}';
  }
}
