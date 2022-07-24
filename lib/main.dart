import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dojos.dart' as babDojos;
import 'package:location/location.dart';

// Open the map showing the whole of the UK
const double cameraZoom = 6;
const LatLng centreLocation = LatLng(54.6248969, -2.0353024);

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    dojoLocations = await babDojos.getBABDojos();

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
    CameraPosition initialLocation =
        const CameraPosition(zoom: cameraZoom, target: centreLocation);

    return MaterialApp(
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.system,
      home: Scaffold(
        appBar: AppBar(title: const Text('Dojos')),
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
