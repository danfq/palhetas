import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/route_manager.dart';
import 'package:html/parser.dart' show parse;
import 'package:palhetas/util/data/local.dart';
import 'package:palhetas/util/data/news.dart';
import 'package:palhetas/util/models/article.dart';
import 'package:palhetas/util/notifications/toast.dart';
import 'package:palhetas/util/services/tts.dart';
import 'package:palhetas/util/widgets/main.dart';

class NewsItem extends StatefulWidget {
  const NewsItem({super.key});

  @override
  State<NewsItem> createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {
  /// Get Article ID from Parameters
  String get articleID => Get.parameters["id"] ?? "";

  /// Offline News Items
  final offlineNews = LocalData.boxData(box: "offline")["items"] ?? [];

  /// Check if Item is in Offline News
  bool checkIfOffline() {
    return offlineNews.any((item) => item["id"] == articleID);
  }

  /// Fetch Article from Offline Storage
  Article? fetchOfflineArticle() {
    final articleData = offlineNews
        .firstWhere((item) => item["id"] == articleID, orElse: () => null);
    return articleData != null ? Article.fromJSON(articleData) : null;
  }

  /// Get Article (Offline or Online)
  Future<Article?> getArticle() async {
    if (checkIfOffline()) {
      return fetchOfflineArticle();
    } else {
      return await NewsHandler.articleFromID(articleID: articleID);
    }
  }

  /// TTS Running Status
  bool ttsRunning = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Article?>(
      future: getArticle(),
      builder: (context, snapshot) {
        //Connection State
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            final article = snapshot.data!;
            return Scaffold(
              appBar: MainWidgets.appBar(
                title: const Text("Artigo"),
                centerTitle: false,
                onBack: () async {
                  if (ttsRunning) await TTSEngine.stop();
                  Get.back();
                },
                actions: [
                  Visibility(
                    visible: !checkIfOffline(),
                    child: IconButton(
                      icon: const Icon(Ionicons.ios_cloud_offline_outline),
                      onPressed: () async {
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
                                offlineNews.add(article.toJSON());
                                await LocalData.updateValue(
                                  box: "offline",
                                  item: "items",
                                  value: offlineNews,
                                );
                                Get.back();
                                LocalNotifications.toast(message: "Guardado!");
                              } else {
                                Get.back();
                                LocalNotifications.toast(
                                  message: "Já está guardado!",
                                );
                              }
                            },
                            child: const Text("Guardar"),
                          ),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (!ttsRunning) {
                        await Get.defaultDialog(
                          title: "Ouvir Notícia?",
                          content: const Text(
                              "Para desligar, basta tocar no mesmo botão."),
                          contentPadding: const EdgeInsets.all(14.0),
                          cancel: TextButton(
                            onPressed: () => Get.back(),
                            child: const Text("Cancelar"),
                          ),
                          confirm: ElevatedButton(
                            onPressed: () async {
                              final parsedContent =
                                  parse(article.content).body?.text ?? '';
                              await TTSEngine.speak(text: parsedContent);
                              setState(() => ttsRunning = true);
                              Get.back();
                            },
                            child: const Text("Confirmar"),
                          ),
                        );
                      } else {
                        await TTSEngine.stop();
                        setState(() => ttsRunning = false);
                      }
                    },
                    icon: Icon(
                      ttsRunning
                          ? MaterialCommunityIcons.text_to_speech_off
                          : MaterialCommunityIcons.text_to_speech,
                    ),
                  ),
                ],
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MainWidgets.pageTitle(
                        title: article.title,
                        textSize: 24.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text(
                          "Publicado Em ${article.publishDate.split("T").first}",
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ),
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
            return _errorScreen("Erro ao Carregar Artigo\n(Offline)");
          }
        } else if (snapshot.hasError) {
          return _errorScreen("Erro ao Carregar Dados\n${snapshot.error}");
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

  /// Error Screen
  Widget _errorScreen(String message) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

/// Blurred Background Dialog
class BlurredBackgroundDialog extends StatelessWidget {
  const BlurredBackgroundDialog({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Stack(
        children: [
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
