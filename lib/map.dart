import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWrap extends StatefulWidget {
  const MapWrap({super.key});

  @override
  State<StatefulWidget> createState() => MapWrapState();
}

class MapWrapState extends State<MapWrap> {
  late GoogleMapController _mapController;

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;
    final foo = await DefaultAssetBundle.of(context)
        .loadString('assets/mapStyles/dark.json');
    _mapController.setMapStyle(foo);
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      buildingsEnabled: false,
      compassEnabled: false,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      scrollGesturesEnabled: false,
      tiltGesturesEnabled: false,
      zoomControlsEnabled: false,
      zoomGesturesEnabled: false,
      initialCameraPosition: const CameraPosition(
        target: LatLng(41.881832, -87.623177),
        zoom: 14.5,
      ),
      onMapCreated: _onMapCreated,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _mapController.dispose();
  }
}
