import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/route_manager.dart';
import 'package:palhetas/pages/events/events.dart';
import 'package:palhetas/pages/news/news.dart';
import 'package:palhetas/pages/offline/offline.dart';
import 'package:palhetas/util/widgets/main.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:uni_links/uni_links.dart';

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

      //Events
      case 1:
        return const Events();

      //Offline
      case 2:
        return const Offline();

      //Default - Error
      default:
        return Container();
    }
  }

  ///Stream Subscription
  StreamSubscription? _sub;

  ///Initialize UniLinks
  Future<void> initUniLinks() async {
    // Initial Link
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        handleIncomingLink(initialLink);
      }
    } on PlatformException {
      debugPrint("Failed to get initial link");
    }

    // Subsequent Links
    _sub = linkStream.listen((String? link) {
      if (link != null) {
        handleIncomingLink(link);
      }
    }, onError: (err) {
      debugPrint("Error in linkStream: $err");
    });
  }

  ///Handle Incoming Link
  void handleIncomingLink(String link) {
    //Article ID
    final articleID = extractArticleIDFromLink(link);

    if (articleID != null) {
      Get.toNamed("/article", arguments: {"articleID": articleID});
    }
  }

  ///Extract Article ID
  String? extractArticleIDFromLink(String link) {
    try {
      final uri = Uri.parse(link);
      final pathSegments = uri.pathSegments;
      if (pathSegments.length >= 3) {
        return pathSegments[pathSegments.length - 1];
      }
    } catch (error) {
      debugPrint("Error Extracting Article ID: $error");
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    initUniLinks();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainWidgets.appBar(
        title: const Text("O Palhetas na Foz"),
        allowBack: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(child: _body()),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
        child: SalomonBottomBar(
          currentIndex: _navIndex,
          onTap: (index) {
            setState(() {
              _navIndex = index;
            });
          },
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          margin: const EdgeInsets.all(20.0),
          items: [
            //Home
            SalomonBottomBarItem(
              icon: const Icon(Ionicons.newspaper_outline),
              title: const Text("Notícias"),
            ),

            //Events
            SalomonBottomBarItem(
              icon: const Icon(MaterialCommunityIcons.drama_masks),
              title: const Text("Eventos"),
            ),

            //Offline
            SalomonBottomBarItem(
              icon: const Icon(Ionicons.ios_cloud_offline_outline),
              title: const Text("Ler Offline"),
            ),
          ],
        ),
      ),
    );
  }
}
