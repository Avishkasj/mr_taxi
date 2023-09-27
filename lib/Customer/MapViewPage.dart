import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

    loadCustomCarIcon().then((iconData) {
      setState(() {
        customCarIcon = iconData;
      });
    });
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
        location = LatLng(latitude, longitude);



        BitmapDescriptor customIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);

        final marker = Marker(
          markerId: MarkerId(locationDoc.id),
          position: LatLng(latitude, longitude),
          icon: BitmapDescriptor.fromBytes(customCarIcon ?? Uint8List(0)),
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
        backgroundColor: Colors.black87,
        title: Text('Taxi Live Location'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: location, // Coordinates for Sri Lanka (Centered)
          zoom: 15.0, // Zoom level (adjust as needed)
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

  Future<Uint8List> loadCustomCarIcon() async {
    // Load your car icon image as a Uint8List
    // Replace 'car_icon.png' with the actual path to your car icon image
    final ByteData data = await rootBundle.load('assets/cr3.png');
    return data.buffer.asUint8List();
  }
}
