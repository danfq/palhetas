import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:palhetas/util/data/local.dart';
import 'package:palhetas/util/models/article.dart';

class Offline extends StatefulWidget {
  const Offline({super.key});

  @override
  State<Offline> createState() => _OfflineState();
}

class _OfflineState extends State<Offline> {
  //Offline News
  final List offlineNews = LocalData.boxData(box: "offline")["items"] ?? [];

  @override
  Widget build(BuildContext context) {
    return offlineNews.isNotEmpty
        ? ListView.builder(
            itemCount: offlineNews.length,
            itemBuilder: (context, index) {
              //Article
              final article = Article.fromJSON(offlineNews[index]);

              //UI
              return GestureDetector(
                onLongPress: () async {
                  //Confirmation
                  await Get.defaultDialog(
                    title: "Remover de Offline",
                    content: const Text("Remover este Artigo de Offline?"),
                    cancel: TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("Cancelar"),
                    ),
                    confirm: ElevatedButton(
                      onPressed: () async {
                        //Remove Article
                        offlineNews.removeAt(index);

                        //Save New List
                        LocalData.boxData(box: "offline")["items"] =
                            offlineNews;

                        //Update UI
                        setState(() {});

                        //Close Dialog
                        Get.back();
                      },
                      child: const Text("Remover"),
                    ),
                  );
                },
                child: article,
              );
            },
          )
        : const Center(child: Text("Não Tens Artigos Guardados"));
  }
}
