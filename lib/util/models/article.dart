import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:palhetas/util/data/constants.dart';

///Article
class Article extends StatelessWidget {
  ///ID
  final String id;

  ///URL
  final String url;

  ///Title
  final String title;

  ///Overview
  final String overview;

  ///Content
  final String content;

  ///Image URL
  final String imageURL;

  ///Publish Date
  final String publishDate;

  ///Article
  const Article({
    super.key,
    required this.id,
    required this.url,
    required this.title,
    required this.overview,
    required this.content,
    required this.imageURL,
    required this.publishDate,
  });

  ///`Article` to JSON Object
  Map<String, dynamic> toJSON() {
    return {
      "id": id,
      "url": url,
      "title": title,
      "overview": overview,
      "content": content,
      "imageURL": imageURL,
      "publishDate": publishDate,
    };
  }

  ///JSON Object to `Article`
  factory Article.fromJSON(Map<dynamic, dynamic> json) {
    return Article(
      id: json["id"],
      url: json["url"],
      title: json["title"],
      overview: json["overview"],
      content: json["content"],
      imageURL: json["imageURL"],
      publishDate: (json["publishDate"] as String).split("T").first,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.0),
        onTap: () => Get.toNamed("/article/$id"),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              //Image
              ClipRRect(
                borderRadius: BorderRadius.circular(14.0),
                child: imageURL.isNotEmpty
                    ? FastCachedImage(
                        url: imageURL,
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                        height: 120.0,
                      )
                    : SvgPicture.network(
                        Constants.noImage,
                        fit: BoxFit.cover,
                        height: 120.0,
                      ),
              ),

              //Title
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
