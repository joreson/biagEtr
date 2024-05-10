import 'package:flutter/material.dart';
import 'package:mad2_etr/screens/crops.dart';
import 'package:mad2_etr/screens/inventory.dart';
import 'package:mad2_etr/screens/profile.dart';
import 'package:mad2_etr/screens/weather.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0; // Changed initial index to 0
  PageController _pageController = PageController(); // Added PageController
  List<Widget> _screens = [
    Crops(),
    WeatherDisplay(),
    inventory(),
  ]; // Corrected screens for each navigation item

  // List of labels for bottom navigation items
  final List<String> _bottomNavLabels = ['Crops', 'Weather', 'Inventory'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(174, 184, 174, 1),
      drawer: profile(),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(37, 103, 36, 1),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
            _pageController.jumpToPage(index);
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.landscape,
              color: Color.fromRGBO(37, 103, 36, 1),
            ),
            label: currentPageIndex == 0 ? _bottomNavLabels[0] : '',
          ),
          BottomNavigationBarItem(
            icon:
                Icon(Icons.cloud_circle, color: Color.fromRGBO(37, 103, 36, 1)),
            label: currentPageIndex == 1 ? _bottomNavLabels[1] : '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_sharp,
                color: Color.fromRGBO(37, 103, 36, 1)),
            label: currentPageIndex == 2 ? _bottomNavLabels[2] : '',
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        children: _screens,
      ),
    );
  }
}
