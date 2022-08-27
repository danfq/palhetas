import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:intl/intl.dart';
import 'package:palhetas/pages/feed/item.dart';
import 'package:palhetas/util/navigation/routing.dart';
import 'package:palhetas/values/constants.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;

///RSS Feed Methods
class Feed {
  ///Fetch Posts
  static Future<List<RSSItemModel>> fetchPosts() async {
    //Get Atom Feed
    final feed = await http.get(Uri.parse(Constants.feedURL));
    final atomFeed = AtomFeed.parse(feed.body);

    //Feed Items
    List<RSSItemModel> feedItems = [];

    atomFeed.items!.forEach((item) {
      //Add Item to List
      feedItems.add(
        RSSItemModel(
          atomFeed.authors!.first.name!,
          item.title!,
          item.content!,
          item.media!.thumbnails![0].url!,
          DateFormat("dd-MM-yyyy | HH:mm").format(
            DateTime.parse(item.published!),
          ),
        ),
      );
    });

    //Return List of Items
    return feedItems;
  }
}

///RSS Item Model
class RSSItemModel {
  final String author;
  final String title;
  final String body;
  final String imageURL;
  final String published;

  const RSSItemModel(
    this.author,
    this.title,
    this.body,
    this.imageURL,
    this.published,
  );

  factory RSSItemModel.fromItem(Map<String, dynamic> item) {
    return RSSItemModel(
      item["author"],
      item["title"],
      item["body"],
      item["imageURL"],
      item["published"],
    );
  }
}

///RSS Feed Item Widget
class RSSItem extends StatefulWidget {
  const RSSItem({Key? key, required this.rssItem}) : super(key: key);

  final RSSItemModel rssItem;

  @override
  State<RSSItem> createState() => _RSSItemState();
}

class _RSSItemState extends State<RSSItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Routing.sideRoute(context: context, newPage: FeedItem(item: widget));
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.rssItem.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        widget.rssItem.published,
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12.0,
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.network(widget.rssItem.imageURL),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
