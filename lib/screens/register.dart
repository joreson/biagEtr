import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mad2_etr/screens/login.dart';
import 'package:quickalert/quickalert.dart';

class register extends StatefulWidget {
  register({super.key});

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  final formKey = GlobalKey<FormState>();
  var email = TextEditingController();
  var password = TextEditingController();
  var fname = TextEditingController();
  var lname = TextEditingController();
  var confirmPassword = TextEditingController();
  var address = TextEditingController();
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                    'To register as Client, please enter the needed information.'),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: fname,
                  decoration: setTextDecoration('First Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required.';
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: lname,
                  decoration: setTextDecoration('Last Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: email,
                  decoration: setTextDecoration('Email Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required.';
                    }
                    if (!EmailValidator.validate(value)) {
                      return 'Invalid email';
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: address,
                  maxLines: 3,
                  decoration: setTextDecoration('Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: showPassword,
                  controller: password,
                  decoration: setTextDecoration('Password', isPassword: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required.';
                    }
                    // if (value.length < 7) {
                    //   return 'Password should be more than 6 characters.';
                    // }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: showPassword,
                  controller: confirmPassword,
                  decoration: setTextDecoration('Confirm Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required.';
                    }
                    // if (value.length < 7) {
                    //   return 'Password should be more than 6 characters.';
                    // }
                    if (password.text != value) {
                      return 'Passwords do not match.';
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: register,
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration setTextDecoration(String name, {bool isPassword = false}) {
    return InputDecoration(
      border: const OutlineInputBorder(),
      label: Text(name),
      suffixIcon: isPassword
          ? IconButton(
              onPressed: toggleShowPassword,
              icon: Icon(
                showPassword ? Icons.visibility : Icons.visibility_off,
              ),
            )
          : null,
    );
  }

  void register() {
    //validate
    if (!formKey.currentState!.validate()) {
      return;
    }
    //confirm to the user
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      // text: 'sample',
      title: 'Are you sure?',
      confirmBtnText: 'YES',
      cancelBtnText: 'No',
      onConfirmBtnTap: () {
        //register in firebase auth
        Navigator.of(context).pop();
        registerClient();
      },
    );
  }

  void registerClient() async {
    try {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        title: 'Loading',
        text: 'Registering your account',
      );
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text, password: password.text);
      //firestore add document
      String user_id = userCredential.user!.uid;
      print(DateTime.now());
      await FirebaseFirestore.instance.collection('users').doc(user_id).set({
        'FName': fname.text,
        'LName': lname.text,
        'Email': email.text,
        'Address': address.text,
        'UserId': user_id,
      });
      // .add({
      //   'fnameController': fnameController.text,
      //   'lnameController': lnameController.text,
      //   'email': email.text,
      // });
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => Login()));
    } on FirebaseAuthException catch (ex) {
      Navigator.of(context).pop();
      var errorTitle = '';
      var errorText = '';
      if (ex.code == 'weak-password') {
        errorText = 'Please enter a password with more than 6 characters';
        errorTitle = 'Weak Password';
      } else if (ex.code == 'email-already-in-use') {
        errorText = 'Password is already registered';
        errorTitle = 'Please enter a new email.';
      }

      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: errorTitle,
        text: errorText,
      );
    }
  }

  void toggleShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }
}
