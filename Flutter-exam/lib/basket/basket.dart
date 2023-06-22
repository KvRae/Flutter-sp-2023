import 'package:flutter/material.dart';

import '../home/home.dart';
import 'element_info.dart';

class Basket extends StatelessWidget {
  const Basket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Text(
              "Total : 500 TND",
              textScaleFactor: 1.5,
            )
          ],
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: const Divider(color: Colors.red)),
        Expanded(
          child: ListView(
            children: [
              ElementInfo(Currency(
                  image: "assets/images/dmc5.jpg",
                  name: "Devil May Cry 5",
                  unitPrice: 200)),
              ElementInfo(Currency(
                  image: "assets/images/re8.jpg",
                  name: "Resident Evil VIII",
                  unitPrice: 200)),
              ElementInfo(Currency(
                  image: "assets/images/nfs.jpg",
                  name: "Need For Speed Heat",
                  unitPrice: 100))
            ],
          ),
        )
      ],
    );
  }
}
