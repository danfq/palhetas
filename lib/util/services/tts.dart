import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';

///Text-to-Speech Engine
class TTSEngine {
  ///TTS Engine
  static final FlutterTts _tts = FlutterTts();

  ///Initialize
  static Future<void> init() async {
    //iOS Specific
    if (Platform.isIOS) {
      //Set Shared Instance
      await _tts.setSharedInstance(true);

      //Audio Categories - Bluetooth & More
      await _tts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.ambient,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        ],
      );
    }

    //Engine Options
    await _tts.setLanguage("pt-PT");
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(0.8);
  }

  ///Speak `text`
  static Future<void> speak({required String text}) async {
    await _tts.speak(text);
  }

  ///Stop Speaking
  static Future<void> stop() async {
    await _tts.stop();
  }
}
