import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    Key key,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  List markerList = [
    {"name": 'A', "lat": 12.962938, "lng": 77.632852},
    {"name": 'B', "lat": 12.968165, "lng": 77.631801},
    {"name": 'C', "lat": 12.964897, "lng": 77.633897},
    {"name": 'D', "lat": 12.966897, "lng": 77.633897},
  ];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    setState(() {
      isLoading = true;
    });
    setState(() {
      isLoading = false;
    });
  }

  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    setState(() {
      _markers.clear();
      for (final mrk in markerList) {
        final marker = Marker(
          markerId: MarkerId(mrk["name"]),
          position: LatLng(mrk["lat"], mrk["lng"]),
          infoWindow: InfoWindow(
            title: mrk["name"],
          ),
        );
        _markers[mrk["name"]] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Locations'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(12.9610, 77.6387),
            zoom: 15,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}
