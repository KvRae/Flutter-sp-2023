import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../home/home.dart';
import 'my_currency_info.dart';

class Mycurrencys extends StatefulWidget {
  const Mycurrencys({Key? key}) : super(key: key);

  @override
  State<Mycurrencys> createState() => _MycurrencysState();
}

class _MycurrencysState extends State<Mycurrencys> {
  late Future<bool> fetchedcurrencies;

  final List<Currency> _currencies = [];

  final String _baseUrl = "10.0.2.2:9090";

  Future<bool> fetchCurrencies() async {
    http.Response response = await http
        .get(Uri.http(_baseUrl, "/library/" + "6391a15b7767bd6acfb206da"));

    List<dynamic> currenciesFromServer = json.decode(response.body);
    currenciesFromServer.forEach((currency) {
      _currencies.add(Currency(
          image: currency["image"],
          name: currency["name"],
          description: currency["description"],
          unitPrice: double.parse(currency["unitPrice"].toString()),
          code: currency["code"],
          id: currency["_id"]));
    });

    return true;
  }

  @override
  void initState() {
    fetchedcurrencies = fetchCurrencies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchedcurrencies,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
            itemCount: _currencies.length,
            itemBuilder: (BuildContext context, int index) {
              return MyCurrencyInfo(
                  _currencies[index].image!, _currencies[index].name!);
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 120,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5),
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
