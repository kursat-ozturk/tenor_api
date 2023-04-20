import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(
        title: 'Tenor GIF API',
        key: null,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();

  List<String> gifUrls = [];
  void getGifUrls(String word) async {
    var data = await http.get(Uri.parse(
        'https://api.tenor.com/v1/search?q=$word&key=LIVDSRZULELA&limit=8'));
    var dataParsed = jsonDecode(data.body);
    gifUrls.clear();
    for (int i = 0; i < 8; i++) {
      print(dataParsed['results'][i]['media'][0]['tinygif']['url']);
      gifUrls.add(dataParsed['results'][i]['media'][0]['tinygif']['url']);
    }

    setState(() {});
  }

  @override
  void initState() {
    getGifUrls('coding');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: TextField(
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  controller: _controller,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
              ),
              TextButton(
                onPressed: () {
                  getGifUrls(_controller.text);
                },
                child: const Text('Search Gif'),
              ),
              gifUrls.isEmpty
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: ListView.separated(
                        itemCount: 8,
                        itemBuilder: (_, int index) {
                          return GifCard(gifUrls[index]);
                        },
                        separatorBuilder: (_, __) {
                          return const Divider(
                            color: Colors.blue,
                            thickness: 5,
                            height: 5,
                          );
                        },
                      )),
            ],
          ),
        ),
      ),
    );
  }
}

class GifCard extends StatelessWidget {
  final String gifUrl;

  const GifCard(this.gifUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image(
        fit: BoxFit.cover,
        image: NetworkImage(gifUrl),
      ),
    );
  }
}
