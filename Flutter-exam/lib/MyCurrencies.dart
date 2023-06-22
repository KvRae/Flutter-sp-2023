import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'MyCurrency.dart';
import 'home/home.dart';
import 'product_details.dart';

class MyCurrencies extends StatefulWidget {
  const MyCurrencies({super.key});

  @override
  State<MyCurrencies> createState() => _MyCurrenciesState();
}

class _MyCurrenciesState extends State<MyCurrencies> {
  late SharedPreferences prefs;
  late Future<bool> fetchedCurrencies;
  final List<MyCurrency> myCurrencies = [];
  late User user = User();
  final String _baseUrl = "10.0.2.2:9090";
  Future<bool> fetchMyCurrencies() async {
    prefs = await SharedPreferences.getInstance();

    user = User(
      userId: prefs.getString("userId"),
      username: prefs.getString("username"),
      identifier: prefs.getString("identifier"),
      balance: prefs.getDouble("balance"),
    );
    final http.Response response = await http.get(
      Uri.http(_baseUrl, "/api/currencies/liste/${user.userId}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> currencies = jsonDecode(response.body);
      //print(response.body);
      for (int i = 0; i < currencies.length; i++) {
        //print(currencies[i]["currency"]);
        myCurrencies.add(MyCurrency(
            currency: Currency(
                image: currencies[i]["currency"]["image"],
                name: currencies[i]["currency"]["name"],
                id: currencies[i]["currency"]["_id"],
                description: currencies[i]["currency"]["description"],
                code: currencies[i]["currency"]["code"],
                unitPrice: currencies[i]["currency"]["unitPrice"]),
            quantity: currencies[i]["quantity"],
            id: currencies[i]["_id"]));
      }
      //print(myCurrencies.length);
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    fetchedCurrencies = fetchMyCurrencies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Currencies"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: fetchedCurrencies,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Text(
                      '10 Different Currencies',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index) {
                        return MyCurrencyInfo(
                            "myCurrencies[index].currency!.image!", "hrllo");
                      },
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 120,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5),
                    ),
                  ),
                ]);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class MyCurrency {
  final Currency? currency;
  final double? quantity;
  final String? id;
  MyCurrency({
    required this.currency,
    required this.quantity,
    required this.id,
  });
}
