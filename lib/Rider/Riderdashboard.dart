import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mr_taxi/Rider/Vehicaldata.dart';
import 'package:uuid/uuid.dart';


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
  @override
  void initState() {
    super.initState();
    fetchOrders(); // Fetch orders when the widget is initialized
  }



  // Sample data for demonstration
  int orderCount = 5;
  double currentAmount = 150.0;
  List<Map<String, dynamic>> orders = [];


  // Function to fetch data from Firestore
  Future<void> fetchOrders() async {

    final QuerySnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('orders').get();

    final List<Map<String, dynamic>> fetchedOrders = [];

    snapshot.docs.forEach((doc) {
      fetchedOrders.add(doc.data());
    });

    setState(() {
      orders = fetchedOrders;
    });
  }





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
                  final uid = orders[index]['uid'];
                  final status = orders[index]['Status'];

                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.black,
                      ),
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('user')
                            .where('uid', isEqualTo: uid)
                            .snapshots(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.connectionState == ConnectionState.waiting) {
                            return ListTile(
                              title: Text('Loading...'),
                            );
                          }

                          if (!userSnapshot.hasData || userSnapshot.data == null) {
                            return ListTile(
                              title: Text('User data not available'),
                            );
                          }

                          final userDocs = userSnapshot.data!.docs;

                          if (userDocs.isEmpty) {
                            return ListTile(
                              title: Text('User not found'),
                            );
                          }

                          final userData = userDocs[0].data() as Map<String, dynamic>;
                          final username = userData['name'];
                          final usermobile = userData['mobile'];

                          return ListTile(
                            title: Text('Customer name: $username',style: TextStyle(color: Colors.white),), // Display the username
                            subtitle: Text('Status: $status',style: TextStyle(color: Colors.white),),
                            trailing: ElevatedButton(
                              onPressed: () {
                                _showOrderDetailsModal(context, orders[index], (newStatus) {
                                  // Update the status to "ok" here using the newStatus variable
                                  setState(() {
                                    orders[index]['Status'] = newStatus;
                                    print("++++++++++++++++++++Status updated+++++++++++++++++++++++++++++++++++++");
                                  });
                                });
                              },
                              child: Text(
                                'View Details',
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(254, 206, 12, 1.0),
                              ),
                            ),
                          );
                        },
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

  void _showOrderDetailsModal(BuildContext context, Map<String, dynamic> order, Function(String) updateStatus) {
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
                Text('Distance: ${order['Distance']}'),
                Text('Status: ${order['Status']}'),
                Text('Customer Location: ${order['currentLocation']}'),
                Text('Customer Drop Location: ${order['searchLocation']}'),
                Text('Customer Contact number: ${order['customermobile']}'),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle the "Cancel" button action
                          Navigator.pop(context); // Close the modal
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
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Handle the "Accept" button action
                          updateStatus("ok"); // Update the status to "ok"

                          // Get the user's current location
                          final position = await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.best,
                          );

                          // Update Firestore using 'uid' as the identifier
                          FirebaseFirestore.instance
                              .collection('orders')
                              .where('uid', isEqualTo: order['uid'])
                              .get()
                              .then((QuerySnapshot querySnapshot) {
                            querySnapshot.docs.forEach((doc) {
                              // Update the status in Firestore
                              doc.reference.update({'Status': 'ok'}).then((_) {
                                print('Firestore update successful');
                              }).catchError((error) {
                                print('Error updating Firestore: $error');
                              });
                            });


                           // Update live location in Firestore
                           //  FirebaseFirestore.instance
                           //      .collection('live_locations')
                           //      .doc(order['uid']) // Use 'uid' as the identifier
                           //      .set({
                           //    'latitude': position.latitude,
                           //    'longitude': position.longitude,
                           //    'timestamp': FieldValue.serverTimestamp(),
                           //  })
                           //      .then((_) {
                              updateLocation(order);
                              startLocationUpdate(order);
                            //   print('Live location update successful');
                            // })
                            //     .catchError((error) {
                            //   print('Error updating live location: $error');
                            // });
                          })
                              .catchError((error) {
                            print('Error querying Firestore: $error');
                          });

                          Navigator.pop(context); // Close the modal
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
                  height: 200,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(6.9601, 79.9580),
                      zoom: 10.0,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId('customer_location'),
                        position: LatLng(6.9601, 79.9580),
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




//location update

// Create a timer to periodically update the location
Timer? locationUpdateTimer;

void startLocationUpdate(Map<String, dynamic> order) async {
  // Start a timer that fetches and updates the location every X seconds
  const Duration updateInterval = Duration(seconds: 5); // Update every 30 seconds, you can adjust this value
  locationUpdateTimer = Timer.periodic(updateInterval, (_) {
  updateLocation(order);
  });
}

void stopLocationUpdate() {
  // Cancel the location update timer when it's no longer needed
  locationUpdateTimer?.cancel();
}

void updateLocation(Map<String, dynamic> order) async {
  try {
    // Get the user's current location
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,

    );

    FirebaseAuth auth = FirebaseAuth.instance;
    // Update live location in Firestore along with order information
    FirebaseFirestore.instance
        .collection('live_locations')
        .doc(order['uid']) // Use 'uid' as the identifier
        .set({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': FieldValue.serverTimestamp(),
      'uid':auth.currentUser!.uid // Include order information
    })
        .then((_) {
      print('Live location update successful');
    })
        .catchError((error) {
      print('Error updating live location: $error');
    });
  } catch (error) {
    print('Error getting location: $error');
  }
}







Future<String> getLocationName(double latitude, double longitude) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0];
      String locationName = "${placemark.locality}, ${placemark.administrativeArea}";
      return locationName;
    } else {
      return "Location not found";
    }
  } catch (e) {
    return "Error: $e";
  }
}

