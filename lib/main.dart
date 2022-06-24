import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(const MapApp());

class MapApp extends StatefulWidget {
  const MapApp({Key? key}) : super(key: key);

  @override
  MapAppState createState() => MapAppState();
}

class MapAppState extends State<MapApp> {
  late GoogleMapController _controller;

  final LatLng _center = const LatLng(41.881832, -87.623177);

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    final foo = await DefaultAssetBundle.of(context).loadString('assets/mapStyles/night.json');
    _controller.setMapStyle(foo);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GoogleMap(
          buildingsEnabled: false,
          compassEnabled: false,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          scrollGesturesEnabled: false,
          tiltGesturesEnabled: false,
          zoomControlsEnabled: false,
          zoomGesturesEnabled: false,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 14.5,
          ),
          onMapCreated: _onMapCreated,
        ),
      ),
    );
  }
}
