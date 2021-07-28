import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_map_location/flutter_map_location.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MapController mapController = new MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          minZoom: 8.5,
          maxZoom: 17.0,
          interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
          plugins: <MapPlugin>[
            LocationPlugin(),
          ],
        ),
        layers: <LayerOptions>[
          TileLayerOptions(
              urlTemplate:
                  "https://api.mapbox.com/styles/v1/madji/ckrn1yjx82bos19o1y805hvbf/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibWFkamkiLCJhIjoiY2tybWc4NWYwMHZvejJwbDdibjd2NXBqZCJ9.uJ_fye7QXBKBjBznsmIe1g",
              additionalOptions: {
                'accessToken':
                    'pk.eyJ1IjoibWFkamkiLCJhIjoiY2tybWc4NWYwMHZvejJwbDdibjd2NXBqZCJ9.uJ_fye7QXBKBjBznsmIe1g',
                'id': 'mapbox.mapbox-streets-v8'
              }),
        ],
        nonRotatedLayers: <LayerOptions>[
          LocationOptions(
            locationButton(),
            onLocationUpdate: (LatLngData? ld) {
              print(
                  'Location updated: ${ld?.location} (accuracy: ${ld?.accuracy})');
            },
            onLocationRequested: (LatLngData? ld) {
              if (ld == null) {
                return;
              }
              mapController.move(ld.location, 16.5);
            },
            markerBuilder: (BuildContext context, LatLngData ld,
                ValueNotifier<double?> heading) {
              return Marker(
                point: ld.location,
                builder: (_) => Container(
                  child: Column(
                    children: <Widget>[
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.cyan.withOpacity(0.3)),
                            height: 40.0,
                            width: 40.0,
                          ),
                          const Icon(
                            Ionicons.walk_sharp,
                            size: 30.0,
                            color: Colors.cyan,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                height: 60.0,
                width: 60.0,
              );
            },
          ),
        ],
      ),
    ));
  }

  LocationButtonBuilder locationButton() {
    return (BuildContext context, ValueNotifier<LocationServiceStatus> status,
        Function onPressed) {
      return Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0, right: 20.0),
          child: FloatingActionButton(
              backgroundColor: Colors.blueGrey[100],
              child: const Icon(
                Ionicons.planet,
                color: Colors.cyan,
                size: 40.0,
              ),
              onPressed: () => onPressed()),
        ),
      );
    };
  }
}
