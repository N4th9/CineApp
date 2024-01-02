import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_2023/Confiseries/FormulaireConfiserie.dart';
import 'package:project_2023/Connected/Identity.dart';
import 'package:project_2023/films/ListFilms.dart';
import 'package:project_2023/main.dart';

// ignore: must_be_immutable
class ConfiseriesPage extends StatefulWidget {
  List<Confiserie> confiseries;

  ConfiseriesPage({Key? key, required this.confiseries}) : super(key: key);

  @override
  _ConfiseriesPageState createState() => _ConfiseriesPageState();
}

class _ConfiseriesPageState extends State<ConfiseriesPage> {
  late FirebaseFirestore _db;

  @override
  void initState() {
    super.initState();
    _db = FirebaseFirestore.instance;
  }

  void _deleteConfiserie(String confiserieId) {
    _db.collection('confiseries').doc(confiserieId).delete();
  }

  @override
  Widget build(BuildContext context) {
    var confiseries = _db.collection('confiseries').snapshots();
    return Scaffold(
      appBar: AppBar(
        title: const Text('List des sucreries'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 46, 107, 220),
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
                  builder: (context) => FormulaireConfiserie(
                    confiseries: const [],
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 46, 107, 220),
                fixedSize: const Size(385, 40)),
            child: const Text(
              'Ajouter une confiserie',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            height: 500.0,
            child: StreamBuilder(
              stream: confiseries,
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
                          _deleteConfiserie(ds.id);
                        },
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirmer la suppression"),
                                content: const Text(
                                    "Êtes-vous sûr de vouloir supprimer cette confiserie?"),
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
                              title: Text(ds['nom']),
                              subtitle: Text(ds['prix']),
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
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
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
                        style: TextStyle(
                            color: Colors.deepPurpleAccent, fontSize: 16.0)),
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

class Confiserie {
  String nom;
  String description;
  String imagePath;
  String salle;
  TimeOfDay horaire;

  Confiserie({
    required this.nom,
    required this.description,
    required this.imagePath,
    required this.salle,
    required this.horaire,
  });
}
