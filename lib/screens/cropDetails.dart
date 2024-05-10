import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';

class CropDetailScreen extends StatefulWidget {
  Map<String, dynamic> cropDetails;

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

  String expId = " ";
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

  Future<void> getTotalExp() async {
    final _auth = FirebaseAuth.instance;
    String user_id = _auth.currentUser!.uid;

    QuerySnapshot<Object?> expensesSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user_id)
        .collection("crop")
        .doc('${widget.cropDetails['cropId']}')
        .collection("expensesList")
        .get();

    calculateTotalAmount(expensesSnapshot);
  }

  Future<void> getData() async {
    List<Map<String, dynamic>> tempList = [];

    User user = _auth.currentUser!;
    String _uid = user.uid;

    final cropDocs = await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection("crop")
        .doc('${widget.cropDetails['cropId']}')
        .collection("expensesList")
        .get();

    cropDocs.docs.forEach((doc) {
      var data = doc.data();
      expName = data['expName'];
      date = data['date'].toString();
      amount = data['amount'].toString();
      expId = data['expId'].toString();
      tempList.add(
        {'expName': expName, 'date': date, 'amount': amount, 'expId': expId},
      );
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
    await newRef.update({"expId": autoId});

    await getData();
    await getTotalExp();

    setState(() {});
  }

  void editCrop() async {
    try {
      final _auth = FirebaseAuth.instance;
      String user_id = _auth.currentUser!.uid;
      var cropRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user_id)
          .collection("crop")
          .doc(widget.cropDetails['cropId']);

      await cropRef.set({
        "cropName": cropName.text,
        "plant": plant.text,
        "seedType": seedType.text,
        "surveyNumber": surveyNumber.text,
      }, SetOptions(merge: true));

      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        title: 'Success',
        text: 'Crop Updated',
      );

      // Fetch the updated data
      var updatedData = await cropRef.get();
      var updatedCropDetails = updatedData.data() as Map<String, dynamic>;

      // Update the state with the updated data
      setState(() {
        widget.cropDetails = updatedCropDetails;
      });

      // Dismiss the dialog
      Navigator.of(context).pop();
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

  var cropName = TextEditingController();

  var seedType = TextEditingController();
  var plant = TextEditingController();
  var surveyNumber = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void handleClick(String value) {
    if (value == 'Edit') {
      cropName.text = widget.cropDetails['cropName'];
      seedType.text = widget.cropDetails['seedType'];
      surveyNumber.text = widget.cropDetails['surveyNumber'];
      plant.text = widget.cropDetails['plant'];

      showDialog(
          context: context,
          barrierDismissible: false, // User must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Edit crop'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: cropName,
                      decoration: InputDecoration(labelText: 'Crop Name'),
                    ),
                    TextField(
                      controller: seedType,
                      decoration: InputDecoration(labelText: 'Seed Type'),
                    ),
                    TextField(
                      controller: plant,
                      decoration: InputDecoration(labelText: 'Plant'),
                    ),
                    TextField(
                      controller: surveyNumber,
                      decoration: InputDecoration(labelText: 'Survey Number'),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    // Add your logic here for cancel button press
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Add your logic here for button press
                    editCrop();
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Button'),
                ),
              ],
            );
          });
    }
    if (value == 'Finish Crop') {}
    if (value == 'Delete') {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // User must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delete Item?'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure you want to delete this crop?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // "No" button
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  String user_id = _auth.currentUser!.uid;
                  _firestore
                      .collection('users')
                      .doc(user_id)
                      .collection("crop")
                      .doc('${widget.cropDetails['cropId']}')
                      .delete();

                  print('crop successfully deleted!');
                  Navigator.pop(context);
                },
                child: Text('Yes'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> deleteExpense(String expenseId, int index) async {
    try {
      String user_id = _auth.currentUser!.uid;
      await _firestore
          .collection('users')
          .doc(user_id)
          .collection("crop")
          .doc('${widget.cropDetails['cropId']}')
          .collection("expensesList")
          .doc(expenseId)
          .delete();

      // Remove the deleted item from the list
      setState(() {
        items.removeAt(index);
      });
      getTotalExp();
      print('Expense successfully deleted!');
    } catch (e) {
      print('Error deleting expense: $e');
    }
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
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'Edit', 'Delete', 'Finish crop'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
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
                                      radius: 60,
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
                  return Dismissible(
                    key: Key(item['expId']),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (direction) {
                      deleteExpense(
                          item['expId'], index); // Call deleteExpense function
                    },
                    child: Card(
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
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
