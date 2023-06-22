import 'package:flutter/material.dart';

class MyCurrencyInfo extends StatelessWidget {
  final String _image;
  final String _name;

  const MyCurrencyInfo(this._image, this._name, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Card(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 20, 10),
              child: Image.asset(_image, width: 155, height: 58),
            ),
            Text(_name)
          ],
        ),
      ),
    );
  }
}
