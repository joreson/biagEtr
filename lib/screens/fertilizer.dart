import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

class fertilizer extends StatefulWidget {
  const fertilizer({super.key});

  @override
  State<fertilizer> createState() => _fertilizerState();
}

class _fertilizerState extends State<fertilizer> {
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  var addfertilizer = TextEditingController();
  var addquantity = TextEditingController();
  var addFertilizerBrandName = TextEditingController();

  void addFertilizer() async {
    final _auth = FirebaseAuth.instance;
    String user_id = _auth.currentUser!.uid;
    var newRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(user_id)
        .collection("Fertilizer")
        .add({
      'fertilizerBrandName': addFertilizerBrandName.text,
      'quantity': int.tryParse(addquantity.text),
      'fertilizerTypes': addfertilizer.text,
    });
    String autoId = newRef.id;
    await newRef.update({"fertilizerId": autoId});
    addFertilizerBrandName.clear();
    addfertilizer.clear();
    addquantity.clear();

    await getData();
    setState(() {});
  }

  late List<Map<String, dynamic>> items = [];
  Future<void> getData() async {
    List<Map<String, dynamic>> tempList = [];
    final _auth = FirebaseAuth.instance;
    User user = _auth.currentUser!;
    String _uid = user.uid;
    String fertilizerTypes = " ";
    String quantitys = " ";
    String FertilizerBrandNames = " ";
    String fertilizerId = " ";

    print(_uid);

    print('User email ${user.email}');

    // Fetching documents from "crop" collection
    final cropDocs = await FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection("Fertilizer")
        .get();

    // Loop through each document and add its data to the tempList
    cropDocs.docs.forEach((doc) {
      // Retrieve t
      //itle and position data from Firestore document
      var data = doc.data();
      fertilizerTypes = data['fertilizerTypes'];
      quantitys = data['quantity'].toString();
      FertilizerBrandNames = data['fertilizerBrandName'];
      fertilizerId = data['fertilizerId'];

      tempList.add({
        'fertilizerTypes': fertilizerTypes,
        'quantitys': quantitys,
        'FertilizerBrandNames': FertilizerBrandNames,
        'fertilizerId': fertilizerId,
      });
    });

    print('Inside getData: $tempList');
    setState(() {
      items = tempList;
    });
  }

  Future<void> deleteSeed(String seedId, int index) async {
    try {
      final _auth = FirebaseAuth.instance;
      User user = _auth.currentUser!;
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      String user_id = _auth.currentUser!.uid;
      await _firestore
          .collection('users')
          .doc(user_id)
          .collection("Fertilizer")
          .doc(seedId)
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
    String fertilizerId,
    int currentQuatity,
  ) async {
    print(i);
    print(currentQuatity);

    final _auth = FirebaseAuth.instance;
    String user_id = _auth.currentUser!.uid;

    var cropRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user_id)
        .collection("Fertilizer")
        .doc(fertilizerId)
        .update({'quantity': currentQuatity + i});
    await getData();
    ;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(37, 103, 36, 1),
        title: Text("Fertilizer"),
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
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    deleteSeed(item['fertilizerId'],
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
                                "asset/image/ferlogo.png",
                              )),
                          title: Text(
                            item['fertilizerTypes'],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Gap(4),
                              Text(
                                "Type: ${item['FertilizerBrandNames']} ",
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
                                      item['fertilizerId'],
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
                                      item['fertilizerId'],
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
                          title: Text('Add Seeds'),
                          content: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: addfertilizer,
                                  decoration: InputDecoration(
                                      labelText: 'Fertilizer Type'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Fertilizer Type is required';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: addFertilizerBrandName,
                                  decoration:
                                      InputDecoration(labelText: 'Brand'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return ' Brand naame is required';
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
                                  addFertilizer();
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
