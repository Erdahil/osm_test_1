import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

//import 'package:geolocator/geolocator.dart';
//import 'package:latlong2/latlong.dart';

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

  final controller = MapController.withUserPosition(
    trackUserLocation: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: false,
    ),
    /*customTile: CustomTile(
        sourceName: "opentopomap",
        tileExtension: ".png",
        minZoomLevel: 2,
        maxZoomLevel: 19,
        urlsServers: [
         TileURLs(
            //"https://tile.opentopomap.org/{z}/{x}/{y}"
            url: "https://tile.opentopomap.org/",
            subdomains: [],
          )
        ],
        tileSize: 256,
      ),*/
  );
  //MapController mapController;
  //LatLng? currentPosition;

  @override
  void initState()
  {
    super.initState();
    //mapController = MapController();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children: [
          OSMFlutter( 
            controller:controller,
            
            osmOption: OSMOption(
              
              userTrackingOption: const UserTrackingOption(
                enableTracking: true,
                unFollowUser: false,
              ),
              zoomOption: const ZoomOption(
                initZoom: 8,
                minZoomLevel: 3,
                maxZoomLevel: 19,
                stepZoom: 1.0,
              ),
              
              userLocationMarker: UserLocationMaker(
                personMarker: const MarkerIcon(
                  icon: Icon(
                    Icons.location_history_rounded,
                    color: Colors.red,
                    size: 48,
                    ),
                ),
                directionArrowMarker: const MarkerIcon(
                    icon: Icon(
                        Icons.double_arrow,
                        size: 48,
                    ),
                ),
              ),
              roadConfiguration: const RoadOption(
                roadColor: Colors.yellowAccent,
              ),
              
            ),
            
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                print("thing happened");
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