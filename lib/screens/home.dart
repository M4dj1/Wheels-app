import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MapController controller = new MapController();
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  buildMap() {
    _determinePosition().then((value) {
      controller.move(new LatLng(value.latitude, value.longitude), 16.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new FlutterMap(
      mapController: controller,
      options: new MapOptions(
        center: buildMap(),
        zoom: 16.0,
      ),
      layers: [
        TileLayerOptions(
            urlTemplate:
                "https://api.mapbox.com/styles/v1/madji/ckrmk1ixd2alh17pdvnx8ne1w/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibWFkamkiLCJhIjoiY2tybWc4NWYwMHZvejJwbDdibjd2NXBqZCJ9.uJ_fye7QXBKBjBznsmIe1g",
            additionalOptions: {
              'accessToken':
                  'pk.eyJ1IjoibWFkamkiLCJhIjoiY2tybWc4NWYwMHZvejJwbDdibjd2NXBqZCJ9.uJ_fye7QXBKBjBznsmIe1g',
              'id': 'mapbox.mapbox-streets-v8'
            }),
        MarkerLayerOptions(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(35.54811895287809, 6.157130518857517),
              builder: (ctx) => Container(
                child: FlutterLogo(),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
