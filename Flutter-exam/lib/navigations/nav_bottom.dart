import 'package:flutter/material.dart';

import '../basket/basket.dart';
import '../home/home.dart';
import '../my_currencies/my_currencies.dart';

class NavigationBottom extends StatefulWidget {
  const NavigationBottom({Key? key}) : super(key: key);

  @override
  State<NavigationBottom> createState() => _NavigationBottomState();
}

class _NavigationBottomState extends State<NavigationBottom> {
  int _currentIndex = 0;
  final List<Widget> _interfaces = [Home()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("G-Store ESPRIT")),
      drawer: Drawer(
        child: Column(
          children: [
            AppBar(
              title: const Text("G-Store ESPRIT"),
              automaticallyImplyLeading: false,
            ),
            ListTile(
              title: Row(
                children: const [
                  Icon(Icons.edit),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Modifier profil")
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, "/home/update");
              },
            ),
            ListTile(
              title: Row(
                children: const [
                  Icon(Icons.tab_outlined),
                  SizedBox(
                    width: 20,
                  ),
                  Text("Navigation par onglet")
                ],
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, "/homeTab");
              },
            )
          ],
        ),
      ),
      body: _interfaces[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Store"),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined), label: "Bibliothèque"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket), label: "panier")
        ],
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
      ),
    );
  }
}
