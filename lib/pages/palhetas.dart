import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/route_manager.dart';
import 'package:palhetas/pages/news/news.dart';
import 'package:palhetas/pages/offline/offline.dart';
import 'package:palhetas/util/data/constants.dart';
import 'package:palhetas/util/widgets/main.dart';
import 'package:url_launcher/url_launcher.dart';

class Palhetas extends StatefulWidget {
  const Palhetas({super.key});

  @override
  State<Palhetas> createState() => _PalhetasState();
}

class _PalhetasState extends State<Palhetas> {
  ///Navigation Index
  int _navIndex = 0;

  ///Body
  Widget _body() {
    switch (_navIndex) {
      //News
      case 0:
        return const News();

      //Offline
      case 1:
        return const Offline();

      //Default - Error
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainWidgets.appBar(
        title: const Text("O Palhetas na Foz"),
        allowBack: false,
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () async {
                await Get.defaultDialog(
                  title: "O Palhetas na Foz",
                  content: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Esta App foi publicada com a autorização prévia de António Flórido - autor de todos os Artigos.",
                    ),
                  ),
                  confirm: ElevatedButton(
                    onPressed: () async {
                      Get.back();
                      await launchUrl(Uri.parse(Constants.blog));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).cardColor,
                    ),
                    child: const Text("Ver Blog"),
                  ),
                );
              },
              icon: const Icon(Ionicons.ios_information_circle_outline),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(child: _body()),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: (index) {
          setState(() {
            _navIndex = index;
          });
        },
        items: const [
          //Home
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Ionicons.ios_newspaper),
            ),
            label: "Últimas Notícias",
          ),

          //Offline
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Ionicons.ios_cloud_offline),
            ),
            label: "Ler Offline",
          ),
        ],
      ),
    );
  }
}
