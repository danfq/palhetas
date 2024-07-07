import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:palhetas/pages/intro/intro.dart';
import 'package:palhetas/pages/palhetas.dart';
import 'package:palhetas/util/data/local.dart';
import 'package:palhetas/util/services/fetch.dart';
import 'package:palhetas/util/services/notifications.dart';
import 'package:palhetas/util/services/tts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

///Main Services
class MainServices {
  ///DotEnv Instance
  static final DotEnv _dotEnv = DotEnv();

  ///Connection Status
  static Future<bool> connected() async =>
      await Connectivity().checkConnectivity() != ConnectivityResult.none;

  ///Initialize Main Services:
  ///
  ///- Widgets Binding.
  ///- Local Data (Hive).
  ///- Cached Image Engine (FastCachedNetworkImage).
  ///- Cache News Articles (If Online).
  ///- Notifications Service.
  ///- New Article Catcher (NewsFetch).
  ///- Environment Variables (DotEnv).
  ///- Remote Data (Supabase).
  ///- TTS.
  static Future<void> init() async {
    //Ensure Widgets Binding is Initialized
    WidgetsFlutterBinding.ensureInitialized();

    //Local Data
    await LocalData.init();

    //Cached Image Engine - Cache for 7 Days
    await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 7));

    //Cache News Articles - If Online
    if (await connected()) {
      await NewsFetch.fetchAndCache();
    }

    //Notifications Service
    await Notifications.setupService();

    //Get News Articles & Notify
    await NewsFetch.setupBackgroundFetch();

    //Environment Variables
    await _dotEnv.load();

    //Remote Data
    await Supabase.initialize(
      url: _dotEnv.get("SUPABASE_URL"),
      anonKey: _dotEnv.get("SUPABASE_KEY"),
    );

    //TTS
    await TTSEngine.init();
  }

  ///Initial Route
  static Future<String> initialRoute() async {
    //Intro Status
    final bool introStatus = LocalData.boxData(box: "intro")["status"] ?? false;

    //Return Initial Route
    return introStatus ? "/" : "/intro";
  }
}
