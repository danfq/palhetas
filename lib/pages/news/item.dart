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
  const NewsItem({super.key, required this.data});

  ///News Item Data
  final Article data;

  @override
  State<NewsItem> createState() => _NewsItemState();
}

class _NewsItemState extends State<NewsItem> {
  /// Get Article ID from Parameters
  String get articleID => widget.data.id;

  /// Offline News Items
  final offlineNews = LocalData.boxData(box: "offline")["items"] ?? [];

  /// Check if Item is in Offline News
  bool checkIfOffline() {
    return offlineNews.any((item) => item["id"] == articleID);
  }

  /// Fetch Article from Offline Storage
  Article? fetchOfflineArticle() {
    //Article Data
    final articleData = offlineNews.firstWhere(
      (item) => item["id"] == articleID,
      orElse: () => null,
    );

    //Return Article
    return articleData != null ? Article.fromJSON(articleData) : null;
  }

  /// TTS Running Status
  bool ttsRunning = false;

  /// Scroll Controller
  final ScrollController _scrollController = ScrollController();

  /// Title Font Size
  double _titleFontSize = 24.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    //Scroll Offset
    final scrollOffset = _scrollController.offset;

    //Max Scroll
    const maxScroll = 100.0;

    //Min & Max Font Sizes
    const minFontSize = 18.0;
    const maxFontSize = 24.0;

    //Adjust Font Size
    setState(() {
      _titleFontSize = (maxFontSize -
              ((scrollOffset / maxScroll) * (maxFontSize - minFontSize)))
          .clamp(minFontSize, maxFontSize);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                        offlineNews.add(widget.data.toJSON());
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
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () async {
                if (!ttsRunning) {
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
                        final parsedContent =
                            parse(widget.data.content).body?.text ?? "";
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
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            //Title & Publish Date
            MainWidgets.pageTitle(
              title: widget.data.title,
              textSize: _titleFontSize,
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Text(
                "Publicado Em ${widget.data.publishDate.split("T").first}",
                style: const TextStyle(fontSize: 16.0),
              ),
            ),

            //Content
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: HtmlWidget(
                        widget.data.content,
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
          ],
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
