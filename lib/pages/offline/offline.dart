import 'package:flutter/material.dart';
import 'package:palhetas/util/data/local.dart';
import 'package:palhetas/util/models/article.dart';

class Offline extends StatelessWidget {
  const Offline({super.key});

  @override
  Widget build(BuildContext context) {
    //Offline News
    final List offlineNews = LocalData.boxData(box: "offline")["items"] ?? [];

    //UI
    return offlineNews.isNotEmpty
        ? ListView.builder(
            itemCount: offlineNews.length,
            itemBuilder: (context, index) {
              //Article
              final article = Article.fromJSON(offlineNews[index]);

              //UI
              return article;
            },
          )
        : const Center(child: Text("Não Tens Artigos Guardados"));
  }
}
