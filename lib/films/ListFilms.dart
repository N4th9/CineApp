import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_2023/Confiseries/ListConfiseries.dart';
import 'package:project_2023/Connected/Identity.dart';
import 'package:project_2023/films/FormulaireFilm.dart';
import 'package:project_2023/main.dart';

// ignore: must_be_immutable
class FilmsPage extends StatefulWidget {
  List<Film> films;

  FilmsPage({Key? key, required this.films}) : super(key: key);

  @override
  _FilmsPageState createState() => _FilmsPageState();
}

class _FilmsPageState extends State<FilmsPage> {
  late FirebaseFirestore _db;

  @override
  void initState() {
    super.initState();
    _db = FirebaseFirestore.instance;
  }

  void _deleteFilm(String filmId) {
    _db.collection('films').doc(filmId).delete();
  }

  @override
  Widget build(BuildContext context) {
    var films = _db.collection('films').snapshots();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des films'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyHomePage(
                          films: [],
                          confiseries: [],
                        )),
              );
            },
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10.0),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FormulaireFilm(
                    films: const [],
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              foregroundColor: Colors.white,
              backgroundColor: Colors.redAccent,
              fixedSize: const Size(385, 40),
            ),
            child: const Text(
              'Ajouter un film',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            height: 500.0,
            child: StreamBuilder(
              stream: films,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data!.docs[index];
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16.0),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          _deleteFilm(ds.id);
                        },
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirmer la suppression"),
                                content: const Text(
                                    "Êtes-vous sûr de vouloir supprimer ce film?"),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text("Oui"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text("Non"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Card(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: Colors.black26,
                                width: 2.0,
                              ),
                            ),
                            child: ListTile(
                              title: Text(ds['title']),
                              subtitle: Text(
                                ds['description'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 10.0),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FilmsPage(
                            films: const [],
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    child: const Text(
                      'Films',
                      style: TextStyle(
                          color: Colors.deepPurpleAccent, fontSize: 16.0),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConfiseriesPage(
                            confiseries: const [],
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    child: const Text('Confiseries',
                        style: TextStyle(color: Colors.black, fontSize: 16.0)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const IdentityPage(
                            films: [],
                            confiseries: [],
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                    child: const Text('My Magic',
                        style: TextStyle(color: Colors.black, fontSize: 16.0)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
