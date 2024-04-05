import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/route_manager.dart';
import 'package:html/parser.dart';
import 'package:palhetas/util/data/local.dart';
import 'package:palhetas/util/models/article.dart';
import 'package:palhetas/util/notifications/toast.dart';
import 'package:palhetas/util/services/tts.dart';
import 'package:palhetas/util/widgets/main.dart';
import 'package:share_plus/share_plus.dart';

class NewsItem extends StatefulWidget {
  const NewsItem({super.key, required this.article});

  ///Article
  final Article article;

  @override
  State<NewsItem> createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {
  ///Offline News Items
  final offlineNews = LocalData.boxData(box: "offline")["items"] ?? [];

  ///Check if Item is in Offline News
  bool checkIfOffline() {
    //Status
    bool isAlreadyPresent = false;

    //Check
    for (var item in offlineNews) {
      if (item["id"] == widget.article.id) {
        isAlreadyPresent = true;
        break;
      }
    }

    //Return Status
    return isAlreadyPresent;
  }

  ///Check if TTS is Running
  bool ttsRunning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainWidgets.appBar(
        title: const Text("Artigo"),
        centerTitle: false,
        onBack: () async {
          //Stop TTS
          if (ttsRunning) {
            await TTSEngine.stop();
          }

          //Go Back
          Get.back();
        },
        actions: [
          //Offline
          Visibility(
            visible: !checkIfOffline(),
            child: IconButton(
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
                      if (!checkIfOffline()) {
                        //Add if Not Present
                        offlineNews.add(widget.article.toJSON());

                        //Save New List
                        await LocalData.updateValue(
                          box: "offline",
                          item: "items",
                          value: offlineNews,
                        );

                        Get.back();

                        //Notify User
                        LocalNotifications.toast(message: "Guardado!");
                      } else {
                        Get.back();

                        //Notify User
                        LocalNotifications.toast(message: "Já está guardado!");
                      }
                    },
                    child: const Text("Guardar"),
                  ),
                );
              },
            ),
          ),

          //Text-to-Speech
          IconButton(
            onPressed: () async {
              //Check if Running
              if (!ttsRunning) {
                //Confirm
                await Get.defaultDialog(
                  title: "Ouvir Notícia?",
                  content: const Text(
                    "Para desligar, basta tocar no mesmo botão.",
                  ),
                  contentPadding: const EdgeInsets.all(14.0),
                  cancel: TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancelar"),
                  ),
                  confirm: ElevatedButton(
                    onPressed: () async {
                      //Speak Article
                      if (widget.article.content.isNotEmpty) {
                        //Parse Content
                        final parsedContent = HtmlParser(
                          widget.article.content,
                        ).parse();

                        //Speak Content
                        await TTSEngine.speak(
                          text: parsedContent.body!.text,
                        );

                        //Start TTS
                        setState(() {
                          ttsRunning = true;
                        });
                      }

                      Get.back();
                    },
                    child: const Text("Confirmar"),
                  ),
                );
              } else {
                //Stop TTS
                setState(() {
                  ttsRunning = false;
                });

                await TTSEngine.stop();
              }
            },
            icon: Icon(
              ttsRunning
                  ? MaterialCommunityIcons.text_to_speech_off
                  : MaterialCommunityIcons.text_to_speech,
            ),
          ),

          //Share
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Ionicons.ios_share_outline),
              onPressed: () async {
                //Share Article
                await Share.share(widget.article.url);
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Title
              MainWidgets.pageTitle(
                title: widget.article.title,
                textSize: 24.0,
              ),

              //Content
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: HtmlWidget(widget.article.content),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
