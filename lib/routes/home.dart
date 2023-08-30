import 'package:flutter/material.dart';
import 'package:bottom_bar/bottom_bar.dart';
import 'package:shop/routes/profile.dart';
import 'package:shop/routes/signUp.dart';
import 'package:shop/routes/stote.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bottom Bar Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentPage = 0;
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          StorePage(),
          ProfilePage(),
          Container(color: Color.fromARGB(255, 63, 7, 167)),
        ],
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
      ),
      bottomNavigationBar: BottomBar(
        textStyle: TextStyle(fontWeight: FontWeight.bold),
        selectedIndex: _currentPage,
        onTap: (int index) {
          _pageController.jumpToPage(index);
          setState(() => _currentPage = index);
        },
        items: <BottomBarItem>[
          BottomBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: Colors.blue,
            activeTitleColor: Colors.blue.shade600,
          ),
          BottomBarItem(
            icon: Icon(Icons.person),
            title: Text('Account'),
            backgroundColorOpacity: 0.1,
            activeColor: Colors.greenAccent.shade700,
          ),
          BottomBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('Shop'),
            activeColor: Color.fromARGB(255, 18, 143, 196),
            activeIconColor: Color.fromARGB(255, 132, 21, 45),
            activeTitleColor: Color.fromARGB(255, 231, 88, 133),
          ),
        ],
      ),
    );
  }
}
