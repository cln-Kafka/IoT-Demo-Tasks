import "package:flutter/material.dart";
import 'dart:math';

void main() {
  runApp(
    const Gallery(),
  );
}

class Gallery extends StatelessWidget {
  const Gallery({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
      ),
      home: const GalleryHome(),
    );
  }
}

class GalleryHome extends StatefulWidget {
  const GalleryHome({super.key});

  @override
  State<GalleryHome> createState() {
    return _GalleryHomeState();
  }
}

class _GalleryHomeState extends State<GalleryHome> {
  String imageUrl = "https://picsum.photos/200/300?random=1";

  void changeImage() {
    // Generate a new random image URL
    setState(() {
      // Generates a random number between 0 and 99
      int randomInt = Random().nextInt(100);
      imageUrl = "https://picsum.photos/400/600?random=$randomInt";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Gallery",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: changeImage,
              child: const Text("Change Image"),
            ),
          ],
        ),
      ),
    );
  }
}
