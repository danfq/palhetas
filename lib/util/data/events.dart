import 'dart:io';
import 'dart:typed_data';

import 'package:download/download.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:palhetas/util/data/constants.dart';
import 'package:palhetas/util/models/event.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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

  ///Share Event
  static Future<void> shareEvent({required String url}) async {
    //Image Data
    final http.Response response = await http.get(Uri.parse(url));
    final Uint8List imageData = response.bodyBytes;

    //Saving Directory
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;

    //Save Image Locally
    final File imageFile = File("$tempPath/event_image.jpg");
    await imageFile.writeAsBytes(imageData);
    final shareableImage = XFile(imageFile.path);

    //Share Image
    await Share.shareXFiles([shareableImage]);
  }
}
