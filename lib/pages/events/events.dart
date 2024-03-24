import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:palhetas/pages/events/single.dart';
import 'package:palhetas/util/data/events.dart';

class Events extends StatelessWidget {
  const Events({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: EventsHandler.getAll(),
      builder: (context, snapshot) {
        //Connection State
        if (snapshot.connectionState == ConnectionState.done) {
          //Events
          final events = snapshot.data;

          //Check Events
          if (events != null && events.isNotEmpty) {
            return GridView.count(
              physics: const BouncingScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 20.0,
              children: events.map((event) {
                return GestureDetector(
                  onTap: () async {
                    await Get.to(() => SingleEvent(imageURL: event.imageURL));
                  },
                  child: Hero(
                    tag: event.imageURL,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14.0),
                      child: Image.network(
                        event.imageURL,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          } else {
            return const Center(child: Text("Nenhum Evento"));
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}