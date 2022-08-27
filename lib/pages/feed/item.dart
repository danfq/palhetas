import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:palhetas/pages/feed/web.dart';
import 'package:palhetas/util/navigation/routing.dart';
import 'package:palhetas/util/rss/feed.dart';
import 'package:palhetas/widgets/main_widgets.dart';
import 'package:html2md/html2md.dart' as HTML2MD;

class FeedItem extends StatefulWidget {
  const FeedItem({Key? key, required this.item}) : super(key: key);

  final RSSItem item;

  @override
  State<FeedItem> createState() => _FeedItemState();
}

class _FeedItemState extends State<FeedItem> {
  @override
  Widget build(BuildContext context) {
    return MainWidgets.defaultScaffold(
      pageTitle: widget.item.rssItem.published,
      centerTitle: true,
      allowBack: true,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Markdown(
          data: HTML2MD.convert(widget.item.rssItem.body),
          shrinkWrap: true,
          softLineBreak: true,
          physics: const BouncingScrollPhysics(),
          onTapLink: (text, href, title) {
            Routing.sideRoute(
              context: context,
              newPage: WebView(url: href!),
            );
          },
        ),
      ),
    );
  }
}
