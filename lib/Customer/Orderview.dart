import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Orderview extends StatefulWidget {
  final Map<String, dynamic> selectedCardData;

  var currentLocation;

  var searchLocation;

  var formattedDistance;

  var total  ;

  // final double km;

  Orderview({required this.selectedCardData,required this.currentLocation,required this.searchLocation,required this.formattedDistance});

  @override
  _OrderviewState createState() => _OrderviewState();
}

class _OrderviewState extends State<Orderview> {

  double totalAmount = 0.0; // Declare a variable to store the total amount

  @override
  void initState() {
    super.initState();
    // Calculate the total amount when the widget is initialized
    calculateTotalAmount();
  }

  void calculateTotalAmount() {
    // Calculate the total amount by multiplying chargesPerKm and formattedDistance

    String  chargesPerKm = widget.selectedCardData['chargesPerKm'];

    double? myDouble = double.tryParse(chargesPerKm);
    double distance = double.tryParse(widget.formattedDistance) ?? 0.0;
    totalAmount = (myDouble! * distance)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Rider Dashboard'),
      ),
      drawer: _buildSidebarDrawer(),

      body: Column(
        children: [
          Text(
            'vehicleModel ${widget.selectedCardData['vehicleModel']}',
            style: TextStyle(fontSize: 18), // Add your desired style
          ),
          Text(
            'Brand ${widget.selectedCardData['vehicleBrand']}',
            style: TextStyle(fontSize: 18), // Add your desired style
          ),
          Text(
            'Per KM: RS ${widget.selectedCardData['chargesPerKm']}',
            style: TextStyle(fontSize: 18), // Add your desired style
          ),
          Text(
            'Driver ${widget.selectedCardData['userId']}',
            style: TextStyle(fontSize: 18), // Add your desired style
          ),
          Text(
            'Current Location ${widget.currentLocation}',
            style: TextStyle(fontSize: 18), // Add your desired style
          ),
          Text(
            'Search Location ${widget.searchLocation}',
            style: TextStyle(fontSize: 18), // Add your desired style
          ),
          Text(
            'Distance ${widget.formattedDistance}',
            style: TextStyle(fontSize: 18), // Add your desired style
          ),
          Text(
            'Toatal Amount RS:  $totalAmount',
            style: TextStyle(fontSize: 18), // Add your desired style
          ),
        ],
      ),
    );
  }
}




Widget _buildSidebarDrawer() {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          child: Text(
            'Menu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Profile'),
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => Vehicaldata()),
            // );
          },
        ),
        // Add more sidebar items as needed
      ],
    ),
  );
}
