import 'package:carousel_slider/carousel_slider.dart';
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
            return Center(
              child: CarouselSlider(
                items: events
                    .map(
                      (event) => GestureDetector(
                        onTap: () => Get.to(
                          () => SingleEvent(imageURL: event.imageURL),
                        ),
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
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                  height: 500.0,
                  viewportFraction: 0.7,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                ),
              ),
            );
          } else {
            return const Center(child: Text("Nenhum Evento"));
          }
        } else {
          return const Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: CircularProgressIndicator()),
              SizedBox(height: 20.0),
              Center(child: Text("A Carregar Eventos...")),
            ],
          );
        }
      },
    );
  }
}
