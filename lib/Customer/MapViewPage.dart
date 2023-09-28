import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';

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
  GoogleMapController? _controller;
  List<Marker> _markers = [];
  Uint8List? customCarIcon;
  late LatLng location;

  @override
  void initState() {
    super.initState();
    _subscribeToLocationUpdates();
  }

  // Function to subscribe to real-time location updates from Firestore
  void _subscribeToLocationUpdates() {
    final locationCollection = FirebaseFirestore.instance.collection('live_locations');

    locationCollection.snapshots().listen((querySnapshot) {
      _markers.clear(); // Clear existing markers
      querySnapshot.docs.forEach((locationDoc) {
        final data = locationDoc.data() as Map<String, dynamic>;
        final latitude = data['latitude'] as double;
        final longitude = data['longitude'] as double;

        final marker = Marker(
          markerId: MarkerId(locationDoc.id),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: 'Location',
            snippet: 'Latitude: $latitude, Longitude: $longitude',
          ),
        );

        _markers.add(marker);
      });

      if (_controller != null) {
        setState(() {
          _markers = _markers;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Tracking'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(0.0, 0.0),
          zoom: 15.0,
        ),
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
          });
        },
        markers: Set<Marker>.from(_markers),
      ),
    );
  }
}
