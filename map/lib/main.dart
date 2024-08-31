import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final int numberOfMarker = 30;
  final int maxLatScale = 14;
  final int maxLngScale = 8;
  final int scale = 1000;
  List<Marker> _markers = [];

  LatLng _createRandomLatLng(LatLng center) {
    double lat =  math.Random().nextInt(2 * maxLatScale) / scale;
    double lng =  math.Random().nextInt(2 * maxLngScale) / scale;
    return new LatLng(center.latitude - (maxLatScale / scale) + lat, center.longitude - (maxLngScale / scale) + lng);
  }

  void _createMarker(LatLng position) {
    List<Marker> markers = new List.generate(numberOfMarker, (_) =>
      Marker(
        point: _createRandomLatLng(position),
        child: Icon(
          Icons.place,
          color: Colors.blue,
          size: 40,
        ),
      )
    );
    setState(() {
      _markers = markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(35.681, 139.767),
          initialZoom: 15.0,
          maxZoom: 16,
          minZoom: 14,
          onMapEvent: (MapEvent event) => {
            if (event is MapEventMoveEnd) {
              _createMarker(event.camera.center)
            }
          },
        ),
        children: [
          TileLayer(
             urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: _markers,
          ),
        ],
      ),
    );
  }
}
