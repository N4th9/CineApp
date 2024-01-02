import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_2023/Connected/CommandesPage.dart';
import 'package:project_2023/main.dart';

class MyMagicPage extends StatefulWidget {
  const MyMagicPage({Key? key}) : super(key: key);

  @override
  _MyMagicPageState createState() => _MyMagicPageState();
}

class _MyMagicPageState extends State<MyMagicPage> {
  String? selectedFilm;
  String? selectedConfiserie;
  int? selectedQuantity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Magic"),
        centerTitle: true,
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyHomePage(
                    films: [],
                    confiseries: [],
                  ),
                ),
              );
            },
            icon: const Icon(Icons.dangerous),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Sélectionnez votre film:",
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('films').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                var films = snapshot.data!.docs.map((film) {
                  return DropdownMenuItem<String>(
                    value: film['title'],
                    child: Text(film['title']),
                  );
                }).toList();

                return DropdownButton<String>(
                  value: selectedFilm,
                  items: films,
                  onChanged: (value) {
                    setState(() {
                      selectedFilm = value;
                    });
                  },
                );
              },
            ),
            const SizedBox(height: 20.0),
            const Text(
              "Sélectionnez le/les confiserie:",
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('confiseries')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                var confiseries = snapshot.data!.docs.map((confiserie) {
                  return DropdownMenuItem<String>(
                    value: confiserie['nom'],
                    child: Text(confiserie['nom']),
                  );
                }).toList();

                return Column(
                  children: [
                    DropdownButton<String>(
                      value: selectedConfiserie,
                      items: confiseries,
                      onChanged: (value) {
                        setState(() {
                          selectedConfiserie = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      "Quantité:",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          selectedQuantity = int.tryParse(value);
                        });
                      },
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (selectedFilm != null &&
                    selectedConfiserie != null &&
                    selectedQuantity != null) {
                  FirebaseFirestore.instance.collection('commandes').add({
                    'film': selectedFilm,
                    'confiserie': selectedConfiserie,
                    'quantite': selectedQuantity,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Commande ajoutée"),
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CommandesPage(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Veuillez remplir tous les champs"),
                    ),
                  );
                }
              },
              child: const Text("J'achète mon ticket !"),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CommandesPage(),
                  ),
                );
              },
              child: const Text("Voir les commandes"),
            ),
          ],
        ),
      ),
    );
  }
}
