import 'package:flutter/material.dart';
import 'package:flutter_biblioteca/books_page.dart';
import 'package:flutter_biblioteca/authors_page.dart';
import 'package:flutter_biblioteca/publishers_page.dart';
import 'package:flutter_biblioteca/genres_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  databaseFactoryOrNull = databaseFactoryFfi;
  sqfliteFfiInit();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biblioteca Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/books',
      routes: {
        '/books': (context) => const Books(title: 'Livros'),
        '/authors': (context) => const Authors(title: 'Autores'),
        '/publishers': (context) => const Publishers(title: 'Editoras'),
        '/genres': (context) => const Genres(title: 'Gêneros'),
      },
    );
  }
}
