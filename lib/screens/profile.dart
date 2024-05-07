import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:mad2_etr/screens/login.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  late List<Map<String, dynamic>> items = [];
  void initState() {
    // TODO: implement initState
    super.initState();

    getD();
  }

  final _auth = FirebaseAuth.instance;
  // history

  String fullName = " ";
  String fname = " ";
  String lname = " ";
  String email = " ";
  String address = " ";

  void getD() async {
    List<Map<String, dynamic>> tempList = [];

    User user = _auth.currentUser!;
    String _uid = user.uid;

    print(_uid);

    print('User email ${user.email}');
    final userDoc = await FirebaseFirestore.instance
        .collection('transaction')
        .where('clientId', isEqualTo: _uid)
        .get();
    var userDocData = await userDoc.docs;

    final userClient =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    address = userClient.get('Address');
    fname = userClient.get('FName');
    lname = userClient.get('LName');
    email = userClient.get('Email');

    fullName = '$fname  $lname';
    userDocData.forEach((uData) {
      tempList.add(uData.data());
    });

    setState(() {
      items = tempList;
    });
  }

  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(40),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Color.fromARGB(206, 14, 238, 33),
                  radius: 35,
                  child: Icon(
                    Icons.person,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                Gap(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    Text(email,
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                    Text(address,
                        style: TextStyle(
                          color: Colors.grey,
                        )),
                  ],
                )
              ],
            ),
            Gap(20),
            Container(
              color: Colors.grey,
              height: 0.5,
            ),
            Gap(20),
            Text("Feedback and information",
                style: TextStyle(
                  color: Colors.grey,
                )),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text("Contact Us",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                  ListTile(
                    title: Text("About",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                  ListTile(
                    title: Text("Share App",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                  ListTile(
                    title: Text("Rate App",
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                  Gap(20),
                  Container(
                    color: Colors.grey,
                    height: 0.5,
                  ),
                  TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Login(),
                          ),
                        );
                      },
                      child: Text("Logout",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.red)))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
