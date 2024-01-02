import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageGalleryPage extends StatefulWidget {
  const ImageGalleryPage({
    Key? key,
  }) : super(key: key);

  @override
  _ImageGalleryPageState createState() => _ImageGalleryPageState();
}

class _ImageGalleryPageState extends State<ImageGalleryPage> {
  List<GalleryItem> galleryItems = [];

  @override
  void initState() {
    super.initState();
    fetchImageFileNames();
  }

  Future<void> fetchImageFileNames() async {
    try {
      final ListResult result =
          await FirebaseStorage.instance.ref('images').listAll();

      galleryItems.clear();

      for (final Reference ref in result.items) {
        String imageUrl = await ref.getDownloadURL();
        galleryItems.add(GalleryItem(name: ref.name, imageUrl: imageUrl));
      }

      setState(() {});
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des noms de fichiers : $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Images'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: ListView.builder(
        itemCount: galleryItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(galleryItems[index].name),
            subtitle: Image.network(galleryItems[index].imageUrl),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  appBar: AppBar(
                    title: Text(galleryItems[index].name),
                    centerTitle: true,
                    backgroundColor: Colors.redAccent,
                  ),
                  body: Center(
                    child: Image.network(galleryItems[index].imageUrl),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class GalleryItem {
  final String name;
  final String imageUrl;

  GalleryItem({required this.name, required this.imageUrl});
}
