import 'package:flutter/material.dart';
import 'package:flutter_biblioteca/database.dart';
import 'package:flutter_biblioteca/publisher.dart';

class Publishers extends StatefulWidget {
  const Publishers({super.key, required this.title});

  final String title;

  @override
  State<Publishers> createState() => _PublishersState();
}

class _PublishersState extends State<Publishers> {
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
      appBar: AppBar(title: const Text("Editoras")),
      body: FutureBuilder(
        future: handler.retrievePublishers(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Publisher>> snapshot) {
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
                    await handler.deletePublisher(snapshot.data![index].id!);
                    setState(() {
                      snapshot.data!.remove(snapshot.data![index]);
                    });
                  },
                  child: Card(
                      child: ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    title: Text(snapshot.data![index].name),
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
                        hintText: "Nome da Editora",
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          var obj = Publisher(name: nameController.text);
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
        tooltip: 'Adicionar Editora',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<int> addObj(Publisher obj) async {
    List<Publisher> objs = [obj];
    return await handler.insertPublisher(objs);
  }
}
