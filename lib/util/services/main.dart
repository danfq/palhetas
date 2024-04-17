import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:palhetas/pages/intro/intro.dart';
import 'package:palhetas/pages/palhetas.dart';
import 'package:palhetas/util/data/local.dart';
import 'package:palhetas/util/services/tts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

///Main Services
class MainServices {
  ///DotEnv Instance
  static final DotEnv _dotEnv = DotEnv();

  ///Initialize Main Services:
  ///
  ///- Widgets Binding.
  ///- Cached Image Engine (FastCachedNetworkImage).
  ///- Environment Variables (DotEnv).
  ///- Remote Data (Supabase).
  ///- Local Data (Hive).
  ///- TTS.
  static Future<void> init() async {
    //Ensure Widgets Binding is Initialized
    WidgetsFlutterBinding.ensureInitialized();

    //Cached Image Engine - Cache for 7 Days
    await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 7));

    //Environment Variables
    await _dotEnv.load();

    //Remote Data
    await Supabase.initialize(
      url: _dotEnv.get("SUPABASE_URL"),
      anonKey: _dotEnv.get("SUPABASE_KEY"),
    );

    //Local Data
    await LocalData.init();

    //TTS
    await TTSEngine.init();
  }

  ///Initial Route
  static Future<Widget> initialRoute() async {
    //Intro Status
    final bool introStatus = LocalData.boxData(box: "intro")["status"] ?? false;

    //Return Initial Route
    return introStatus ? const Palhetas() : const Intro();
  }
}
