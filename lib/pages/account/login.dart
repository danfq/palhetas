import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:palhetas/pages/account/create.dart';
import 'package:palhetas/util/notifications/toast.dart';
import 'package:palhetas/util/services/users.dart';
import 'package:palhetas/util/widgets/input.dart';
import 'package:palhetas/util/widgets/main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ///E-mail Controller
  final TextEditingController _emailController = TextEditingController();

  ///Password Controller
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainWidgets.appBar(
        title: const Text("Iniciar Sessão"),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const CreateAccount(),
                  ),
                );
              },
              child: const Text("Nova Conta"),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //E-mail
            Input(
              controller: _emailController,
              placeholder: "E-mail",
              isEmail: true,
            ),

            //Password
            Input(
              controller: _passwordController,
              placeholder: "Password",
              isPassword: true,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(40.0),
        child: ElevatedButton(
          onPressed: () async {
            //Fields
            final email = _emailController.text.trim();
            final password = _passwordController.text.trim();

            //Check Fields
            if (email.isNotEmpty && password.isNotEmpty) {
              //Attempt to Sign In
              await Users.signIn(
                email: email,
                password: password,
                onSignedIn: () {
                  //Signed In
                  LocalNotifications.toast(message: "Sucesso!");

                  //Go Back
                  Get.back();
                },
              );
            } else {
              LocalNotifications.toast(
                message: "Ambos os campos são obrigatórios.",
              );
            }
          },
          child: const Text("Iniciar Sessão"),
        ),
      ),
    );
  }
}
