import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'home/home.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final String _baseUrl = "10.0.2.2:9090";

  late SharedPreferences prefs;
  late Future<bool> currencyFetched;
  late Currency currency;
  late User user;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  Future<bool> fetchCurrency() async {
    prefs = await SharedPreferences.getInstance();
    currency = Currency(
        image: prefs.getString("currencyimage")!,
        name: prefs.getString("currencyname")!,
        id: prefs.getString("currencyId"),
        description: prefs.getString("currencyDescription"),
        code: prefs.getString("currencyCode"),
        unitPrice: prefs.getDouble("currencyUnitPrice"));
    user = User(
      userId: prefs.getString("userId"),
      username: prefs.getString("username"),
      identifier: prefs.getString("identifier"),
      balance: prefs.getDouble("balance"),
    );
    return true;
  }

  @override
  void initState() {
    _amountController.text = "0";
    currencyFetched = fetchCurrency();
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: currencyFetched,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(currency.name!),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: Image.network(
                        "http://10.0.2.2:9090/${currency.image}",
                        width: 150,
                        height: 150),
                  ),
                  Text("${currency.name!}[${currency.code!}]",
                      textScaleFactor: 2),
                  Text("\$${currency.unitPrice.toString()}"),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 50),
                    child: Text(
                      currency.description!,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: TextField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: user.userId,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Amount",
                            ),
                            onChanged: (value) {
                              setState(() {
                                _quantityController.text =
                                    (double.parse(value) * currency.unitPrice!)
                                        .toString();
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                            width:
                                80), // Adjust the spacing between the text fields
                        Expanded(
                          child: TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: (double.parse(_amountController.text) *
                                      currency.unitPrice!)
                                  .toString(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              icon: const Icon(Icons.shopping_basket_rounded),
              label: const Text("Achter"),
              onPressed: () {
                String userId = user.userId!; // Replace with your user ID
                String currencyId =
                    currency.id!; // Replace with the currency ID
                int quantity = int.parse(_amountController.text);

                // Construct the request URL with the user ID in the path
                Uri url = Uri.http(_baseUrl, "/api/currencies/$userId");

                // Create the request body as a Map
                Map<String, dynamic> requestBody = {
                  "currencyId": currencyId,
                  "quantity": quantity,
                };
                Map<String, String> headers = {
                  "Content-Type": "application/json; charset=UTF-8"
                };
                // Send the POST request
                http
                    .post(url, body: json.encode(requestBody), headers: headers)
                    .then((http.Response response) async {
                  dynamic body = json.decode(response.body);
                  if (response.statusCode == 200) {
                    prefs.setDouble(
                        "balance", double.parse(body["balance"].toString()));
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Congrats"),
                          content: Text(
                              "You just bought $quantity ${currency.name!} ${currency.code!}"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Dismiss the dialog
                              },
                              child: const Text("Dismiss"),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Warning"),
                          content: const Text("No available funds"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Dismiss the dialog
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                });
              },
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class User {
  String? userId;
  String? username;
  String? identifier;
  double? balance;
  User({this.userId, this.username, this.identifier, this.balance});
}
