import 'package:flutter/material.dart';

class seed extends StatelessWidget {
  const seed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(37, 103, 36, 1),
        title: Text("Seeds"),
        centerTitle: true,
      ),
    );
  }
}
