import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:palhetas/pages/connection/none.dart';
import 'package:palhetas/pages/intro/intro.dart';
import 'package:palhetas/pages/palhetas.dart';
import 'package:palhetas/util/data/local.dart';

///Main Services
class MainServices {
  ///Initialize Main Services:
  ///
  ///- Widgets Binding.
  ///- Cached Image Engine (FastCachedNetworkImage)
  ///- Local Data (Hive).
  static Future<void> init() async {
    //Ensure Widgets Binding is Initialized
    WidgetsFlutterBinding.ensureInitialized();

    //Cached Image Engine - Cache for 7 Days
    await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 7));

    //Local Data
    await LocalData.init();
  }

  ///Initial Route
  static Future<Widget> initialRoute() async {
    //Connectivity Result
    final connResult = await Connectivity().checkConnectivity();

    //Connected
    final bool connected = connResult != ConnectivityResult.none;

    //Intro Status
    final bool introStatus = LocalData.boxData(box: "intro")["status"] ?? false;

    //Return Initial Route
    return connected
        ? introStatus
            ? const Palhetas()
            : const Intro()
        : const NoConnection();
  }
}
