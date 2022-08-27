import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:palhetas/util/rss/feed.dart';
import 'package:palhetas/util/theming/controller.dart';
import 'package:palhetas/widgets/main_widgets.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.themeMode}) : super(key: key);

  final AdaptiveThemeMode themeMode;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MainWidgets.defaultScaffold(
      pageTitle: "Início",
      centerTitle: true,
      allowBack: false,
      body: FutureBuilder(
        future: Feed.fetchPosts(),
        builder: (context, AsyncSnapshot<List<RSSItemModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return RSSItem(rssItem: snapshot.data![index]);
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
