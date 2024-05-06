import 'dart:convert';
import 'package:app/selected_cat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<PageTexts> texts;
  late List<String> catNames;

  @override
  void initState() {
    texts = getTextsFromBackend();
    catNames = getCatNames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        title: FutureBuilder<PageTexts>(
          future: texts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Center(
                  child: Text(
                snapshot.data!.pageTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ));
            }
          },
        ),
      ),
      body: FutureBuilder<PageTexts>(
        future: texts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Container(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.data!.title,
                    style: TextStyle(
                      color: Colors.blue[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SelectedCatPage(
                            imageUrl: 'https://cataas.com/cat',
                            catId: 1,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      color: Colors.blueGrey,
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(
                              'https://cataas.com/cat',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            "${snapshot.data!.paragraph}: ${catNames[0]}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SelectedCatPage(
                            imageUrl: 'https://cataas.com/cat?type=medium',
                            catId: 2,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      color: Colors.blueGrey,
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(
                                'https://cataas.com/cat?type=medium',
                                fit: BoxFit.cover),
                          ),
                          Text(
                            "${snapshot.data!.paragraph}: ${catNames[1]}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<PageTexts> getTextsFromBackend() async {
    final response = await http
        .get(Uri.parse('https://poc-texts-1.onrender.com/module/1/prod'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      return PageTexts(
        data[0]['name'],
        data[0]['texts']['textoGrande'],
        data[0]['texts']['textoPequeno'],
      );
    } else {
      throw Exception('Failed to load data from backend');
    }
  }

  List<String> getCatNames() {
    return ["Rodolfo", "Joselito"];
  }
}

class PageTexts {
  final String pageTitle;
  final String title;
  final String paragraph;

  PageTexts(this.pageTitle, this.title, this.paragraph);
}
