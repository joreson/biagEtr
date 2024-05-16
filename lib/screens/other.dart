import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:mad2_etr/screens/cropDetails.dart';
import 'package:mad2_etr/screens/cropsAdd.dart';

class other extends StatefulWidget {
  const other({super.key});

  @override
  State<other> createState() => _otherState();
}

class _otherState extends State<other> {
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  var addstock = TextEditingController();
  var addquantity = TextEditingController();
  var size = TextEditingController();

  void addSeed() async {
    final _auth = FirebaseAuth.instance;
    String user_id = _auth.currentUser!.uid;
    var newRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(user_id)
        .collection("Others")
        .add({
      'stockName': addstock.text,
      'quantity': int.tryParse(addquantity.text),
      'size': size.text,
    });
    String autoId = newRef.id;
    await newRef.update({"stockId": autoId});
    addstock.clear();
    addquantity.clear();
    size.clear();

    await getData();
    setState(() {});
  }

  late List<Map<String, dynamic>> items = [];
  Future<void> getData() async {
    List<Map<String, dynamic>> tempList = [];
    final _auth = FirebaseAuth.instance;
    User user = _auth.currentUser!;
    String _uid = user.uid;
    String stockNames = " ";
    String quantitys = " ";
    String size = " ";

    String stockId = " ";

    print(_uid);

    print('User email ${user.email}');

    // Fetching documents from "crop" collection
    final cropDocs = await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection("Others")
        .get();

    // Loop through each document and add its data to the tempList
    cropDocs.docs.forEach((doc) {
      // Retrieve t
      //itle and position data from Firestore document
      var data = doc.data();
      stockNames = data['stockName'];
      quantitys = data['quantity'].toString();
      size = data['size'];
      stockId = data['stockId'];

      tempList.add({
        'stockNames': stockNames,
        'quantitys': quantitys,
        'stockId': stockId,
      });
    });

    print('Inside getData: $tempList');
    setState(() {
      items = tempList;
    });
  }

  Future<void> deleteSeed(String stockId, int index) async {
    try {
      final _auth = FirebaseAuth.instance;
      User user = _auth.currentUser!;
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      String user_id = _auth.currentUser!.uid;
      await _firestore
          .collection('users')
          .doc(user_id)
          .collection("Others")
          .doc(stockId)
          .delete();

      // Remove the deleted item from the list
      setState(() {
        items.removeAt(index);
      });

      print('Expense successfully deleted!');
    } catch (e) {
      print('Error deleting expense: $e');
    }
  }

  void addQuantity(
    int i,
    String stockId,
    int currentQuatity,
  ) async {
    print(stockId);
    print(i);
    print(currentQuatity);

    final _auth = FirebaseAuth.instance;
    String user_id = _auth.currentUser!.uid;

    var cropRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user_id)
        .collection("Others")
        .doc(stockId)
        .update({'quantity': currentQuatity + i});
    await getData();
    ;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(37, 103, 36, 1),
        title: Text("Others"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                var item = items[index];
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Gap(25),
                          Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    color: Colors.red,
                  ),
                  key: Key(item['stockId']),
                  onDismissed: (direction) {
                    deleteSeed(
                        item['stockId'], index); // Call deleteExpense function
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(
                                "asset/image/otherlogo.png",
                              )),
                          title: Text(
                            item['stockNames'],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Gap(4),
                              Text(
                                "Size: ${item['size']} ",
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  style: ButtonStyle(),
                                  onPressed: () {
                                    int currentQuatity =
                                        int.tryParse(" ${item['quantitys']} ")!;
                                    int i = -1;
                                    addQuantity(
                                      i,
                                      item['stockId'],
                                      currentQuatity,
                                    );
                                  },
                                  icon: Icon(
                                    Icons.remove,
                                    color: Colors.red,
                                  )),
                              Text(" ${item['quantitys']} "),
                              IconButton(
                                  style: ButtonStyle(),
                                  onPressed: () {
                                    int currentQuatity =
                                        int.tryParse(" ${item['quantitys']} ")!;
                                    int i = 1;
                                    addQuantity(
                                      i,
                                      item['stockId'],
                                      currentQuatity,
                                    );
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.green,
                                  )),
                            ],
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () async {
                    final formKey = GlobalKey<FormState>();
                    // Navigate to the cropAdd screen
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Add other'),
                          content: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: addstock,
                                  decoration:
                                      InputDecoration(labelText: 'Stock Name'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Stock Name is required';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: size,
                                  decoration:
                                      InputDecoration(labelText: 'Size'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Seed Type is required';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: addquantity,
                                  decoration:
                                      InputDecoration(labelText: 'Quantity'),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Quantity is required';
                                    }
                                    // Check if the value contains only digits
                                    if (int.tryParse(value) == null) {
                                      return 'Please enter a valid number';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  addSeed();
                                  Navigator.of(context).pop();
                                }
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
                      },
                    );
                  },
                  child: const Icon(
                    Icons.add,
                  ),
                  backgroundColor: Color.fromRGBO(37, 103, 36, 1),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
