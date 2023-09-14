import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Orderview extends StatefulWidget {
  final Map<String, dynamic> selectedCardData;
  final LatLng? currentLocation; // Nullable LatLng for current location
  final LatLng? searchLocation;  // Nullable LatLng for search location
  final String formattedDistance;

  Orderview({
    required this.selectedCardData,
    required this.currentLocation,
    required this.searchLocation,
    required this.formattedDistance,
  });

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
    String chargesPerKm = widget.selectedCardData['chargesPerKm'];
    double? myDouble = double.tryParse(chargesPerKm);
    double distance = double.tryParse(widget.formattedDistance) ?? 0.0;
    totalAmount = (myDouble! * distance)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Waiting . . . '),
      ),
      drawer: _buildSidebarDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   color: Colors.black,
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: Text(
            //       'Destination',
            //       style: TextStyle(fontSize: 18,color: Colors.white),
            //       // Add your desired style
            //     ),
            //   ),
            // ),


            Container(
            color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Container(
                  height: 160, // Adjust the height as needed
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        widget.currentLocation?.latitude ?? 0.0, // Use a default value if null
                        widget.currentLocation?.longitude ?? 0.0,
                      ), // Initial map center coordinates
                      zoom: 12.0, // Initial zoom level
                    ),
                    markers: Set<Marker>.from([
                      Marker(
                        markerId: MarkerId("marker_1"),
                        position: LatLng(
                          widget.searchLocation?.latitude ?? 0.0, // Use a default value if null
                          widget.searchLocation?.longitude ?? 0.0,
                        ), // Marker coordinates
                        infoWindow: InfoWindow(
                          title: "Destination",
                          snippet: "Your destination",
                        ),
                      ),
                    ]),
                    onMapCreated: (GoogleMapController controller) {
                      // Controller to interact with the map
                      // You can store it in a variable to use it later.
                    },
                  ),
                ),
              ),
            ),



            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Container(
                color: Color.fromRGBO(254, 206, 12, 1.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.add_task_rounded,size: 60,),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Please Wait d. . .',
                                        style: TextStyle(fontSize: 24, ),
                                        // Add your desired style
                                      ),
                                      Text(
                                        'Waiting For Driver Accept',
                                        style: TextStyle(fontSize: 18, ),
                                        // Add your desired style
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),


            Container(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      height: 100,
                      width: 140,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Per KM: RS ${widget.selectedCardData['chargesPerKm']}',
                              style: TextStyle(fontSize: 22,color: Colors.black), // Add your desired style
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 20, 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      height: 100,
                      width: 160,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Toatal RS:  $totalAmount',
                              style: TextStyle(fontSize: 22,color: Colors.black), // Add your desired style
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),


                ],
              ),

            ),


            Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vehicle Model : ${widget.selectedCardData['vehicleModel']}',
                      style: TextStyle(fontSize: 22,color: Colors.white), // Add your desired style
                    ),
                    Text(
                      'Brand ${widget.selectedCardData['vehicleBrand']}',
                      style: TextStyle(fontSize: 22,color: Colors.white), // Add your desired style
                    ),

                    Text(
                      'Driver ${widget.selectedCardData['userId']}',
                      style: TextStyle(fontSize: 22,color: Colors.white), // Add your desired style
                    ),
                    Text(
                      'Current Location ${widget.currentLocation}',
                      style: TextStyle(fontSize: 22,color: Colors.white), // Add your desired style
                    ),
                    Text(
                      'Search Location ${widget.searchLocation}',
                      style: TextStyle(fontSize: 22,color: Colors.white),// Add your desired style
                    ),
                    Text(
                      'Distance ${widget.formattedDistance}',
                      style: TextStyle(fontSize: 22,color: Colors.white), // Add your desired style
                    ),

                  ],
                ),
              ),
            ),


          ],

        ),
      ),
    );
  }
}

// Rest of your code...




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
