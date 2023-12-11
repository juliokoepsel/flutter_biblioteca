import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_biblioteca/author.dart';
import 'package:flutter_biblioteca/publisher.dart';
import 'package:flutter_biblioteca/genre.dart';
import 'package:flutter_biblioteca/book.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'library.db'),
      onCreate: (database, version) async {
        await database.execute(
          '''CREATE TABLE author(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            name TINYTEXT NOT NULL)''',
        );
        await database.execute(
          '''CREATE TABLE publisher(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            name TINYTEXT NOT NULL)''',
        );
        await database.execute(
          '''CREATE TABLE genre(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            name TINYTEXT NOT NULL)''',
        );
        await database.execute(
          '''CREATE TABLE book(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            title TINYTEXT NOT NULL,
            year INTEGER NOT NULL,
            author_id INTEGER NOT NULL,
            publisher_id INTEGER NOT NULL,
            genre_id INTEGER NOT NULL,
            FOREIGN KEY (author_id) REFERENCES author (id) ON DELETE RESTRICT ON UPDATE CASCADE, 
            FOREIGN KEY (publisher_id) REFERENCES publisher (id) ON DELETE RESTRICT ON UPDATE CASCADE, 
            FOREIGN KEY (genre_id) REFERENCES genre (id) ON DELETE RESTRICT ON UPDATE CASCADE)''',
        );
      },
      version: 1,
    );
  }

  Future<int> insertAuthor(List<Author> objs) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var obj in objs) {
      result = await db.insert('author', obj.toMap());
    }
    return result;
  }

  Future<List<Author>> retrieveAuthors() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('author');
    return queryResult.map((e) => Author.fromMap(e)).toList();
  }

  Future<Author> retrieveSingleAuthor(int id) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('author', where: "id = ?", whereArgs: [id], limit: 1);
    return queryResult.map((e) => Author.fromMap(e)).toList().first;
  }

  Future<void> deleteAuthor(int id) async {
    final db = await initializeDB();
    await db.delete(
      'author',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> insertPublisher(List<Publisher> objs) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var obj in objs) {
      result = await db.insert('publisher', obj.toMap());
    }
    return result;
  }

  Future<List<Publisher>> retrievePublishers() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('publisher');
    return queryResult.map((e) => Publisher.fromMap(e)).toList();
  }

  Future<Publisher> retrieveSinglePublisher(int id) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('publisher', where: "id = ?", whereArgs: [id], limit: 1);
    return queryResult.map((e) => Publisher.fromMap(e)).toList().first;
  }

  Future<void> deletePublisher(int id) async {
    final db = await initializeDB();
    await db.delete(
      'publisher',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> insertGenre(List<Genre> objs) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var obj in objs) {
      result = await db.insert('genre', obj.toMap());
    }
    return result;
  }

  Future<List<Genre>> retrieveGenres() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('genre');
    return queryResult.map((e) => Genre.fromMap(e)).toList();
  }

  Future<Genre> retrieveSingleGenre(int id) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult =
        await db.query('author', where: "id = ?", whereArgs: [id], limit: 1);
    return queryResult.map((e) => Genre.fromMap(e)).toList().first;
  }

  Future<void> deleteGenre(int id) async {
    final db = await initializeDB();
    await db.delete(
      'genre',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> insertBook(List<Book> objs) async {
    int result = 0;
    final Database db = await initializeDB();
    for (var obj in objs) {
      result = await db.insert('book', obj.toMap());
    }
    return result;
  }

  Future<List<Book>> retrieveBooks() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query('book');
    return queryResult.map((e) => Book.fromMap(e)).toList();
  }

  Future<void> deleteBook(int id) async {
    final db = await initializeDB();
    await db.delete(
      'book',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
