import 'package:flutter/material.dart';
import 'package:solemate_app/screen/aboutme_screen.dart';
import 'package:solemate_app/screen/cart_screen.dart';
import 'package:solemate_app/screen/home_screen.dart';
import 'package:solemate_app/screen/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPageIndex = 0;

  final List<Widget> pages = <Widget>[
    HomePage(),
    CartPage(),
    AboutMePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About Me',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: currentPageIndex,
        onTap: (value) {
          setState(() {
            currentPageIndex = value;
          });
        },
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        showUnselectedLabels: true,
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
      ),
    );
  }
}
