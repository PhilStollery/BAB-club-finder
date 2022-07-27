import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../models/dojos.dart' as babDojos;

const double cameraZoom = 6;
const LatLng centreLocation = LatLng(54.6248969, -2.0353024);

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Map<String, Marker> _markers = {};

  Location location = Location();
  babDojos.Dojos dojoLocations = babDojos.Dojos([]);

  @override
  void initState() {
    // Request location access to show users location on the map
    super.initState();
    getLoc();
  }

  void getLoc() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    setState(() {
      _markers.clear();
      for (final dojo in dojoLocations.dojos) {
        final marker = Marker(
          markerId: MarkerId(dojo.clubname),
          position: LatLng(dojo.lat, dojo.lng),
          infoWindow: InfoWindow(
            title: dojo.clubname,
            snippet: dojo.association,
          ),
        );
        _markers[dojo.clubname] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Pass the dojos into this widget - will be
    dojoLocations =
        ModalRoute.of(context)?.settings.arguments as babDojos.Dojos;

    CameraPosition initialLocation =
        const CameraPosition(zoom: cameraZoom, target: centreLocation);

    return MaterialApp(
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Map'),
          centerTitle: true,
          elevation: 0,
        ),
        body: GoogleMap(
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          compassEnabled: true,
          onMapCreated: _onMapCreated,
          initialCameraPosition: initialLocation,
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}
