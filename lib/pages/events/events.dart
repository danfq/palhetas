import 'package:carousel_slider/carousel_slider.dart';
import 'package:drop_shadow/drop_shadow.dart';
import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';
import 'package:palhetas/pages/events/single.dart';
import 'package:palhetas/util/data/events.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  ///Page Controller
  final PageController _pageController = PageController();

  ///Carousel Controller
  final _carouselController = CarouselSliderController();

  ///Current Index
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    //Add Listener to Page Controller
    _pageController.addListener(() {
      //New Page Index
      final newIndex = _pageController.page?.round();

      //Set Current Index if Valid
      if (newIndex != null && _currentIndex != newIndex) {
        setState(() {
          _currentIndex = newIndex;
        });
      }
    });
  }

  @override
  void dispose() {
    //Dispose of Page Controller
    _pageController.dispose();

    super.dispose();
  }

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
                carouselController: _carouselController,
                items: events
                    .map(
                      (event) => GestureDetector(
                        onTap: () => Get.to(
                          () => SingleEvent(imageURL: event.imageURL),
                        ),
                        child: Hero(
                          tag: event.imageURL,
                          child: DropShadow(
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
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                  height: 400.0,
                  viewportFraction: 0.64,
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
              Center(child: Text("A Carregar Eventos...")),
            ],
          );
        }
      },
    );
  }
}
