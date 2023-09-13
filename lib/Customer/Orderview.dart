import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Orderview extends StatefulWidget {
  final Map<String, dynamic> selectedCardData;
  // final double km;

  Orderview({required this.selectedCardData});

  @override
  _OrderviewState createState() => _OrderviewState();
}

class _OrderviewState extends State<Orderview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text(
            'Per KM: RS ${widget.selectedCardData['chargesPerKm']}',
            style: TextStyle(fontSize: 18), // Add your desired style
          ),
        ],
      ),
    );
  }
}
