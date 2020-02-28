import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapPage extends StatefulWidget {
  final String latitude;
  final String longitude;

  GoogleMapPage({Key key, this.latitude, this.longitude}) : super(key: key);

//  double latitude = Double.parseDouble(latlong[0]);
//  double longitude = Double.parseDouble(latlong[1]);
  @override
  _GoogleMapPageState createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
List<Marker> allMarkkers = [];



void initState(){
  super.initState();
  allMarkkers.add(Marker(

    markerId: MarkerId('Mymark'),
    draggable: false,
    position: LatLng(double.parse(widget.latitude),double.parse(widget.longitude)),
  ));
}
  Completer<GoogleMapController> _controller = Completer();

  Widget build(BuildContext context) {
    return Scaffold(

        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(double.parse(widget.latitude),double.parse(widget.longitude)),
            zoom: 16,

          ),
markers: Set.from(allMarkkers),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        )
    );
  }
}

