import 'package:flutter/material.dart';

class BioBox extends StatelessWidget {
  const BioBox({super.key, this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    if (text != null && text!.isNotEmpty) {
      return Container(
        margin: EdgeInsets.only(top: 10),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Text(
          text ?? '',
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
