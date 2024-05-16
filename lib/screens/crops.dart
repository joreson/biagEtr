import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mad2_etr/screens/cropDetails.dart';
import 'package:mad2_etr/screens/cropsAdd.dart';

class Crops extends StatefulWidget {
  const Crops({Key? key}) : super(key: key);

  @override
  _CropsState createState() => _CropsState();
}

class _CropsState extends State<Crops> {
  final _auth = FirebaseAuth.instance;
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController establishmentName = TextEditingController();
  TextEditingController address = TextEditingController();
  late Future<void> dataFuture;
  late List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();

    dataFuture = getData();
  }

  String cropName = " ";
  String expenses = " ";
  String plant = " ";
  String startDate = " ";
  String surveyNumber = " ";
  String seedType = " ";
  String cropId = " ";
  String endDate = " ";
  String revenue = " ";
  String status = " ";

  Future<void> getData() async {
    List<Map<String, dynamic>> tempList = [];

    User user = _auth.currentUser!;
    String _uid = user.uid;

    print(_uid);

    print('User email ${user.email}');

    // Fetching documents from "crop" collection
    final cropDocs = await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection("crop")
        .get();

    // Loop through each document and add its data to the tempList
    cropDocs.docs.forEach((doc) {
      // Retrieve title and position data from Firestore document
      var data = doc.data();
      cropName = data['cropName'];
      expenses = data['expenses'].toString();
      plant = data['plant'];
      startDate = data['startDate'];
      surveyNumber = data['surveyNumber'];
      seedType = data['seedType'];
      cropId = data['cropId'];
      endDate = data['endDate'];
      revenue = data['revenue'].toString();
      status = data['status'];

      tempList.add({
        'cropName': cropName,
        'expenses': expenses,
        'seedType': seedType,
        'startDate': startDate,
        'surveyNumber': surveyNumber,
        'plant': plant,
        'cropId': cropId,
        'revenue': revenue,
        'status': status
      });
    });

    print('Inside getData: $tempList');
    setState(() {
      items = tempList;
    });
  }

  Set<List<dynamic>> data = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              var item = items[index];
              return InkWell(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CropDetailScreen(cropDetails: item),
                    ),
                  );
                  await getData();
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ListTile(
                      leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(
                            "asset/image/rice.jpg",
                          )),
                      title: Text(
                        item['cropName'],
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Plant: ${item['plant']} "),
                          Text("Seed: ${item['seedType']} "),
                          Text("Planted on: ${item['startDate']} "),
                          Text("Survey Number: ${item['surveyNumber']}"),
                        ],
                      ),
                      trailing: Text(
                        item['status'] == 'Ongoing'
                            ? item['status']
                            : 'Finished',
                        style: TextStyle(
                          color: item['status'] == 'Ongoing'
                              ? Colors.amber
                              : Colors.green,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            FloatingActionButton(
              backgroundColor: Color.fromRGBO(37, 103, 36, 1),
              onPressed: () async {
                // Navigate to the cropAdd screen
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => cropAdd()),
                );
                // Refresh the data when returning back to this screen
                await getData();
              },
              child: const Icon(Icons.add),
            ),
          ]),
        )
      ],
    );
  }
}
