import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommandesPage extends StatefulWidget {
  const CommandesPage({Key? key});

  @override
  State<CommandesPage> createState() => _CommandesPageState();
}

class _CommandesPageState extends State<CommandesPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Commandes"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _db.collection('commandes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> commandes = snapshot.data!.docs;
            return ListView.builder(
              itemCount: commandes.length,
              itemBuilder: (context, index) {
                var commande = commandes[index];
                String titreCommande = "Commande n° ${index + 1}";
                String titreFilm = commande['film'];
                String quantite = commande['quantite'];
                String confiserie = commande['confiserie'];

                return Dismissible(
                  key: Key(commande.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    // Supprimer la commande de Firebase
                    _db.collection('commandes').doc(commande.id).delete();
                  },
                  child: Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(titreCommande),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Film: $titreFilm"),
                              Text("Quantité: $quantite"),
                              Text("Confiserie: $confiserie"),
                            ],
                          ),
                        ),
                      ],
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
    );
  }
}
