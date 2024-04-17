import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:palhetas/pages/palhetas.dart';
import 'package:palhetas/util/anim/handler.dart';
import 'package:palhetas/util/data/local.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    //Pages
    final pages = <PageViewModel>[
      //Welcome
      PageViewModel(
        image: AnimationsHandler.asset(animation: "hello"),
        title: "Bem-Vindo(a)!",
        body: "Bem-vindo(a) à App do Palhetas na Foz!",
      ),

      //News
      PageViewModel(
        image: AnimationsHandler.asset(animation: "news"),
        title: "Mantenha-se A Par",
        body: "Sempre que houver novidades, estarão disponíveis aqui.",
      ),

      //Share
      PageViewModel(
        image: AnimationsHandler.asset(animation: "share"),
        title: "Partilhe",
        body: "Partilhe os seus Artigos favoritos com amigos e família!",
      ),
    ];

    //UI
    return IntroductionScreen(
      pages: pages,
      showBackButton: true,
      showNextButton: true,
      showDoneButton: true,
      back: const Text("Back"),
      next: const Text("Next"),
      done: const Text(
        "Vamos!",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      onDone: () async {
        //Set Intro as Done
        await LocalData.setData(box: "intro", data: {"status": true}).then(
          //Go Home
          (_) => Get.offAll(() => const Palhetas()),
        );
      },
    );
  }
}
