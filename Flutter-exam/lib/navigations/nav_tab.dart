import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../basket/basket.dart';
import '../home/home.dart';
import '../my_currencies/my_currencies.dart';

class NavigationTab extends StatelessWidget {
  const NavigationTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Crypto Wallet"),
            centerTitle: true,
          ),
          drawer: Drawer(
            child: Column(
              children: [
                AppBar(
                  title: SizedBox(
                    height: 50,
                  ),
                ),
                ListTile(
                  title: Container(
                    child: Row(
                      children: const [
                        Icon(
                          Icons.wallet,
                          color: Colors.blue,
                        ),
                        //color all the row

                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "My Crypto-currencies",
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ],
                      //color all the row
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/myCurrencies");
                  },
                ),
                ListTile(
                  title: Row(
                    children: const [
                      Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove("userId");
                    Navigator.pushReplacementNamed(context, "/signin");
                  },
                )
              ],
            ),
          ),
          body: Home()),
    );
  }
}
