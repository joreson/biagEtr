import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:mad2_etr/screens/cropDetails.dart';
import 'package:mad2_etr/screens/cropsAdd.dart';

class pesticides extends StatefulWidget {
  const pesticides({super.key});

  @override
  State<pesticides> createState() => _pesticidesState();
}

class _pesticidesState extends State<pesticides> {
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  var addlabel = TextEditingController();
  var addpesticidesBrandName = TextEditingController();
  var addpesticidesTypes = TextEditingController();
  var addquantity = TextEditingController();
  var addsize = TextEditingController();

  void addPesticide() async {
    final _auth = FirebaseAuth.instance;
    String user_id = _auth.currentUser!.uid;
    var newRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(user_id)
        .collection("Pesticides")
        .add({
      'label': addlabel.text,
      'quantity': int.tryParse(addquantity.text),
      'pesticidesBrandName': addpesticidesBrandName.text,
      'size': addsize.text,
      'pesticidesTypes': addpesticidesTypes.text,
    });
    String autoId = newRef.id;
    await newRef.update({"pesticidesId": autoId});
    addlabel.clear();
    addpesticidesBrandName.clear();
    addpesticidesTypes.clear();
    addquantity.clear();
    addsize.clear();
    await getData();
    setState(() {});
  }

  late List<Map<String, dynamic>> items = [];
  Future<void> getData() async {
    List<Map<String, dynamic>> tempList = [];
    final _auth = FirebaseAuth.instance;
    User user = _auth.currentUser!;
    String _uid = user.uid;
    String label = " ";
    String pesticidesBrandName = " ";
    String pesticidesTypes = " ";
    String quantity = " ";
    String size = " ";
    String pesticidesId = " ";

    print(_uid);

    print('User email ${user.email}');

    // Fetching documents from "crop" collection
    final cropDocs = await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection("Pesticides")
        .get();

    // Loop through each document and add its data to the tempList
    cropDocs.docs.forEach((doc) {
      // Retrieve t
      //itle and position data from Firestore document
      var data = doc.data();
      label = data['label'];
      quantity = data['quantity'].toString();
      pesticidesBrandName = data['pesticidesBrandName'];
      pesticidesId = data['pesticidesId'];
      size = data['size'].toString();

      pesticidesTypes = data['pesticidesTypes'];

      tempList.add({
        'label': label,
        'quantity': quantity,
        'pesticidesBrandName': pesticidesBrandName,
        'pesticidesId': pesticidesId,
        'pesticidesTypes': pesticidesTypes,
        'size': size
      });
    });

    print('Inside getData: $tempList');
    setState(() {
      items = tempList;
    });
  }

  Future<void> deleteSeed(String pesticidesId, int index) async {
    try {
      final _auth = FirebaseAuth.instance;
      User user = _auth.currentUser!;
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      String user_id = _auth.currentUser!.uid;
      await _firestore
          .collection('users')
          .doc(user_id)
          .collection("Pesticides")
          .doc(pesticidesId)
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
    String pesticidesId,
    int currentQuatity,
  ) async {
    print(pesticidesId);
    print(i);
    print(currentQuatity);

    final _auth = FirebaseAuth.instance;
    String user_id = _auth.currentUser!.uid;

    var cropRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user_id)
        .collection("Pesticides")
        .doc(pesticidesId)
        .update({'quantity': currentQuatity + i});
    await getData();
    ;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(37, 103, 36, 1),
        title: Text("Pesticides"),
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
                  key: Key(item['pesticidesId']),
                  onDismissed: (direction) {
                    deleteSeed(item['pesticidesId'],
                        index); // Call deleteExpense function
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
                                "asset/image/pestlogo.png",
                              )),
                          title: Text(
                            item['pesticidesTypes'],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Gap(4),
                              Text(
                                "Brand: ${item['pesticidesBrandName']} ",
                                style: TextStyle(fontSize: 13),
                              ),
                              Text("Label: ${item['label']} ",
                                  style: TextStyle(fontSize: 13)),
                              Text("Size: ${item['size']} ml ",
                                  style: TextStyle(fontSize: 13)),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  style: ButtonStyle(),
                                  onPressed: () {
                                    int currentQuatity =
                                        int.tryParse(" ${item['quantity']} ")!;
                                    int i = -1;
                                    addQuantity(
                                      i,
                                      item['pesticidesId'],
                                      currentQuatity,
                                    );
                                  },
                                  icon: Icon(
                                    Icons.remove,
                                    color: Colors.red,
                                  )),
                              Text(" ${item['quantity']} "),
                              IconButton(
                                  style: ButtonStyle(),
                                  onPressed: () {
                                    int currentQuatity =
                                        int.tryParse(" ${item['quantity']} ")!;
                                    int i = 1;
                                    addQuantity(
                                      i,
                                      item['pesticidesId'],
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
                          title: Text('Add Pesticides'),
                          content: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: addpesticidesBrandName,
                                  decoration:
                                      InputDecoration(labelText: 'Brand name'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Brand name is required';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: addpesticidesTypes,
                                  decoration: InputDecoration(
                                      labelText: 'Pesticide type'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Pesticide yype is required';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: addlabel,
                                  decoration:
                                      InputDecoration(labelText: 'Label'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Label is required';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: addsize,
                                  decoration:
                                      InputDecoration(labelText: 'Size'),
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
                                  addPesticide();
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
