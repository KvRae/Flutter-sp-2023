import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateUser extends StatefulWidget {
  const UpdateUser({Key? key}) : super(key: key);

  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  late String? _currentPassword;
  late String? _newPassword;
  late String? _address;

  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

  final String _baseUrl = "10.0.2.2:9090";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paramètres du profil"),
      ),
      body: Form(
        key: _keyForm,
        child: ListView(
          children: [
            Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Image.asset("assets/images/minecraft.jpg", width: 460, height: 215)
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Mot de passe actuel"),
                onSaved: (String? value) {
                  _currentPassword = value;
                },
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return "Le mot de passe ne doit pas etre vide";
                  }
                  else if(value.length < 5) {
                    return "Le mot de passe doit avoir au moins 5 caractères";
                  }
                  else {
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
                    border: OutlineInputBorder(), labelText: "Nouveau mot de passe"),
                onSaved: (String? value) {
                  _newPassword = value;
                },
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return "Le mot de passe ne doit pas etre vide";
                  }
                  else if(value.length < 5) {
                    return "Le mot de passe doit avoir au moins 5 caractères";
                  }
                  else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
              child: TextFormField(
                maxLines: 4,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Adresse de facturation"),
                onSaved: (String? value) {
                  _address = value;
                },
                validator: (value) {
                  if(value == null || value.isEmpty) {
                    return "L'adresse email ne doit pas etre vide";
                  }
                  else if(value.length < 20) {
                    return "Le mot de passe doit avoir au moins 20 caractères";
                  }
                  else {
                    return null;
                  }
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
              child: ElevatedButton(
                child: const Text("Enregistrer"),
                onPressed: () {
                  if(_keyForm.currentState!.validate()) {
                    _keyForm.currentState!.save();

                    Map<String, dynamic> userData = {
                      "password" : _newPassword,
                      "address" : _address
                    };

                    Map<String, String> headers = {
                      "Content-Type": "application/json; charset=UTF-8"
                    };

                    http.patch(Uri.http(_baseUrl, "/user/" + "6391a15b7767bd6acfb206da"), headers: headers, body: json.encode(userData))
                        .then((http.Response response) {
                      if(response.statusCode == 200) {
                        Navigator.pop(context);
                      }
                      else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AlertDialog(
                                title: Text("Information"),
                                content: Text("Une erreur s'est produite. Veuillez réessayer !"),
                              );
                            });
                      }
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
