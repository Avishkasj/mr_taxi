import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Tracking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapViewPage(),
    );
  }
}

class MapViewPage extends StatefulWidget {
  @override
  _MapViewPageState createState() => _MapViewPageState();
}

class _MapViewPageState extends State<MapViewPage> {
  GoogleMapController? _controller; // Initialize as nullable
  LatLng _currentLocation = LatLng(0.0, 0.0); // Initial placeholder coordinates

  // Function to get and update the user's current location
  void _updateUserLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    if (_controller != null) {
      _controller!.animateCamera(CameraUpdate.newLatLng(_currentLocation));
    }

    // Update Firestore with the location data
    _updateLocationInFirestore(_currentLocation);
  }

  // Function to update the user's location in Firestore
  void _updateLocationInFirestore(LatLng location) async {
    try {
      // Replace 'user123' with the actual user's unique identifier
      final userId = 'user123';

      // Create a Firestore reference to the user's location document
      final userLocationRef = FirebaseFirestore.instance.collection('live_locations').doc(userId);

      // Update the Firestore document with the new location
      await userLocationRef.set({
        'latitude': location.latitude,
        'longitude': location.longitude,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('Location updated in Firestore: Latitude ${location.latitude}, Longitude ${location.longitude}');
    } catch (e) {
      print('Error updating location in Firestore: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize the _controller in the initState method
    _controller = null; // Initialize it as null
    // Get and update the user's current location when the page is initialized
    _updateUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Tracking'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentLocation, // Initial map center
          zoom: 15.0, // Initial zoom level (adjust as needed)
        ),
        onMapCreated: (controller) {
          _controller = controller;
        },
        markers: {
          Marker(
            markerId: MarkerId('user_location'),
            position: _currentLocation,
          ),
        },
      ),
    );
  }
}
