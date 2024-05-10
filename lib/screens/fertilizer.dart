import 'package:flutter/material.dart';

class fertilizer extends StatelessWidget {
  const fertilizer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(37, 103, 36, 1),
        title: Text("Fertilizer"),
        centerTitle: true,
      ),
    );
  }
}
