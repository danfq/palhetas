import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:palhetas/pages/feed/web.dart';
import 'package:palhetas/util/navigation/routing.dart';
import 'package:palhetas/util/rss/feed.dart';
import 'package:palhetas/widgets/main_widgets.dart';
import 'package:html2md/html2md.dart' as HTML2MD;
import 'package:share_plus/share_plus.dart';

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
      floatingActionButton: FloatingActionButton(
        child: const Icon(CupertinoIcons.share),
        onPressed: () {
          Share.share(
            "${widget.item.rssItem.title}\n\n-\n${widget.item.rssItem.author}\n(https://opalhetasnafoz.blogspot.com/)\n${widget.item.rssItem.published}",
          );
        },
      ),
    );
  }
}
