import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mad2_etr/screens/home.dart';
import 'package:mad2_etr/screens/register.dart';
import 'package:quickalert/quickalert.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var email = TextEditingController();

  var password = TextEditingController();

  void login() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.text, password: password.text)
          .then((value) => {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => Home()))
              });
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-email') {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Invalid email',
          text: 'Check your email',
        );
      } else if (error.code == 'missing-password') {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Missing password',
          text: 'Input password',
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Invalid Credentials',
          text: 'Check your email and/or password',
        );
      }
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), label: Text("Email")),
                controller: email,
              ),
              Gap(10),
              TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), label: Text("Password")),
                controller: password,
              ),
              ElevatedButton(
                  onPressed: () {
                    login();
                  },
                  child: Text("Log in")),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("First time here?"),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => register()));
                      },
                      child: Text("Sign up"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
