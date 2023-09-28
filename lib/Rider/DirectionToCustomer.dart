import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class RiderDashboardPage extends StatefulWidget {
  const RiderDashboardPage({Key? key}) : super(key: key);

  @override
  State<RiderDashboardPage> createState() => _RiderDashboardPageState();
}

class _RiderDashboardPageState extends State<RiderDashboardPage> {
  LatLng? currentLocation;
  LatLng destination = LatLng(7.4911, 80.3630); // Fixed destination (Kurunegala, Sri Lanka)

  GoogleMapController? _mapController;

  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    _drawPolygon();
  }

  Future<void> getCurrentLocation() async {
    // Replace this with your location retrieval code
    // Example using hardcoded coordinates:
    currentLocation = LatLng(7.8731, 80.7718);
    setState(() {});
  }

  Future<void> _drawPolygon() async {
    if (currentLocation != null) {
      polylines.clear();

      final String apiKey = 'AIzaSyAKmx5fk17F_7M4FofGxp2Oy8gyRvJ1zZ0'; // Replace with your Google Maps API key
      final String origin = '${currentLocation!.latitude},${currentLocation!.longitude}';
      final String destinationStr = '${destination.latitude},${destination.longitude}';
      final String apiUrl =
          'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destinationStr&key=$apiKey';

      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final List<LatLng> points = _decodePolyline(data['routes'][0]['overview_polyline']['points']);
          final Polyline polyline = Polyline(
            polylineId: PolylineId('route'),
            color: Colors.blue,
            width: 3,
            points: points,
          );
          polylines.add(polyline);
        } else {
          print('Error: Unable to fetch route data');
        }
      } else {
        print('Error: Unable to fetch route data');
      }

      setState(() {});
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    final List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      final LatLng position = LatLng(lat / 1e5, lng / 1e5);
      poly.add(position);
    }
    return poly;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rider Dashboard'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: GoogleMap(
              onMapCreated: (controller) {
                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: currentLocation ?? LatLng(7.8731, 80.7718), // Default location if current location is null
                zoom: 6.0,
              ),
              markers: {
                if (currentLocation != null)
                  Marker(
                    markerId: MarkerId('current'),
                    position: currentLocation!,
                    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                  ),
                Marker(
                  markerId: MarkerId('destination'),
                  position: destination,
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                ),
              },
              polylines: polylines,
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(10),
          //   child: ElevatedButton(
          //     onPressed: () {
          //       _drawPolygon();
          //     },
          //     child: Text('Show Route'),
          //   ),
          // ),
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
