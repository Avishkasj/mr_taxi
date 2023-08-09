import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class Customermap extends StatefulWidget {
  const Customermap({Key? key}) : super(key: key);

  @override
  State<Customermap> createState() => _CustomermapState();
}

class _CustomermapState extends State<Customermap> {
  LatLng? currentLocation;
  LatLng? searchLocation;
  List<LatLng> polygonPoints = [];
  TextEditingController searchLocationController = TextEditingController();
  GoogleMapController? mapController;
  List<Polyline> polylines = [];

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
      polygonPoints.add(searchLocation!);

      if (currentLocation != null && searchLocation != null) {
        polygonPoints.add(currentLocation!);
        polylines.add(Polyline(
          polylineId: PolylineId('route'),
          color: Colors.blue,
          width: 3,
          points: polygonPoints,
        ));
      }

      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(searchLocation!, 15),
      );

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: getCurrentLocation,
                      child: Text('Get Current Location'),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchLocationController,
                      decoration: InputDecoration(hintText: 'Search location'),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (searchLocationController.text.isNotEmpty) {
                      searchLocation2();
                    }
                  },
                  child: Text('Search'),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              currentLocation = null;
              searchLocation = null;
              polygonPoints.clear();
              polylines.clear();
              setState(() {});
            },
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Customermap(),
  ));
}
