import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:workshop_4sim2223/reset_password.dart';
import 'package:workshop_4sim2223/MyCurrencies.dart';

import 'home/home.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  late String? _username;
  late String? _Identifiant;

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  final String _baseUrl = "10.0.2.2:9090";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        //text alginement
        centerTitle: true,
      ),
      body: Form(
        key: _keyForm,
        child: ListView(
          children: [
            Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Image.asset("assets/images/LOGO.png",
                    width: 460, height: 215)),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 50, 10, 10),
              child: TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Username"),
                onSaved: (String? value) {
                  _username = value;
                }
                ,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your username";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "ID"),
                onSaved: (String? value) {
                  _Identifiant = value;
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your ID";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Container(
                margin: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: ElevatedButton(
                  child: const Text("Submit"),
                  onPressed: () {
                    if (_keyForm.currentState!.validate()) {
                      _keyForm.currentState!.save();

                      Map<String, dynamic> userData = {
                        "username": _username,
                        "identifier": _Identifiant
                      };

                      Map<String, String> headers = {
                        "Content-Type": "application/json; charset=UTF-8"
                      };

                      http
                          .post(Uri.http(_baseUrl, "/api/users/login/id"),
                              body: json.encode(userData), headers: headers)
                          .then((http.Response response) async {
                        if (response.statusCode == 200) {
                          Map<String, dynamic> userData =
                              json.decode(response.body);
                          //print(userData);
                          // Shared preferences
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString("userId", userData["_id"]);
                          prefs.setString("username", userData["username"]);
                          prefs.setString("identifier", userData["identifier"]);
                          prefs.setDouble("balance",
                              double.parse(userData["balance"].toString()));

                          Navigator.pushReplacementNamed(
                            context,
                            "/homeTab",
                          );
                        } else if (response.statusCode == 401) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                    title: Text("Error"),
                                    content:
                                        Text("Username or ID are incorrect"));
                              });
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                    title: Text("Information"),
                                    content: Text(
                                        "Une erreur est survenu, veuillez réessayer une autre fois"));
                              });
                        }
                      });
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}
