import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:karam/home_screens/orders.dart';
import 'package:karam/home_screens/product_search.dart';

import 'home_screens/notifications.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;
  TextEditingController searchFilterController;
  @override
  void initState() {
    super.initState();
    searchFilterController = TextEditingController();
    searchFilterController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchFilterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var navBarItemsScreens = [
      NotificationsScreen(),
      ProductSearch(searchFilter: searchFilterController.text),
      OrdersScreen()
    ];
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
            ),
            child: TextFormField(
              textAlign: TextAlign.center,
              controller: searchFilterController,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                hintText: 'Search Products',
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          )
        ],
      ),
      body: navBarItemsScreens[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.shopping_cart),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        onTap: _onItemTapped,
        items: <Widget>[
          Icon(Icons.notifications),
          Icon(Icons.restaurant),
          Icon(Icons.menu),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
