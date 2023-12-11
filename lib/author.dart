class Author {
  final int? id;
  final String name;

  const Author({
    this.id,
    required this.name,
  });

  Author.fromMap(Map<String, dynamic> res)
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
    return 'author{id: $id, name: $name}';
  }
}
