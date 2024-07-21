import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/route_manager.dart';
import 'package:html/parser.dart';
import 'package:palhetas/util/data/local.dart';
import 'package:palhetas/util/data/news.dart';
import 'package:palhetas/util/models/article.dart';
import 'package:palhetas/util/notifications/toast.dart';
import 'package:palhetas/util/services/tts.dart';
import 'package:palhetas/util/widgets/main.dart';
import 'package:share_plus/share_plus.dart';

class NewsItem extends StatefulWidget {
  const NewsItem({super.key, required this.articleID});

  /// Article ID
  final String articleID;

  @override
  State<NewsItem> createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {
  /// Offline News Items
  final offlineNews = LocalData.boxData(box: "offline")["items"] ?? [];

  /// Check if Item is in Offline News
  bool checkIfOffline() {
    return offlineNews.any((item) => item["id"] == widget.articleID);
  }

  /// Fetch Article from Offline Storage
  Article? fetchOfflineArticle() {
    final articleData = offlineNews.firstWhere(
        (item) => item["id"] == widget.articleID,
        orElse: () => null);
    if (articleData != null) {
      return Article.fromJSON(articleData);
    }
    return null;
  }

  /// Get Article
  Future<Article?> getArticle() async {
    if (checkIfOffline()) {
      return fetchOfflineArticle();
    } else {
      return await NewsHandler.articleFromID(articleID: widget.articleID);
    }
  }

  /// Check if TTS is Running
  bool ttsRunning = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Article?>(
      future: getArticle(),
      builder: (context, snapshot) {
        // Connection State
        if (snapshot.connectionState == ConnectionState.done) {
          // Article
          final article = snapshot.data;

          // Check Article
          if (article != null) {
            return Scaffold(
              appBar: MainWidgets.appBar(
                title: const Text("Artigo"),
                centerTitle: false,
                onBack: () async {
                  // Stop TTS
                  if (ttsRunning) {
                    await TTSEngine.stop();
                  }

                  // Go Back
                  Get.back();
                },
                actions: [
                  // Offline
                  Visibility(
                    visible: !checkIfOffline(),
                    child: IconButton(
                      icon: const Icon(Ionicons.ios_cloud_offline_outline),
                      onPressed: () async {
                        // Confirmation
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
                                // Add if Not Present
                                offlineNews.add(article.toJSON());

                                // Save New List
                                await LocalData.updateValue(
                                  box: "offline",
                                  item: "items",
                                  value: offlineNews,
                                );

                                Get.back();

                                // Notify User
                                LocalNotifications.toast(message: "Guardado!");
                              } else {
                                Get.back();

                                // Notify User
                                LocalNotifications.toast(
                                    message: "Já está guardado!");
                              }
                            },
                            child: const Text("Guardar"),
                          ),
                        );
                      },
                    ),
                  ),

                  // Text-to-Speech
                  IconButton(
                    onPressed: () async {
                      // Check if Running
                      if (!ttsRunning) {
                        // Confirm
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
                              // Speak Article
                              if (article.content.isNotEmpty) {
                                // Parse Content
                                final parsedContent =
                                    HtmlParser(article.content).parse();

                                // Speak Content
                                await TTSEngine.speak(
                                    text: parsedContent.body!.text);

                                // Start TTS
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
                        // Stop TTS
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

                  // Share
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: IconButton(
                      icon: const Icon(Ionicons.ios_share_outline),
                      onPressed: () async {
                        // Share Article
                        await Share.share(article.url);
                      },
                    ),
                  ),
                ],
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      MainWidgets.pageTitle(
                        title: article.title,
                        textSize: 24.0,
                      ),

                      // Date
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text(
                          "Publicado Em ${article.publishDate.split("T").first}",
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),

                      // Content
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: HtmlWidget(
                          article.content,
                          onTapImage: (imageData) async {
                            await showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return BlurredBackgroundDialog(
                                  imageUrl: imageData.sources.first.url,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Scaffold(
              body: SafeArea(
                child: Center(
                  child: Text(
                    "Erro ao Carregar Artigo\n(Offline)",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }
        } else {
          return const Scaffold(
            body: SafeArea(
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }
      },
    );
  }
}

/// Blurred Background Dialog
class BlurredBackgroundDialog extends StatelessWidget {
  const BlurredBackgroundDialog({super.key, required this.imageUrl});

  /// Image URL
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Stack(
        children: [
          // Blurred Background
          Positioned.fill(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 4.0),
              duration: const Duration(milliseconds: 300),
              builder: (context, value, child) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: value, sigmaY: value),
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                  ),
                );
              },
            ),
          ),

          // Dialog
          Center(
            child: GestureDetector(
              onTap: () {},
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.network(
                    imageUrl,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
