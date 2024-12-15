import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';


void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {  
  @override  
  Widget build(BuildContext context) {  
    return MaterialApp(  
      title: 'OSM Flutter Application',  
      theme: ThemeData(  
        primarySwatch: Colors.blue,  
      ),  
      home: const OSMFlutterMap(),  
    );  
  }  
}  


class OSMFlutterMap extends StatefulWidget {
  const OSMFlutterMap({super.key});

  @override
  State<OSMFlutterMap> createState() => _OSMFlutterMapState();
}

class _OSMFlutterMapState extends State<OSMFlutterMap> {

  late MapController mapController;
  LatLng? currentPosition;

  @override
  void initState()
  {
    super.initState();
    mapController = MapController();

    
  }
 
  void moveToCurrentPosition() async {
    final stream = const LocationMarkerDataStreamFactory().fromGeolocatorPositionStream();

    final LocationMarkerPosition? position = await stream.first;

    if (position != null)
    {
      //final currentZoom = mapController.zoom;
      mapController.move(position.latLng, 15);
    }

  }

  //bool isLocationPressed = false;
  bool isTracking = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children: [
          FlutterMap(
            options: const MapOptions(
                initialCenter: LatLng(52.06516, 19.25248),
                initialZoom: 5,
                minZoom: 0,
                maxZoom: 19,
              ),
            mapController: mapController,
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'net.tlserver6y.flutter_map_location_marker.example',
                maxZoom: 19,
              ),
              CurrentLocationLayer(
                alignPositionOnUpdate: isTracking ? AlignOnUpdate.always : AlignOnUpdate.never,
                alignDirectionOnUpdate: AlignOnUpdate.never,
                style: LocationMarkerStyle(
                  marker: isTracking
                      ? const DefaultLocationMarker() // Marker włączony
                      : const SizedBox.shrink(),//isTracking ? const DefaultLocationMarker() : null,
                markerDirection: MarkerDirection.heading,
                //positionStream: positionStream,
                //headingStream: headingStream,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              
              
              backgroundColor: isTracking ? Colors.white : Colors.blue,
              onPressed: () {
                //backgroundColor: Colors.blue;
                
                print("thing happened");
                
                setState(() {
                  isTracking = !isTracking;

                });

                if(isTracking)
                {
                  moveToCurrentPosition();
                }
                //getCurrentLocation();
              },
              //backgroundColor: Colors.white,
              child: Icon(
                isTracking ? Icons.location_disabled : Icons.location_searching,
              ),
            )
            
          )

        ]
      ),
    );
  }
}


// location with geolocator:

/*
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {  
  @override  
  Widget build(BuildContext context) {  
    return MaterialApp(  
      title: 'OSM Flutter Application',  
      theme: ThemeData(  
        primarySwatch: Colors.blue,  
      ),  
      home: const OSMFlutterMap(),  
    );  
  }  
}  


class OSMFlutterMap extends StatefulWidget {
  const OSMFlutterMap({super.key});

  @override
  State<OSMFlutterMap> createState() => _OSMFlutterMapState();
}

class _OSMFlutterMapState extends State<OSMFlutterMap> {

  late MapController mapController;
  LatLng? currentPosition;

  @override
  void initState()
  {
    super.initState();
    mapController = MapController();
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied)
    {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    } 

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
      mapController.move(currentPosition!, 15.0);
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: const MapOptions(),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                print("thing happened");
                getCurrentLocation();
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.location_searching),
            )
            
          )

        ]
      ),
    );
  }
}
*/