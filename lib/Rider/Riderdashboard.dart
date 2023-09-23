import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mr_taxi/Rider/Vehicaldata.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rider Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Riderdashboard(),
    );
  }
}

class Riderdashboard extends StatefulWidget {
  const Riderdashboard({Key? key}) : super(key: key);

  @override
  State<Riderdashboard> createState() => _RiderdashboardState();
}

class _RiderdashboardState extends State<Riderdashboard> {
  // Sample data for demonstration
  int orderCount = 5;
  double currentAmount = 150.0;
  List<Map<String, dynamic>> orders = [
    {
      'orderId': 1,
      'details': 'Order details 1',
      'status': 'Pending',
      'customermobile': '076000000',
      'cuslocation': 'kurunegala',
      'droplocation': 'colombo'
    },
    {
      'orderId': 2,
      'details': 'Order details 2',
      'status': 'Completed',
      'customermobile': '076000000',
      'cuslocation': 'kurunegala',
      'droplocation': 'colombo'
    },
    {
      'orderId': 3,
      'details': 'Order details 2',
      'status': 'Completed',
      'customermobile': '076000000',
      'cuslocation': 'kurunegala',
      'droplocation': 'colombo'
    },
    {
      'orderId': 4,
      'details': 'Order details 2',
      'status': 'Completed',
      'customermobile': '076000000',
      'cuslocation': 'kurunegala',
      'droplocation': 'colombo'
    },

    // Add more orders here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Rider Dashboard'),
      ),
      drawer: _buildSidebarDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _DashboardTile(
                  title: 'Order Count',
                  value: '$orderCount',
                  backgroundColor: Colors.black,
                ),
                _DashboardTile(
                  title: 'Current Amount',
                  value: '\$${currentAmount.toStringAsFixed(2)}',
                  backgroundColor: Colors.black,
                ),
              ],
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Vehicaldata()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Vehicle Details",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              "You can edit vehicle details",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromRGBO(254, 206, 12, 1.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.car_rental,
                            color: Colors.white,
                            size: 70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
            Text(
              ' Orders',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.black,
                      ),
                      child: ListTile(
                        title: Text(
                          'Order ID: ${orders[index]['orderId']}',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'Status: ${orders[index]['status']}',
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            _showOrderDetailsModal(context, orders[index]);
                          },
                          child: Text(
                            'View Details',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromRGBO(254, 206, 12, 1.0),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Vehicaldata()),
              );
            },
          ),
          // Add more sidebar items as needed
        ],
      ),
    );
  }

  void _showOrderDetailsModal(
      BuildContext context, Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ride Details:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Order ID: ${order['orderId']}'),
                Text('Status: ${order['status']}'),
                Text('Customer Location: ${order['cuslocation']}'),
                Text('Customer Drop Location: ${order['droplocation']}'),
                Text('Customer Contact number: ${order['customermobile']}'),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle the first button action
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // Change the color as needed
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(width: 16), // Add some spacing between the buttons
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle the second button action
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black, // Change the color as needed
                        ),
                        child: Text(
                          'Accept',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Location on Map:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Container(
                  height: 200, // Adjust the height as needed
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(6.9601, 79.9580), // Example coordinates
                      zoom: 10.0,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId('customer_location'),
                        position:
                            LatLng(6.9601, 79.9580), // Kelaniya, Sri Lanka
                      ),
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DashboardTile extends StatelessWidget {
  final String title;
  final String value;
  final Color backgroundColor;

  const _DashboardTile({
    required this.title,
    required this.value,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
