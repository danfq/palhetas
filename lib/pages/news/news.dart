import 'package:flutter/material.dart';
import 'package:palhetas/util/data/local.dart';
import 'package:palhetas/util/models/article.dart';

class News extends StatelessWidget {
  const News({super.key});

  @override
  Widget build(BuildContext context) {
    //Articles
    final List articles = LocalData.boxData(box: "news")["list"];

    //UI
    return articles.isNotEmpty
        ? ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              //Article
              final article = Article.fromJSON(articles[index]);

              //UI
              return article;
            },
          )
        : const Center(child: Text("Sem Notícias"));
  }
}
