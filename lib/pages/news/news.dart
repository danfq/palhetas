import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:palhetas/pages/news/item.dart';
import 'package:palhetas/util/data/constants.dart';
import 'package:palhetas/util/data/news.dart';

class News extends StatelessWidget {
  const News({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: NewsHandler.all(),
      builder: (context, snapshot) {
        //Connection State
        if (snapshot.connectionState == ConnectionState.done) {
          //News Articles
          final articles = snapshot.data ?? [];

          //Check Articles
          if (articles.isNotEmpty) {
            //List of Articles
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                //Article
                final article = articles[index];

                //UI
                return article;
              },
            );
          } else {
            return const Center(child: Text("Erro ao Obter Artigos"));
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
