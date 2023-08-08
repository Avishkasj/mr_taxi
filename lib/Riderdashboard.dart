import 'package:flutter/material.dart';
class Riderdashboard extends StatefulWidget {
  const Riderdashboard({Key? key}) : super(key: key);

  @override
  State<Riderdashboard> createState() => _RiderdashboardState();
}

class _RiderdashboardState extends State<Riderdashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(254, 206, 12, 1.0),
        title: Text('User Dashboard'),
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
