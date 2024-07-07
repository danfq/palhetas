import 'package:palhetas/util/data/constants.dart';
import 'package:palhetas/util/models/article.dart';
import 'package:webfeed_revised/webfeed_revised.dart';
import 'package:http/http.dart' as http;

///News Handler
class NewsHandler {
  ///Get All
  static Future<List<Article>> all() async {
    //Articles
    List<Article> articles = [];

    //HTML Response
    final response = await http.get(Uri.parse(Constants.rssFeed));
    final htmlResponse = response.body;

    //RSS Feed
    final rss = AtomFeed.parse(htmlResponse);

    //Unparsed Items
    final unparsedItems = rss.items ?? [];

    //Check Items
    if (unparsedItems.isNotEmpty) {
      //Parse Articles
      for (final item in unparsedItems) {
        //Article
        final article = Article(
          id: item.links?.last.href?.split(".com").last ?? "",
          url: item.links?.last.href ?? "",
          title: item.title ?? "",
          overview: item.content?.split(".").first ?? "", //First Sentence
          content: item.content ?? "", //Entire Content
          imageURL: item.media?.thumbnails?.first.url ?? "", //First Media URL
          publishDate: item.published ?? "",
        );

        //Add Article to List
        articles.add(article);
      }
    }

    //Return Articles
    return articles;
  }

  ///Get Article by ID
  static Future<Article?> articleFromID({required String articleID}) async {
    //Article
    Article? article;

    //All News
    final allNews = await all();

    //Check for Matching ID
    for (final item in allNews) {
      if (item.id == articleID) {
        article = item;
      }
    }

    //Return Article
    return article;
  }
}
