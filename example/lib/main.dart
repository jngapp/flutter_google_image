import 'package:flutter/material.dart';
import 'package:flutter_google_image/flutter_google_image.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final searchImage = FlutterGoogleImage();

  final List<String> images = await searchImage.searchImage('Hoa Vo Thuong Quynh Trang');
  for(final img in images) {
    print(img);
  }
  // final List<String> nextImages = await searchImage.fetchNext();
  // for(final img in nextImages) {
  //   print(img);
  // }


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: const Placeholder()
    );
  }
}
