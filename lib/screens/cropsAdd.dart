import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:mad2_etr/screens/crops.dart';
import 'package:quickalert/quickalert.dart';

class cropAdd extends StatefulWidget {
  const cropAdd({super.key});

  @override
  State<cropAdd> createState() => _cropAddState();
}

class _cropAddState extends State<cropAdd> {
  Color cropNum2BorderColor = Colors.white;
  Color cropNum3BorderColor = Colors.white;

  var cropNameController = TextEditingController();
  var seedTypeController = TextEditingController();
  var plantController = TextEditingController();
  var surveyNumberController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String startDate = ' ';

  void addCrop() async {
    try {
      final _auth = FirebaseAuth.instance;
      String user_id = _auth.currentUser!.uid;
      var newRef = await FirebaseFirestore.instance
          .collection('users')
          .doc(user_id)
          .collection("crop")
          .add({
        'plant': plantController.text,
        'cropName': cropNameController.text,
        'seedType': seedTypeController.text,
        'startDate': startDate.toString(),
        'surveyNumber': surveyNumberController.text,
        'revenue': 0,
        'expenses': 0,
        'endDate': " ",
        'status': "Ongoing"
      });
      String autoId = newRef.id;
      await newRef.update({"cropId": autoId});
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Success',
        text: 'Crop added',
        onConfirmBtnTap: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      );
      cropNameController.clear();
      seedTypeController.clear();
      plantController.clear();
      surveyNumberController.clear();
      startDate = '';

      setState(() {});
    } on FirebaseAuthException catch (ex) {
      print('Register error: $ex');

      var errorTitle = '';
      var errorText = '';

      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: errorTitle,
        text: errorText,
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Crop"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: cropNameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text(
                      "Land Name",
                    )),
              ),
              Gap(10),
              TextField(
                controller: surveyNumberController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), label: Text("Survey Number")),
              ),
              Gap(10),
              Text(
                "Choose your plant:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              Gap(10),
              Row(
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            plantController.text = 'Rice';
                            cropNum3BorderColor =
                                Color.fromARGB(255, 255, 255, 255);
                            cropNum2BorderColor =
                                Color.fromARGB(255, 26, 245, 44);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: cropNum2BorderColor,
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundImage: AssetImage(
                              "asset/image/rice.jpg",
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "Rice",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            plantController.text = 'Corn';
                            cropNum2BorderColor =
                                Color.fromARGB(255, 255, 255, 255);
                            cropNum3BorderColor =
                                Color.fromARGB(255, 26, 245, 44);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: cropNum3BorderColor,
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundImage: AssetImage(
                              "asset/image/corn.jpg",
                            ),
                          ),
                        ),
                      ),
                      Text(
                        "Rice",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
              Gap(10),
              TextField(
                controller: seedTypeController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), label: Text("Seed Type")),
              ),
              Gap(10),
              Text(
                "Starting date:",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final DateTime? dateTime = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(1900),
                          lastDate: selectedDate);
                      if (dateTime != null) {
                        setState(() {
                          selectedDate = dateTime;
                          startDate = DateFormat('MMM - dd - yyyy')
                              .format(selectedDate);
                        });
                      }
                    },
                    label: const Text('Choose Date'),
                    icon: const Icon(Icons.calendar_month_rounded),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(startDate),
                ],
              ),
              Gap(20),
              ElevatedButton(
                  onPressed: () {
                    addCrop();
                  },
                  child: Text("Add "))
            ],
          ),
        ),
      ),
    );
  }
}
