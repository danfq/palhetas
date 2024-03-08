import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/route_manager.dart';
import 'package:palhetas/util/data/local.dart';
import 'package:palhetas/util/models/article.dart';
import 'package:palhetas/util/notifications/toast.dart';
import 'package:palhetas/util/widgets/main.dart';
import 'package:share_plus/share_plus.dart';

class NewsItem extends StatelessWidget {
  const NewsItem({super.key, required this.article});

  ///Article
  final Article article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainWidgets.appBar(
        title: const Text("Artigo"),
        centerTitle: false,
        actions: [
          //Offline
          IconButton(
            icon: const Icon(Ionicons.ios_cloud_offline_outline),
            onPressed: () async {
              //Confirmation
              await Get.defaultDialog(
                title: "Guardar Offline",
                content: const Text("Guardar para ler offline?"),
                cancel: TextButton(
                  onPressed: () => Get.back(),
                  child: const Text("Cancelar"),
                ),
                confirm: ElevatedButton(
                  onPressed: () async {
                    //Offline News Items
                    final offlineNews =
                        LocalData.boxData(box: "offline")["items"] ?? [];

                    //Check if Present
                    bool isAlreadyPresent = false;
                    for (var item in offlineNews) {
                      if (item["id"] == article.id) {
                        isAlreadyPresent = true;
                        break;
                      }
                    }

                    if (!isAlreadyPresent) {
                      //Add if Not Present
                      offlineNews.add(article.toJSON());

                      //Save New List
                      await LocalData.updateValue(
                        box: "offline",
                        item: "items",
                        value: offlineNews,
                      );

                      Get.back();
                    } else {
                      Get.back();
                      LocalNotifications.toast(message: "Já está guardado!");
                    }
                  },
                  child: const Text("Guardar"),
                ),
              );
            },
          ),

          //Share
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Ionicons.ios_share_outline),
              onPressed: () async {
                //Share Article
                await Share.share(article.url);
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            //Title
            MainWidgets.pageTitle(title: article.title),

            //Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: HtmlWidget(article.content),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
