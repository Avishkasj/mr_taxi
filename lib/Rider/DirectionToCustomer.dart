import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:mr_taxi/Customer/Orderview.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mr_taxi/Rider/Riderdashboard.dart';


import 'package:mr_taxi/Welcome.dart';




class RiderDashboardPage extends StatefulWidget {
  const RiderDashboardPage({Key? key}) : super(key: key);

  @override
  State<RiderDashboardPage> createState() => _RiderDashboardPageState();
}

class _RiderDashboardPageState extends State<RiderDashboardPage> {
  var selectedCardData;
  var toatalamount;
  LatLng? currentLocation;
  LatLng? searchLocation;
  List<LatLng> polygonPoints = [];
  TextEditingController searchLocationController = TextEditingController();
  GoogleMapController? mapController;
  Set<Polyline> polylines = {};
  late String formattedDistance="0";
  FirebaseAuth auth = FirebaseAuth.instance;



  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }



  Future<void> getCurrentLocation() async {
    loc.Location location = loc.Location();
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }

    loc.LocationData locationData = await location.getLocation();
    currentLocation = LatLng(locationData.latitude!, locationData.longitude!);

    setState(() {});

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: currentLocation!, zoom: 15),
      ),
    );
  }

  Future<void> searchLocation2() async {
    List<Location> locations = await locationFromAddress(searchLocationController.text);

    if (locations.isNotEmpty) {
      Location location = locations.first;
      searchLocation = LatLng(location.latitude, location.longitude);
      //searchLocation = LatLng(6.9271, 79.8612);
      polygonPoints.add(searchLocation!);

      if (currentLocation != null && searchLocation != null) {
        PolylinePoints polylinePoints = PolylinePoints();
        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          'AIzaSyAKmx5fk17F_7M4FofGxp2Oy8gyRvJ1zZ0', // Replace with your actual Google Maps API Key
          PointLatLng(currentLocation!.latitude, currentLocation!.longitude),
          PointLatLng(searchLocation!.latitude, searchLocation!.longitude),
          travelMode: TravelMode.driving,
        );

        if (result.points.isNotEmpty) {
          List<LatLng> routePoints = result.points
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();

          double distance = calculateDistance(routePoints);
          print("================================");
          print(distance);
          formattedDistance = distance.toStringAsFixed(1);
          print("================================");
          print(formattedDistance);

          polylines.add(Polyline(
            polylineId: PolylineId('route'),
            color: Colors.blue,
            width: 3,
            points: routePoints,
          ));
        }
      }


      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(searchLocation!, 15),
      );

      setState(() {});
    }
  }

  // ... (getCurrentLocation, searchLocation2, and other methods)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend body behind the app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Set the background color to transparent
        elevation: 0, // Remove the app bar's shadow
      ),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(7.8731, 80.7718), // Sri Lanka's coordinates
                zoom: 6,
              ),
              markers: Set<Marker>.of([
                if (currentLocation != null)
                  Marker(markerId: MarkerId('current'), position: currentLocation!),
                if (searchLocation != null)
                  Marker(markerId: MarkerId('search'), position: searchLocation!),
              ]),
              polylines: Set<Polyline>.of(polylines),
            ),
          ),



          // Padding(
          //   padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          //   child: Expanded(
          //     flex: 1,
          //     child: Row(
          //       children: [
          //         Expanded(
          //           child: Padding(
          //             padding: EdgeInsets.all(8.0),
          //             child: TextField(
          //               controller: searchLocationController,
          //               decoration: InputDecoration(
          //                 hintText: 'Search Destination',
          //                 prefixIcon: Icon(Icons.search),
          //               ),
          //             ),
          //           ),
          //         ),
          //         ElevatedButton(
          //           onPressed: () {
          //             if (searchLocationController.text.isNotEmpty) {
          //               searchLocation2();
          //             }
          //           },
          //           style: ElevatedButton.styleFrom(
          //             primary: Colors.black, // Set the background color to yellow
          //           ),
          //           child: Text('Search'),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),




          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Container(
              height: 50,
              width: double.infinity, // Make the button full-width
              child: ElevatedButton(
                onPressed: () {


                  print("object");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Riderdashboard()),
                  );
                },
                // style: ElevatedButton.styleFrom(
                //   primary: Colors.yellow, // Set the background color to yellow
                // ),
                child: Text(
                  'Go To Dashboard',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }


  //Drower
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 1.0),
            ),
            child: Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ), ListTile(
            title: Text('Account Details'),
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Welcome()),
              );
              // Handle the option 1 action
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Welcome()),
              );
              // Handle the option 1 action
            },
          ),

          // Add more list tiles for additional options
        ],
      ),
    );
  }

}

void main() {
  runApp(MaterialApp(
    home: RiderDashboardPage(),
  ));
}



//vehicval cards

class MyCard extends StatefulWidget {
  final void Function(Map<String, dynamic> selectedCardData) onCardSelected;

  MyCard({required this.onCardSelected});

  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('vehicle').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator(); // Loading indicator while data is being fetched
          }

          // Ensure that snapshot.data is not null
          if (snapshot.data == null) {
            return Text('No data available'); // Handle the case when there's no data
          }

          // Retrieve documents from Firestore
          List<DocumentSnapshot> documents = snapshot.data!.docs;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: documents.length, // Adjust the number of cards based on Firestore data
            itemBuilder: (context, index) {
              // Access data from Firestore document
              Map<String, dynamic> vehicleData =
              documents[index].data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () {


                  // Pass the selected card data to the callback function
                  widget.onCardSelected(vehicleData);
                },
                child: Container(
                  width: 130,
                  height: 160,
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${vehicleData['vehicleModel']}'),
                      // Replace 'image_url' with the field containing the image URL in your Firestore document
                      Container(
                        height: 80,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0),
                          image: DecorationImage(
                            image: AssetImage('assets/car2.png'), // Replace with actual image path
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      Text('Per KM: RS ${vehicleData['chargesPerKm']}'),
                      SizedBox(height: 5),
                      GestureDetector(
                        child: GestureDetector(
                          onTap: () {

                            // Pass the selected card data to the callback function
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  // Customize the modal content here
                                  child: Column(
                                    children: [
                                      Text('Additional Details'),
                                      Text('Model: ${vehicleData['vehicleModel']}'),
                                      Text('Per KM: RS ${vehicleData['chargesPerKm']}'),
                                      Text('Brand ${vehicleData['vehicleBrand']}'),
                                      Text('Owner ${vehicleData['userId']}'),
                                      Text('About ${vehicleData['aboutVehicle']}'),

                                      // Add more details as needed
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            color: Colors.yellow,
                            width: 120,
                            height: 30,
                            child: Center(
                              child: Text("More"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}



double calculateDistance(List<LatLng> routePoints) {
  double totalDistance = 0.0;

  for (int i = 0; i < routePoints.length - 1; i++) {
    double lat1 = routePoints[i].latitude;
    double lon1 = routePoints[i].longitude;
    double lat2 = routePoints[i + 1].latitude;
    double lon2 = routePoints[i + 1].longitude;

    double distance = _calculateHaversineDistance(lat1, lon1, lat2, lon2);
    totalDistance += distance;
  }

  return totalDistance;
}

double _calculateHaversineDistance(
    double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371.0; // in kilometers
  double dLat = _toRadians(lat2 - lat1);
  double dLon = _toRadians(lon2 - lon1);

  double a = pow(sin(dLat / 2), 2) +
      cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * pow(sin(dLon / 2), 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double distance = earthRadius * c;

  return distance;
}

double _toRadians(double degrees) {
  return degrees * pi / 180.0;
}







