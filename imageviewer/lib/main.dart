import 'package:flutter/material.dart';

void main() {
  runApp(const ImageViewer());
}

class ImageViewer extends StatelessWidget {
  const ImageViewer({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Viewer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Image Viewer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String currentImage = "assets/image1.jpg";

  void _toggleImage() {
    setState(() {
      currentImage = currentImage == 'assets/image1.jpg' ? 'assets/image2.jpg' : 'assets/image1.jpg';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height:200, width: 200, child: Image.asset(currentImage, fit: BoxFit.cover),),
           const SizedBox(
            height: 30,
           ),
           ElevatedButton(onPressed: _toggleImage, child: const Text("Toggle Image")),
          ],
        ),
      ),
    );
  }
}
