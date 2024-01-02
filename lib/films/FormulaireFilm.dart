import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'ImageGalleryFilms.dart';

// ignore: must_be_immutable
class FormulaireFilm extends StatefulWidget {
  List<Film> films;
  FormulaireFilm({Key? key, required this.films}) : super(key: key);

  @override
  FormulaireFilmState createState() => FormulaireFilmState();
}

class FormulaireFilmState extends State<FormulaireFilm> {
  late FirebaseFirestore _db;
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _salleController = TextEditingController();
  bool filmEnregistre = false;
  late TimeOfDay _selectedTime;
  String? _imagePath;

  late List<Film> films;

  @override
  void initState() {
    super.initState();
    films = widget.films;
    _selectedTime = TimeOfDay.now();
    _db = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enregistrer un film'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ImageGalleryPage(),
                ),
              );
            },
            icon: const Icon(Icons.image),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nomController,
              decoration: const InputDecoration(
                labelText: 'Nom du film',
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              child: TextField(
                controller: _descriptionController,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Description du film',
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );

                if (pickedTime != null && pickedTime != _selectedTime) {
                  setState(() {
                    _selectedTime = pickedTime;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: Colors.black),
                ),
                backgroundColor: Colors.white,
              ),
              child: Text(
                'Heure de début: ${_formatTime(_selectedTime)}',
                style: const TextStyle(fontSize: 18.0),
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _salleController,
              decoration: const InputDecoration(
                labelText: 'Salle',
              ),
            ),
            const SizedBox(height: 320.0),
            ElevatedButton(
              onPressed: () {
                if (_areFieldsValid()) {
                  String title = _nomController.text;
                  String description = _descriptionController.text;
                  String time = _selectedTime.toString();
                  String salle = _salleController.text;

                  Film nouveauFilm = Film(
                    title: title,
                    description: description,
                    time: time,
                    salle: salle,
                    imagePath: _imagePath ?? '',
                  );

                  setState(() {
                    filmEnregistre = true;
                  });

                  _db.collection('films').add({
                    'title': nouveauFilm.title,
                    'description': nouveauFilm.description,
                    'Heure de début': nouveauFilm.time,
                    'salle': nouveauFilm.salle,
                    'imagePath': nouveauFilm.imagePath,
                  });

                  Navigator.pop(context, nouveauFilm);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Attention !"),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: Colors.black),
                ),
                backgroundColor: Colors.redAccent,
              ),
              child: const Text('Enregistrer les informations du film',
                  style: TextStyle(color: Colors.white, fontSize: 16.0)),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(time) {
    return '${time.hour}:${time.minute}';
  }

  bool _areFieldsValid() {
    return _nomController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _salleController.text.isNotEmpty;
  }
}

class Film {
  final String title;
  final String description;
  final String time;
  final String salle;
  final String imagePath;

  Film({
    required this.title,
    required this.description,
    required this.time,
    required this.salle,
    required this.imagePath,
  });
}
