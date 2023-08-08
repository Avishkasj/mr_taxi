import 'package:flutter/material.dart';
import 'package:mr_taxi/Rider/Riderprofile.dart';
import 'package:mr_taxi/Welcome.dart';

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
    {'orderId': 1, 'details': 'Order details 1', 'status': 'Pending'},
    {'orderId': 2, 'details': 'Order details 2', 'status': 'Completed'},
    // Add more orders here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(254, 206, 12, 1.0),
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
                  backgroundColor: Colors.blue,
                ),
                _DashboardTile(
                  title: 'Current Amount',
                  value: '\$${currentAmount.toStringAsFixed(2)}',
                  backgroundColor: Colors.green,
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'List of Orders:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Order ID: ${orders[index]['orderId']}'),
                    subtitle: Text('Status: ${orders[index]['status']}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Handle view order details and change status
                      },
                      child: Text('View Details'),
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
              color: Color.fromRGBO(254, 206, 12, 1.0),
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
                MaterialPageRoute(builder: (context) => Riderprofile()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Welcome()),
              );
            },
          ),
        ],
      ),
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
