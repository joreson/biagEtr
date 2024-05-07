import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';

class CropDetailScreen extends StatefulWidget {
  final Map<String, dynamic> cropDetails;

  CropDetailScreen({required this.cropDetails});

  @override
  State<CropDetailScreen> createState() => _CropDetailScreenState();
}

class _CropDetailScreenState extends State<CropDetailScreen> {
  final _auth = FirebaseAuth.instance;
  var expAddName = TextEditingController();
  var expAddAmount = TextEditingController();
  DateTime addDate = DateTime.now();
  late Future<void> dataFuture;
  late List<Map<String, dynamic>> items = [];
  double totalAmount = 0.0;
  bool isExpanded = false;
  @override
  void initState() {
    super.initState();
    dataFuture = getData();
    getTotalExp();
  }

  String expName = " ";
  String date = " ";
  String amount = " ";

  void calculateTotalAmount(QuerySnapshot<Object?> expensesSnapshot) {
    double total = 0.0;
    for (var expense in expensesSnapshot.docs) {
      total += double.parse(expense['amount'].toString());
    }
    setState(() {
      totalAmount = total;
    });
  }

  // Your getData function
  Future<void> getTotalExp() async {
    final _auth = FirebaseAuth.instance;
    String user_id = _auth.currentUser!.uid;

    // Fetch expenses data from Firestore
    QuerySnapshot<Object?> expensesSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user_id)
        .collection("crop")
        .doc('${widget.cropDetails['cropId']}')
        .collection("expensesList")
        .get();

    // Calculate total amount
    calculateTotalAmount(expensesSnapshot);
  }

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
        .doc('${widget.cropDetails['cropId']}')
        .collection("expensesList")
        .get();

    // Loop through each document and add its data to the tempList
    cropDocs.docs.forEach((doc) {
      // Retrieve title and position data from Firestore document
      var data = doc.data();
      expName = data['expName'];
      date = data['date'].toString();
      amount = data['amount'].toString();

      tempList.add({
        'expName': expName,
        'date': date,
        'amount': amount,
      });
    });

    print('Inside getData: $tempList');
    setState(() {
      items = tempList;
    });
  }

  Set<List<dynamic>> data = {};

  void addExpenses() async {
    final _auth = FirebaseAuth.instance;
    String user_id = _auth.currentUser!.uid;
    var newRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(user_id)
        .collection("crop")
        .doc('${widget.cropDetails['cropId']}')
        .collection("expensesList")
        .add({
      'expName': expAddName.text,
      'amount': expAddAmount.text,
      'date': DateFormat('MMM-d-yyyy').format(DateTime.now()).toString(),
    });
    String autoId = newRef.id;
    await newRef.update({"cropId": autoId});
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: 'Success',
      text: 'Expenses added',
    );
    expAddAmount.clear();
    expAddName.clear();

    await getData();
    await getTotalExp();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 228, 228, 228),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color.fromARGB(255, 17, 197, 143),
          title: Text(
            'Crop Details',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        height: 150,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                      radius: 50,
                                      backgroundImage: AssetImage(
                                        "asset/image/rice.jpg",
                                      )),
                                ],
                              ),
                              Gap(20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ' ${widget.cropDetails['cropName']}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    ' ${widget.cropDetails['plant']}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromARGB(
                                            255, 114, 114, 114)),
                                  ),
                                  Text(
                                    'Seed Type: ${widget.cropDetails['seedType']}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: const Color.fromARGB(
                                            255, 114, 114, 114)),
                                  ),
                                  Text(
                                    'Planted on: ${widget.cropDetails['startDate']}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: const Color.fromARGB(
                                            255, 114, 114, 114)),
                                  ),
                                  Text(
                                    'Survey Number: ${widget.cropDetails['surveyNumber']}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: const Color.fromARGB(
                                            255, 114, 114, 114)),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(Icons.more_vert))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text("Total Expenses"),
                              Text(
                                '₱${totalAmount}',
                                style: TextStyle(
                                  fontSize: 35,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Add Expenses'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextField(
                                              controller: expAddName,
                                              decoration: InputDecoration(
                                                  labelText: 'Expenses Name'),
                                            ),
                                            TextField(
                                              controller: expAddAmount,
                                              decoration: InputDecoration(
                                                  labelText: 'Amount'),
                                            ),
                                          ],
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              addExpenses();
                                              // Add your logic here for adding the item
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Add'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Cancel'),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              icon: Icon(Icons.add))
                        ],
                      ),
                    )
                  ],
                ),
                // Add more details if needed
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  var item = items[index];
                  return Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ListTile(
                        title: Text(
                          item['expName'],
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text("Amount: ${item['amount']} "),
                        trailing: Text("${item['date']} "),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
