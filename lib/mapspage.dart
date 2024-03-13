import 'package:flutter/material.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map/global.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({Key? key}) : super(key: key);

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  Completer<GoogleMapController> mapController = Completer();

  late CameraPosition position;

  void onMapCreated(GoogleMapController controller) {
    if (!mapController.isCompleted) {
      mapController.complete(controller);
    }
  }

  @override
  void initState() {
    super.initState();
    position = CameraPosition(
      target: LatLng(Global.lat, Global.long),
    );
  }

  @override
  void dispose() {
    mapController = Completer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          centerTitle: true,
          titleSpacing: 20,
          elevation: 0,
          title: const Text("Google Map"),
          backgroundColor: Colors.black,
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            cameraTargetBounds: CameraTargetBounds(
              LatLngBounds(
                southwest: LatLng(Global.lat, Global.long),
                northeast: LatLng(Global.lat, Global.long),
              ),
            ),
            onMapCreated: (GoogleMapController controller) {},
            initialCameraPosition: position,
            mapType: MapType.satellite,
            mapToolbarEnabled: true,
            markers: {
              Marker(
                markerId: const MarkerId("Current Location"),
                position: LatLng(Global.lat, Global.long),
              ),
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          setState(() {});
          position = CameraPosition(
            target: LatLng(Global.lat, Global.long),
            zoom: 16,
          );
          Geolocator.getPositionStream().listen((Position position) async {
            Global.lat = position.latitude;
            Global.long = position.longitude;
          });
          final GoogleMapController controller = await mapController.future;
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                zoom: 80,
                target: LatLng(Global.lat, Global.long),
              ),
            ),
          );
        },
        child: const Icon(
          Icons.my_location_outlined,
          size: 36,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
