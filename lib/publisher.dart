class Publisher {
  final int? id;
  final String name;

  const Publisher({
    this.id,
    required this.name,
  });

  Publisher.fromMap(Map<String, dynamic> res)
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
    return 'publisher{id: $id, name: $name}';
  }
}
