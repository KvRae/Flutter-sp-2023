import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../product_details.dart';
import 'home.dart';

class ProductInfo extends StatelessWidget {
  final Currency currency;

  const ProductInfo(this.currency);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("currencyId", currency.id!);
          prefs.setString("currencyimage", currency.image!);
          prefs.setString("currencyname", currency.name!);
          prefs.setString("currencyDescription", currency.description!);
          prefs.setDouble("currencyUnitPrice", currency.unitPrice!);
          prefs.setString("currencyCode", currency.code!);

          Navigator.pushNamed(context, "/home/details");
        },
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 20, 10),
              child: Image.network("http://10.0.2.2:9090/${currency.image}",
                  width: 70, height: 94),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currency.name!, textScaleFactor: 1.5),
                Text(currency.code!),
                Text("${currency.unitPrice}", textScaleFactor: 1)
              ],
            )
          ],
        ),
      ),
    );
  }
}
