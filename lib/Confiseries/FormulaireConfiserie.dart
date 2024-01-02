import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FormulaireConfiserie extends StatefulWidget {
  List<Confiserie> confiseries;

  FormulaireConfiserie({Key? key, required this.confiseries}) : super(key: key);

  @override
  _FormulaireConfiserieState createState() => _FormulaireConfiserieState();
}

class _FormulaireConfiserieState extends State<FormulaireConfiserie> {
  late FirebaseFirestore _db;
  final TextEditingController _nomController = TextEditingController();
  bool eventEnregistre = false;
  int? _selectedPrice;
  final List<int> prices = [1, 2, 3, 4, 5, 6, 7, 8];

  late List<Confiserie> confiseries;

  @override
  void initState() {
    super.initState();
    confiseries = widget.confiseries;
    _db = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enregistrer une confiserie'),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nomController,
              decoration:
                  const InputDecoration(labelText: 'Nom de la confiserie'),
            ),
            const SizedBox(height: 20.0),
            DropdownButtonFormField<int>(
              value: _selectedPrice,
              onChanged: (int? value) {
                setState(() {
                  _selectedPrice = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Prix de la confiserie en €',
                border: OutlineInputBorder(),
              ),
              items: prices.map((int price) {
                return DropdownMenuItem<int>(
                  value: price,
                  child: Text('$price €'),
                );
              }).toList(),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_areFieldsValid()) {
                  String nom = _nomController.text;
                  String prix = _selectedPrice.toString();

                  Confiserie confiserie = Confiserie(
                    nom: nom,
                    prix: prix,
                    imagePath: '',
                  );

                  setState(() {
                    eventEnregistre = true;
                  });

                  _db.collection('confiseries').add({
                    'nom': confiserie.nom,
                    'prix': '${confiserie.prix} €',
                    'imagePath': confiserie.imagePath,
                  });

                  Navigator.pop(context, confiserie);
                } else {
                  // Afficher un message d'avertissement
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Champs incomplets"),
                        content:
                            const Text("Veuillez remplir tous les champs."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
              ),
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  bool _areFieldsValid() {
    return _nomController.text.isNotEmpty && _selectedPrice != null;
  }
}

class Confiserie {
  final String nom;
  final String prix;
  final String imagePath;

  Confiserie({
    required this.nom,
    required this.prix,
    required this.imagePath,
  });
}
