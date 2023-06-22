import 'package:flutter/material.dart';
import 'package:workshop_4sim2223/reset_password.dart';
import 'package:workshop_4sim2223/signin.dart';
import 'package:workshop_4sim2223/update_user.dart';

import 'my_currencies/my_currencies.dart';
import 'navigations/nav_bottom.dart';
import 'navigations/nav_tab.dart';
import 'MyCurrencies.dart';
import 'product_details.dart';
import 'home/home.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EXamen Flutter',
      routes: {
        "/": (context) {
          //return const SplashScreen();
          return const Signin();
        },
        "/signin": (context) {
          return Signin();
        },
        "/myCurrencies": (context) {
          return MyCurrencies();
        },
        "/resetPwd": (context) {
          return ResetPassword();
        },
        "/home": (context) {
          return Home();
        },
        "/home/update": (context) {
          return UpdateUser();
        },
        "/homeTab": (context) {
          return NavigationTab();
        },
        "/homeBottom": (context) {
          return NavigationBottom();
        },
        "/home/details": (context) {
          return ProductDetails();
        },
      },
    );
  }
}
