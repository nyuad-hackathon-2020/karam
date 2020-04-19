import 'package:conditional_builder/conditional_builder.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:karam/business-objects/cart.dart';
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
    var navBarTitles = ['Notifications', null, 'Orders'];
    var navBarItemsScreens = [
      NotificationsScreen(),
      ProductSearch(
        searchFilter: searchFilterController.text,
        changeFilter: (newFilterText) =>
            searchFilterController.text = newFilterText,
      ),
      OrdersScreen()
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: ConditionalBuilder(
          condition: _selectedIndex == 1,
          fallback: (context) => Text(navBarTitles[_selectedIndex]),
          builder: (context) => Center(
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
        ),
      ),
      body: navBarItemsScreens[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //TODO open cart
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Icon(Icons.shopping_cart),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: ValueListenableBuilder<Box<int>>(
                valueListenable: Cart.itemsListenable,
                builder: (context, _, __) {
                  return Text(
                    Cart.totalCartAmount.toString(),
                    style: TextStyle(color: Colors.black),
                  );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        onTap: _onItemTapped,
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        buttonBackgroundColor: Color.fromARGB(255, 0x66, 0xBA, 0x3f),
        color: Color.fromARGB(255, 0xE0, 0xE0, 0xE0),
        items: <Widget>[
          Icon(
            Icons.notifications,
            color: _selectedIndex == 0
                ? Colors.white
                : IconTheme.of(context).color,
          ),
          Icon(
            Icons.restaurant,
            color: _selectedIndex == 1
                ? Colors.white
                : IconTheme.of(context).color,
          ),
          Icon(
            Icons.menu,
            color: _selectedIndex == 2
                ? Colors.white
                : IconTheme.of(context).color,
          ),
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
