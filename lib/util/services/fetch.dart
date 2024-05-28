import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/foundation.dart';
import 'package:palhetas/util/data/local.dart';
import 'package:palhetas/util/data/news.dart';
import 'package:palhetas/util/logging/handler.dart';
import 'package:palhetas/util/models/article.dart';
import 'package:palhetas/util/services/notifications.dart';

///News Fetch Handler
class NewsFetch {
  ///All News
  static Future<List<Article>> get _all async => await NewsHandler.all();

  ///Fetch & Cache Articles
  static Future<void> fetchAndCache() async {
    //All
    final allNews = await _all;

    //Cache Articles
    await LocalData.updateValue(
        box: "news",
        item: "list",
        value: allNews.map((article) => article.toJSON()).toList());

    //Log Fetched News
    LogHandler.log(
      message: "[NEWS] Found ${allNews.length} Articles",
      level: LogLevel.info,
    );
  }

  ///Fetch In Background
  ///
  ///Returns Number of Fetched News
  @pragma('vm:entry-point')
  static Future<void> _fetchInBackground() async {
    //Current News
    final currentNews = await _all;

    //Saved News
    final List<Map<dynamic, dynamic>> savedNews =
        LocalData.boxData(box: "news")["list"];

    //Parsed Saved News Articles IDs
    final Set<String> savedNewsIDs =
        savedNews.map((article) => article["id"] as String).toSet();

    //Compare IDs
    for (final article in currentNews) {
      if (!savedNewsIDs.contains(article.id)) {
        //New Article Posted - Send Notification
        await Notifications.sendNotification(
          title: "Nova Notícia",
          body: article.title,
        );
      }
    }
  }

  ///Setup Background Fetch
  static Future<void> setupBackgroundFetch() async {
    //Configure
    await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        startOnBoot: true,
        enableHeadless: true,
        requiredNetworkType: NetworkType.ANY,
      ),
      (taskID) async {
        //Attempt to Fetch News
        try {
          //Fetch News
          debugPrint("[NEWS_FETCH] Fetching News...");
          await _fetchInBackground();
          debugPrint("[NEWS_FETCH] Fetched News.");

          //Finish
          await BackgroundFetch.finish(taskID);
        } catch (error) {
          debugPrint("[NEWS_FETCH] ${error.toString()}");
        }
      },
      (taskID) => BackgroundFetch.finish(taskID),
    ).then((status) {
      debugPrint("[NEWS_FETCH] Initialized | Status: $status.");
    }).catchError((error) {
      debugPrint("[NEWS_FETCH] Error: $error.");
    });

    //Register Headless Task
    await BackgroundFetch.registerHeadlessTask(_fetchInBackground).then(
      (status) {
        debugPrint("[NEWS_FETCH] Registered Headless Task: $status.");
      },
    );

    //Start Task
    await BackgroundFetch.start();
  }
}
