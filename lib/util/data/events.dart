import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:palhetas/util/data/constants.dart';
import 'package:palhetas/util/models/event.dart';

///Events Handler
class EventsHandler {
  ///Get All Events
  static Future<List<EventData>> getAll() async {
    //Events
    List<EventData> eventsList = [];

    //Events Page
    final page = await http.get(Uri.parse(Constants.events));

    //Data
    final pageData = page.body;

    //Parse HTML
    final html = parse(pageData);

    //Parse Events
    final events = html.getElementsByClassName("thumbnail");

    for (final eventData in events) {
      //Image
      final imageElement = eventData.getElementsByTagName("img");
      final image = imageElement.first.attributes["src"];

      //Event
      final event = EventData(imageURL: Constants.eventsImageBase + image!);

      //Add Event to List
      eventsList.add(event);
    }

    //Return Events
    return eventsList;
  }
}
