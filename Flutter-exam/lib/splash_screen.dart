import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'navigations/nav_tab.dart';
import 'signin.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<bool> sessionFetched;
  late String route;

  Future<bool> fetchSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("userId")) {
      route = "home";
    }
    else {
      route = "signin";
    }

    return true;
  }

  @override
  void initState() {
    sessionFetched = fetchSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: sessionFetched,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          if(route=="home") {
            return NavigationTab();
          }
          else {
            return Signin();
          }
        }
        else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
