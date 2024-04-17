import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:palhetas/util/notifications/toast.dart';
import 'package:palhetas/util/services/users.dart';
import 'package:palhetas/util/widgets/input.dart';
import 'package:palhetas/util/widgets/main.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  ///Username Controller
  final TextEditingController _usernameController = TextEditingController();

  ///E-mail Controller
  final TextEditingController _emailController = TextEditingController();

  ///Password Controller
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainWidgets.appBar(
        title: const Text("Nova Conta"),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Username
            Input(
              controller: _usernameController,
              placeholder: "Nome de Utilizador",
            ),

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
            final username = _usernameController.text.trim();

            //Check Fields
            if (email.isNotEmpty && password.isNotEmpty) {
              //Attempt to Sign In
              await Users.signUp(
                email: email,
                password: password,
                username: username,
                onSignUp: () {
                  //Success
                  LocalNotifications.toast(message: "Sucesso!");

                  //Go Back
                  Get.back();
                  Get.back();
                },
              );
            } else {
              LocalNotifications.toast(
                message: "Todos os campos são obrigatórios.",
              );
            }
          },
          child: const Text("Criar Conta"),
        ),
      ),
    );
  }
}
