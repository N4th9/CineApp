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
  String? selectedFilmType;
  String? selectedConfiserie;
  int? selectedQuantity;
  String? selectedComplex;
  DateTime? selectedDate;

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
              "Sélectionnez votre complexe :",
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 10.0),
            DropdownButton<String>(
              value: selectedComplex,
              hint: const Text('Choisissez un complexe'),
              items: ['Tournai', 'Mons', 'Lille'].map((complex) {
                return DropdownMenuItem<String>(
                  value: complex,
                  child: Text(complex),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedComplex = value;
                });
              },
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );

                if (pickedDate != null && pickedDate != selectedDate) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              child: Text(
                selectedDate != null
                    ? "Date sélectionnée : ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                    : "Sélectionner la date",
              ),
            ),
            const SizedBox(height: 30.0),
            const Text(
              "Sélectionnez votre film et le type :",
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('films')
                        .snapshots(),
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
                        hint:
                            const Text('Choisissez votre film à regarder ...'),
                        items: films,
                        onChanged: (value) {
                          setState(() {
                            selectedFilm = value;
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10.0),
                DropdownButton<String>(
                  value: selectedFilmType,
                  hint: const Text('Type'),
                  items: ['2D', '3D'].map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFilmType = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            const Text(
              "Choisir la/les confiserie.s et la quantité :",
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
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

                      return DropdownButton<String>(
                        value: selectedConfiserie,
                        hint: const Text('Choisissez la ou les confiserie.s'),
                        items: confiseries,
                        onChanged: (value) {
                          setState(() {
                            selectedConfiserie = value;
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10.0),
                DropdownButton<String>(
                  value: selectedFilmType,
                  hint: const Text('Quantité'),
                  items: ['1', '2'].map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedFilmType = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 170.0),
            ElevatedButton(
              onPressed: () {
                if (selectedFilm != null &&
                    selectedConfiserie != null &&
                    selectedQuantity != null &&
                    selectedComplex != null &&
                    selectedDate != null &&
                    selectedFilmType != null) {
                  FirebaseFirestore.instance.collection('commandes').add({
                    'film': selectedFilm,
                    'filmType': selectedFilmType,
                    'confiserie': selectedConfiserie,
                    'quantite': selectedQuantity,
                    'complexe': "Se déroule à $selectedComplex",
                    'date': "Le $selectedDate",
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
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  side: const BorderSide(color: Colors.black),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 100.0),
              ),
              child: const Text("J'achète mon ticket !"),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CommandesPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  side: const BorderSide(color: Colors.black),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 100.0),
              ),
              child: const Text("Voir les commandes"),
            ),
          ],
        ),
      ),
    );
  }
}
