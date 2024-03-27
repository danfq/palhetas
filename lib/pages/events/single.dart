import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:palhetas/util/data/events.dart';
import 'package:palhetas/util/widgets/main.dart';

class SingleEvent extends StatelessWidget {
  const SingleEvent({super.key, required this.imageURL});

  ///Image URL
  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainWidgets.appBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () async {
                //Share Event
                await EventsHandler.shareEvent(url: imageURL);
              },
              icon: const Icon(Ionicons.ios_share_outline),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Hero(
              tag: imageURL,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.0),
                child: Image.network(
                  imageURL,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
