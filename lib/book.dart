class Book {
  final int? id;
  final String title;
  final int year;
  final int author;
  final int publisher;
  final int genre;

  const Book({
    this.id,
    required this.title,
    required this.year,
    required this.author,
    required this.publisher,
    required this.genre,
  });

  Book.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        year = res["year"],
        author = res["author_id"],
        publisher = res["publisher_id"],
        genre = res["genre_id"];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'year': year,
      'author_id': author,
      'publisher_id': publisher,
      'genre_id': genre,
    };
  }

  @override
  String toString() {
    return 'book{id: $id, title: $title, year: $year, author_id: $author, publisher_id: $publisher, genre_id: $genre}';
  }
}
