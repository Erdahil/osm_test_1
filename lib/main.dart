import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
//import 'dart:math';


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
  double currentZoom = 15.0;
  List<Marker> markers = [];
  double distanceToWaypoint = 0;
  @override
  void initState()
  {
    super.initState();
    mapController = MapController();

    _startTracking();
  }

  void _startTracking() {
    final stream = const LocationMarkerDataStreamFactory().fromGeolocatorPositionStream();

    stream.listen((LocationMarkerPosition? position) {
      if (position != null) {
        setState(() {
          currentPosition = position.latLng;
          
        });
      }
    });
  }
 
  void moveToCurrentPosition() async {
    final stream = const LocationMarkerDataStreamFactory().fromGeolocatorPositionStream();

    final LocationMarkerPosition? position = await stream.first;

    if (position != null)
    {
      mapController.move(position.latLng, currentZoom);
    }

  }

  void addWaypoint(LatLng point)
  {
    setState(() {
      markers.clear();
      markers.add(
        Marker(
          point: point,
          width: 37,
          height: 37,
          rotate: true,
          //anchorPos: AnchorPos.align(AnchorAlign.center),
          child: const Icon(
            Icons.location_pin,
            color: Colors.red,
            size:40,
          ),
          alignment: Alignment.topCenter,
          //anchorPos: const Offset(0.5, 0.5)
          
        ),
      );
    });
  }

  double calculateDistance(LatLng point1, LatLng point2)
  {
    final Distance distance = const Distance();
    return distance.as(LengthUnit.Meter, point1, point2);
  }
/*
  void updatePosition(LatLng position)
  {
    setState(() {
      currentPosition = position;
    });
  }*/


  //bool isLocationPressed = false;
  bool isTracking = false;
  bool headingReset = false;

  @override
  Widget build(BuildContext context) {

    final double distanceToWaypoint = (currentPosition != null && markers.isNotEmpty)
      ? calculateDistance(currentPosition!, markers.last.point)
      : 0.0;

    return Scaffold(
      body:Stack(
        children: [
          FlutterMap(
            options: MapOptions(
                initialCenter: const LatLng(52.06516, 19.25248),
                initialZoom: 5,
                minZoom: 0,
                maxZoom: 19,
                onLongPress: (tapPosition, point) {
                  addWaypoint(point);
                },
                onPositionChanged: ( position, hasGesture) {
                  setState(() {
                    currentZoom = position.zoom;
                  });
                },
              ),
            mapController: mapController,
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'net.tlserver6y.flutter_map_location_marker.example',
                maxZoom: 19,
              ),
              if (isTracking)
                CurrentLocationLayer(
                  alignPositionOnUpdate: AlignOnUpdate.once,
                  alignDirectionOnUpdate: AlignOnUpdate.never,
                  style: const LocationMarkerStyle(
                    marker: DefaultLocationMarker(),
                    markerDirection: MarkerDirection.heading,
                  ),
                  /*positionStream: (PositionStream?) {
                    PositionStream?.listen((position) {
                      final LatLng newPosition = LatLng(position.latitude, position.longitude);
                      updatePosition(newPosition);
                      //mapController.move(newPosition, currentZoom); // Możesz również przesunąć mapę, aby pokazać nową lokalizację
                    });
                  },*/
                ),
              MarkerLayer(markers: markers),
              /*CurrentLocationLayer(
                alignPositionOnUpdate: isTracking ? AlignOnUpdate.always : AlignOnUpdate.never,
                alignDirectionOnUpdate: AlignOnUpdate.never,
                style: LocationMarkerStyle(
                  marker: isTracking
                      ? const DefaultLocationMarker() // Marker włączony
                      : const SizedBox.shrink(),//isTracking ? const DefaultLocationMarker() : null,
                markerDirection: isTracking
                      ? MarkerDirection.heading
                      : MarkerDirection.
                //positionStream: positionStream,
                //headingStream: headingStream,
                ),
              ),*/
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              
              
              backgroundColor: isTracking ? Colors.blue : Colors.white,
              onPressed: () {
                //backgroundColor: Colors.blue;
                
                print("thing happened");
                
                setState(() {
                  isTracking = !isTracking;

                });

              },
              child: Icon(
                isTracking ? Icons.location_searching : Icons.location_disabled,
              ),
            )
            
          ),
          Positioned(
            bottom: 100,
            right: 20,
            child: FloatingActionButton(
              
              backgroundColor: isTracking ? Colors.blue : Colors.white,
              onPressed: () {
                print("another thing happened");
                
                if(isTracking)
                {
                  moveToCurrentPosition();
                }
              },
              child: Icon(
                isTracking ? Icons.location_on : Icons.location_off,
              ),
            )
            
          ),
          Positioned(
            bottom: 180,
            right: 20,
            child: FloatingActionButton(
              
              backgroundColor: isTracking ? Colors.blue : Colors.white,
              onPressed: () {
                markers.clear();
                mapController.rotate(0.0);
              },
              child: Transform.rotate(
                angle: 135 * pi/180,
                child: const Icon(Icons.explore),
              ),
            )
            
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: isTracking && markers.isNotEmpty == true ? 20 : -100,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]
                ),
                child: Text(
                  '${distanceToWaypoint.toStringAsFixed(0)} m',
                  //'${currentPosition!.latitude.toStringAsFixed(4)}, ${currentPosition!.longitude.toStringAsFixed(4)}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  
                ),
            )
          ),

        ]
      ),
    );
  }
}

