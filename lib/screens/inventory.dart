import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:mad2_etr/screens/fertilizer.dart';
import 'package:mad2_etr/screens/other.dart';
import 'package:mad2_etr/screens/pesticides.dart';
import 'package:mad2_etr/screens/seed.dart';

class inventory extends StatelessWidget {
  const inventory({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Gap(20),
          Expanded(
            child: GridView(
              padding: EdgeInsets.all(6),
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => seed(),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0)), // Adjust the radius as needed
                    child: GridTile(
                      footer: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Seed',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(37, 103, 36, 1)),
                          ),
                        ),
                      ),
                      child: Image.asset(
                        "asset/image/seeds.png",
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => fertilizer(),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: GridTile(
                      footer: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Fertilizer',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(37, 103, 36, 1)),
                          ),
                        ),
                      ),
                      child: Image.asset("asset/image/fertilizer.png"),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => pesticides(),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: GridTile(
                      footer: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Pesticides',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(37, 103, 36, 1)),
                          ),
                        ),
                      ),
                      child: Image.asset("asset/image/pesticide.png"),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => other(),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: GridTile(
                      footer: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            'Other',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color.fromRGBO(37, 103, 36, 1)),
                          ),
                        ),
                      ),
                      child: Image.asset("asset/image/other.png"),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
