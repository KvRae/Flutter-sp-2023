import 'dart:ffi';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'product_info.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Currency> _currencies = [];
  double? balance;
  final String _baseUrl = "10.0.2.2:9090";
  late Future<bool> fetchedCurrencies;

  Future<bool> fetchCurrencies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    balance = prefs.getDouble("balance");
    http.Response response =
        await http.get(Uri.http(_baseUrl, "/api/currencies"));
    List<dynamic> CurrenciesFromServer = json.decode(response.body);
    for (var currency in CurrenciesFromServer) {
      _currencies.add(Currency(
        id: currency["_id"],
        image: currency["image"],
        name: currency["name"],
        unitPrice: double.parse(currency["unitPrice"].toString()),
        code: currency["code"],
        description: currency["description"],
      ));
    }
    return true;
  }

  @override
  void initState() {
    fetchedCurrencies = fetchCurrencies();
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchedCurrencies,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Text(
                  'BALANCE',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "\$${balance}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Text("Popular coins"),
              Expanded(
                child: ListView.builder(
                  itemCount: _currencies.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ProductInfo(_currencies[index]);
                  },
                ),
              ),
            ],
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

class Currency {
  final String? id;
  final String? image;
  final String? name;
  final double? unitPrice;
  final String? code;
  final String? description;

  Currency({
    this.id,
    this.image,
    this.name,
    this.unitPrice,
    this.code,
    this.description,
  });

  @override
  String toString() {
    return 'Currency{image: $image, name: $name, description: $description, unitPrice: $unitPrice, code: $code}';
  }
}
