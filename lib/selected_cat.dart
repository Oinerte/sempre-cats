import 'dart:convert';
import 'dart:ffi';
import 'package:app/selected_cat.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class SelectedCatPage extends StatefulWidget {
  final String imageUrl;
  final int catId;
  const SelectedCatPage(
      {super.key, required this.imageUrl, required this.catId});

  @override
  State<SelectedCatPage> createState() => _SelectedCatPageState();
}

class _SelectedCatPageState extends State<SelectedCatPage> {
  late Future<PageTexts> texts;
  late CatData catData;

  @override
  void initState() {
    texts = getTextsFromBackend();
    catData = getCatDataFromBackend(widget.catId);
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
                ),
              );
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
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 350,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    snapshot.data!.imageDescriptionText,
                    style: TextStyle(
                      color: Colors.blue[600],
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(catData.catInfo),
                  Text(
                    snapshot.data!.idText,
                    style: TextStyle(
                      color: Colors.blue[600],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(catData.catId)
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
        .get(Uri.parse('https://poc-texts-1.onrender.com/module/2/prod'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);

      return PageTexts(
        data[0]['name'],
        data[0]['texts']['descricaoImage'],
        data[0]['texts']['textoId'],
      );
    } else {
      throw Exception('Failed to load data from backend');
    }
  }

  CatData getCatDataFromBackend(int catId) {
    if (catId == 1) {
      return CatData(
          catName: 'Rodolfo',
          catInfo:
              'Rodolfo, o gato temido e respeitado, é envolto por uma aura de mistério e intriga que o eleva a um status quase lendário entre os habitantes locais. Dizem que ele possui nove vidas, e que cada uma delas foi gasta em feitos de bravura e astúcia. Boatos sussurram que ele pode se comunicar com os espíritos dos antigos felinos que vagam pelos becos sombrios da cidade. Outros contam histórias de como Rodolfo desafiou cães de guarda e até mesmo enfrentou criaturas da noite maiores do que ele, emergindo sempre como o vencedor incontestável. Sua presença é tão imponente que até mesmo os ratos, os mais astutos dos roedores, evitam os locais que ele reivindica como seu território. Rodolfo é mais do que um simples gato; ele é uma figura lendária que inspira tanto medo quanto respeito em todos que têm o privilégio de cruzar seu caminho.',
          catId: '40028922');
    } else {
      return CatData(
          catName: 'Joselito',
          catInfo:
              'Joselito, o gato conhecido por sua bondade e compaixão, é uma figura querida em sua comunidade. Sua reputação como protetor dos mais fracos e cuidador dos necessitados é conhecida em todos os cantos da cidade. Dizem que ele tem um instinto especial para encontrar aqueles que precisam de ajuda, seja um pássaro ferido no parque ou um humano solitário buscando conforto nas ruas. Joselito é mais do que um simples gato; ele é um amigo fiel e um guia compassivo em um mundo muitas vezes cruel. Seus olhos suaves irradiam calma e conforto, e sua presença é como um bálsamo para os corações aflitos. É dito que quem cruza seu caminho é abençoado com uma gentileza que toca profundamente a alma, deixando um rastro de esperança e amor por onde quer que vá.',
          catId: '0502024000');
    }
  }
}

class PageTexts {
  final String pageTitle;
  final String imageDescriptionText;
  final String idText;

  PageTexts(this.pageTitle, this.imageDescriptionText, this.idText);
}

class CatData {
  final String catName;
  final String catInfo;
  final String catId;

  CatData({required this.catName, required this.catInfo, required this.catId});
}
