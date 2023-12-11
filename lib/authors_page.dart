import 'package:flutter/material.dart';
import 'package:flutter_biblioteca/database.dart';
import 'package:flutter_biblioteca/author.dart';

class Authors extends StatefulWidget {
  const Authors({super.key, required this.title});

  final String title;

  @override
  State<Authors> createState() => _AuthorsState();
}

class _AuthorsState extends State<Authors> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {
      setState(() {});
    });
  }

  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Autores")),
      body: FutureBuilder(
        future: handler.retrieveAuthors(),
        builder: (BuildContext context, AsyncSnapshot<List<Author>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: const Icon(Icons.delete_forever),
                  ),
                  key: ValueKey<int>(snapshot.data![index].id!),
                  onDismissed: (DismissDirection direction) async {
                    await handler.deleteAuthor(snapshot.data![index].id!);
                    setState(() {
                      snapshot.data!.remove(snapshot.data![index]);
                    });
                  },
                  child: Card(
                      child: ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    title: Text(snapshot.data![index].name),
                    //subtitle: Text(snapshot.data![index].name),
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
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Nome do Autor",
                      ),
                    ),
                    // const SizedBox(height: 10),
                    /* 
                    TextField(
                      controller: otherController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Other Info",
                      ),
                    ),
                    */
                    const SizedBox(height: 20),

                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          var obj = Author(name: nameController.text);
                          await addObj(obj);
                          setState(() {});
                          nameController.text = "";
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
        },
        tooltip: 'Adicionar Autor',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<int> addObj(Author obj) async {
    List<Author> objs = [obj];
    return await handler.insertAuthor(objs);
  }
}
