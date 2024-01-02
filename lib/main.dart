import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_2023/Confiseries/ListConfiseries.dart';
import 'package:project_2023/Connected/Identity.dart';
import 'package:project_2023/films/FormulaireFilm.dart';
import 'package:project_2023/films/ListFilms.dart';
import 'package:project_2023/firebase/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    List<Film> films = [];
    List<Confiserie> confiseries = [];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(
        films: films,
        confiseries: confiseries,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<Film> films;
  final List<Confiserie> confiseries;

  const MyHomePage({Key? key, required this.films, required this.confiseries})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page d\'accueil'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30.0),
          const Align(
            child: Text(
              "Bienvenue sur CinéMagic",
              style: TextStyle(
                fontSize: 25.0,
              ),
            ),
          ),
          const SizedBox(height: 220.0),
          Image.asset(
            'assets/images/action.jpg',
            width: 150.0,
            height: 150.0,
          ),
          const SizedBox(height: 150.0),
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
                            films: films,
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
                            confiseries: confiseries,
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
                                )),
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
