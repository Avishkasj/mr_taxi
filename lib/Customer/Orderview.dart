import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mr_taxi/Customer/MapViewPage.dart';

import 'Customermap.dart';

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
  double totalAmount = 0.0;
  String formattedTotalAmount="";// Declare a variable to store the total amount

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
    formattedTotalAmount = totalAmount.toStringAsFixed(0);

  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
   String status =  getStatusForCurrentUser(auth.currentUser!.uid).toString();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Order'),
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

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Image(
                  image: AssetImage(
                    'assets/tx1.jpg',
                  ),

                  width: 550,
                ),
              ),
            ),


            // Container(
            // color: Colors.black,
            //   child: Padding(
            //     padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            //     child: Container(
            //       height: 160, // Adjust the height as needed
            //       child: GoogleMap(
            //         initialCameraPosition: CameraPosition(
            //           target: LatLng(
            //             widget.currentLocation?.latitude ?? 0.0, // Use a default value if null
            //             widget.currentLocation?.longitude ?? 0.0,
            //           ), // Initial map center coordinates
            //           zoom: 12.0, // Initial zoom level
            //         ),
            //         markers: Set<Marker>.from([
            //           Marker(
            //             markerId: MarkerId("marker_1"),
            //             position: LatLng(
            //               widget.searchLocation?.latitude ?? 0.0, // Use a default value if null
            //               widget.searchLocation?.longitude ?? 0.0,
            //             ), // Marker coordinates
            //             infoWindow: InfoWindow(
            //               title: "Destination",
            //               snippet: "Your destination",
            //             ),
            //           ),
            //         ]),
            //         onMapCreated: (GoogleMapController controller) {
            //           // Controller to interact with the map
            //           // You can store it in a variable to use it later.
            //         },
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(height: 10,),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: OutlinedButton(
                  child: Text(
                    "Where My Taxi ?",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      width: 2.0, // set the border weight to 2.0
                      color: Colors.white,
                    ),
                    fixedSize: Size(350, 50),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapViewPage()),
                    );
                  },
                ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Container(
                height: 50,
                width: double.infinity, // Make the button full-width
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return PaymentOptionDialog();
                      },
                    );



                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.yellow, // Set the background color to yellow
                  ),
                  child: Text(
                    'Order Complete',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),



            // Padding(
            //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            //   child: Container(
            //     color: Color.fromRGBO(254, 206, 12, 1.0),
            //     child: Row(
            //       children: <Widget>[
            //         Expanded(
            //           child: Row(
            //             children: [
            //               Icon(Icons.add_task_rounded,size: 60,),
            //               Container(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(8.0),
            //                   child: Center(
            //                     child: Padding(
            //                       padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            //                       child: Column(
            //                        crossAxisAlignment: CrossAxisAlignment.start,
            //                         children: [
            //                           Text(
            //                             'Please Wait d. . .',
            //                             style: TextStyle(fontSize: 24, ),
            //                             // Add your desired style
            //                           ),
            //                           Text(
            //                             'Waiting For Driver Accept',
            //                             style: TextStyle(fontSize: 18, ),
            //                             // Add your desired style
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),


            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          height: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 40,
                                color: Colors.blue,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Per KM: RS ${widget.selectedCardData['chargesPerKm']}',
                                style: TextStyle(fontSize: 14, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          height: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.attach_money,
                                size: 40,
                                color: Colors.green,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Total RS:  $formattedTotalAmount',
                                style: TextStyle(fontSize: 14, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),





            Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   'status $status ',
                    //   style: TextStyle(fontSize: 22,color: Colors.white), // Add your desired style
                    // ),
                    Text(
                      'Vehicle Model : ${widget.selectedCardData['vehicleModel']}',
                      style: TextStyle(fontSize: 22,color: Colors.white), // Add your desired style
                    ),
                    Text(
                      'Brand ${widget.selectedCardData['vehicleBrand']}',
                      style: TextStyle(fontSize: 22,color: Colors.white), // Add your desired style
                    ),
                    Text(
                      'Distance ${widget.formattedDistance}',
                      style: TextStyle(fontSize: 22,color: Colors.white), // Add your desired style
                    ),

                    // Text(
                    //   'Driver ${widget.selectedCardData['userId']}',
                    //   style: TextStyle(fontSize: 22,color: Colors.white), // Add your desired style
                    // ),
                    // Text(
                    //   'Current Location ${widget.currentLocation}',
                    //   style: TextStyle(fontSize: 22,color: Colors.white), // Add your desired style
                    // ),
                    // Text(
                    //   'Search Location ${widget.searchLocation}',
                    //   style: TextStyle(fontSize: 22,color: Colors.white),// Add your desired style
                    // ),


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

class PaymentOptionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('Pay with Card'),
            onTap: () {
              // Handle card payment logic here
              Navigator.pop(context); // Close the dialog
            },
          ),
          ListTile(
            leading: Icon(Icons.money),
            title: Text('Pay with Cash'),
            onTap: () {
              // Close the payment option dialog
              Navigator.pop(context);
              // Show the order completion and review dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return OrderCompletionDialog();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}



//order complete card
class OrderCompletionDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: 68,
            color: Colors.green,
          ),
          Text('Order Completed'),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: 'Leave a Review',
              hintText: 'Tell us about your experience...',
            ),
            maxLines: 3,
          ),
          ElevatedButton(
            onPressed: () {
              // Handle the review submission logic here
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Customermap()),
              ); // Close the dialog
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black87), // Change the color to your desired color
            ),
            child: Text('Submit Review'),
          )

        ],
      ),
    );
  }
}

// Rest of your code...

Future<String> getStatusForCurrentUser(String currentUserId) async {
  try {
    // Reference to the Firestore collection where your data is stored
    CollectionReference ordersCollection = FirebaseFirestore.instance.collection('orders');

    // Query the document based on the user ID
    QuerySnapshot querySnapshot = await ordersCollection.where('uid', isEqualTo: currentUserId).get();

    // Check if a document matching the user ID exists
    if (querySnapshot.docs.isNotEmpty) {
      // Retrieve the first document (assuming there's only one) and get the "Status" field
      String status = querySnapshot.docs.first['Status'];

      return status;
    } else {
      // Handle the case where no matching document was found
      return "User not found";
    }
  } catch (e) {
    // Handle any errors that may occur during the Firestore query
    print("Error: $e");
    return "Error";
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



        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Logout'),
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
