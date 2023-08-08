import 'package:flutter/material.dart';

class Customerdashboard extends StatefulWidget {
  const Customerdashboard({Key? key}) : super(key: key);

  @override
  State<Customerdashboard> createState() => _CustomerdashboardState();
}

class _CustomerdashboardState extends State<Customerdashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color.fromRGBO(254, 206, 12, 1.0),
      ),
      body: Column(

      ),
    );
  }
}
