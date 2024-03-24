import 'package:flutter/material.dart';
import 'package:palhetas/util/widgets/main.dart';

class SingleEvent extends StatelessWidget {
  const SingleEvent({super.key, required this.imageURL});

  ///Image URL
  final String imageURL;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainWidgets.appBar(),
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
