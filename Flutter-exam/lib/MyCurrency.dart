import 'package:flutter/material.dart';

class MyCurrencyInfo extends StatelessWidget {
  //const MyCurrencyInfo({super.key});
  final String _image;
  final String _title;
  const MyCurrencyInfo(this._image, this._title);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Card(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 20, 10),
              child:
                  Image.asset("assets/images/ADA.png", width: 155, height: 58),
            ),
            Text("_title")
          ],
        ),
      ),
    );
  }
}
