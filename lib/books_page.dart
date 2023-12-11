import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_biblioteca/database.dart';
import 'package:flutter_biblioteca/book.dart';
import 'package:flutter_biblioteca/author.dart';
import 'package:flutter_biblioteca/publisher.dart';
import 'package:flutter_biblioteca/genre.dart';

class Books extends StatefulWidget {
  const Books({super.key, required this.title});

  final String title;

  @override
  State<Books> createState() => _BooksState();
}

class _BooksState extends State<Books> {
  late DatabaseHandler handler;
  late List<Author> authors;
  late List<Publisher> publishers;
  late List<Genre> genres;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {
      authors = await handler.retrieveAuthors();
      publishers = await handler.retrievePublishers();
      genres = await handler.retrieveGenres();
      setState(() {});
    });
  }

  final TextEditingController titleController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  int? authorId, publisherId, genreId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Livros")),
      body: FutureBuilder(
        future: Future.wait([
          handler.retrieveBooks(),
          handler.retrieveAuthors(),
          handler.retrievePublishers(),
          handler.retrieveGenres(),
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?[0].length,
              itemBuilder: (BuildContext context, int index) {
                Author author = const Author(name: 'null');
                for (var o in snapshot.data?[1]) {
                  if (o.id == snapshot.data![0][index].author) {
                    author = o;
                  }
                }
                Publisher publisher = const Publisher(name: 'null');
                for (var o in snapshot.data?[2]) {
                  if (o.id == snapshot.data![0][index].publisher) {
                    publisher = o;
                  }
                }
                Genre genre = const Genre(name: 'null');
                for (var o in snapshot.data?[3]) {
                  if (o.id == snapshot.data![0][index].genre) {
                    genre = o;
                  }
                }
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: const Icon(Icons.delete_forever),
                  ),
                  key: ValueKey<int>(snapshot.data![0][index].id!),
                  onDismissed: (DismissDirection direction) async {
                    await handler.deleteBook(snapshot.data![0][index].id!);
                    setState(() {
                      snapshot.data![0].remove(snapshot.data![0][index]);
                    });
                  },
                  child: Card(
                      child: ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    title: Text(snapshot.data![0][index].title),
                    subtitle: Text(
                        "${author.name}\n${publisher.name} ${snapshot.data![0][index].year}\n(${genre.name})"),
                  )),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Text('Biblioteca', style: TextStyle(fontSize: 30)),
            ),
            ListTile(
              title: const Text('Livros'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/books');
              },
            ),
            ListTile(
              title: const Text('Autores'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/authors');
              },
            ),
            ListTile(
              title: const Text('Editoras'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/publishers');
              },
            ),
            ListTile(
              title: const Text('Gêneros'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/genres');
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (authors.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Nenhum Autor Registrado!")));
          } else if (publishers.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Nenhuma Editora Registrada!")));
          } else if (genres.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Nenhum Gênero Registrado!")));
          } else {
            showModalBottomSheet(
              elevation: 5,
              isScrollControlled: true,
              context: context,
              builder: (_) => Container(
                  padding: EdgeInsets.only(
                    top: 30,
                    left: 15,
                    right: 15,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 50,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Título do Livro",
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: yearController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Ano de Publicação",
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Autor",
                        ),
                        value: null,
                        items:
                            authors.map<DropdownMenuItem<int>>((Author author) {
                          return DropdownMenuItem<int>(
                            value: author.id,
                            child: Text(author.name),
                          );
                        }).toList(),
                        onChanged: (int? selectedId) {
                          authorId = selectedId;
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Editora",
                        ),
                        value: null,
                        items: publishers
                            .map<DropdownMenuItem<int>>((Publisher publisher) {
                          return DropdownMenuItem<int>(
                            value: publisher.id,
                            child: Text(publisher.name),
                          );
                        }).toList(),
                        onChanged: (int? selectedId) {
                          publisherId = selectedId;
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Gênero",
                        ),
                        value: null,
                        items: genres.map<DropdownMenuItem<int>>((Genre genre) {
                          return DropdownMenuItem<int>(
                            value: genre.id,
                            child: Text(genre.name),
                          );
                        }).toList(),
                        onChanged: (int? selectedId) {
                          genreId = selectedId;
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            var obj = Book(
                                title: titleController.text,
                                year: int.parse(yearController.text),
                                author: authorId!,
                                publisher: publisherId!,
                                genre: genreId!);
                            await addObj(obj);
                            setState(() {});
                            titleController.text = "";
                            yearController.text = "";
                            Navigator.of(context).pop();
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(18),
                            child: Text(
                              "Adicionar",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            );
          }
        },
        tooltip: 'Adicionar Livro',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<int> addObj(Book obj) async {
    List<Book> objs = [obj];
    return await handler.insertBook(objs);
  }
}
