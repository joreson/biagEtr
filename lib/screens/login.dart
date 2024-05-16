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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  "asset/image/logo.png",
                  width: 250,
                  height: 250,
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(13),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(37, 103, 36, 1),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(13),
                      ),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    label: Text('Email'),
                  ),
                  controller: email,
                ),
                Gap(10),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(13),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(37, 103, 36, 1),
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(13),
                      ),
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    label: Text('Password'),
                  ),
                  controller: password,
                ),
                Gap(25),
                TextButton(
                  onPressed: () {
                    login();
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(37, 103, 36, 1),
                    ), // Change color here
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust the value as needed
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("First time here?"),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => register()));
                        },
                        child: Text(
                          "Sign up",
                          style:
                              TextStyle(color: Color.fromRGBO(37, 103, 36, 1)),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
