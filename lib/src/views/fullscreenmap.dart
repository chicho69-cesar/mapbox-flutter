import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';

class FullScreenMap extends StatefulWidget {
  const FullScreenMap({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  late MapboxMapController mapController;
  final center = const LatLng(37.810575, -122.477174);

  String selectedStyle = 'mapbox://styles/klerith/ckcur145v3zxe1io3f7oj00w7';

  final darkStyle = 'mapbox://styles/klerith/ckcuqzbf741ba1imjtq6jmm3o';
  final streetStyle = 'mapbox://styles/klerith/ckcur145v3zxe1io3f7oj00w7';

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _onStyleLoaded();
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/custom-icon.png");
    addImageFromUrl("networkImage", "/50");
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  /// Adds a network image to the currently displayed style
  Future<void> addImageFromUrl(String name, String url) async {
    final uri = Uri.https('via.placeholder.com', url);
    var response = await http.get(uri);
    return mapController.addImage(name, response.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: createMap(),
      floatingActionButton: floatingButtons(),
    );
  }

  Column floatingButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        // Símbolos
        FloatingActionButton(
          child: const Icon(Icons.sentiment_very_dissatisfied),
          onPressed: () {
            mapController.addSymbol(
              SymbolOptions(
                geometry: center,
                // iconSize: 3,
                iconImage: 'networkImage',
                textField: 'Montaña creada aquí',
                textOffset: const Offset(0, 2)
              )
            );
          }
        ),

        const SizedBox(height: 5),

        // ZoomIn
        FloatingActionButton(
          child: const Icon(Icons.zoom_in),
          onPressed: () {
            mapController.animateCamera(CameraUpdate.zoomIn());
          }
        ),

        const SizedBox(height: 5),

        // ZoomOut
        FloatingActionButton(
          child: const Icon(Icons.zoom_out),
          onPressed: () {
            mapController.animateCamera(CameraUpdate.zoomOut());
          }
        ),

        const SizedBox(height: 5),

        // Cambiar Estilos
        FloatingActionButton(
          child: const Icon(Icons.add_to_home_screen),
          onPressed: () {
            if (selectedStyle == darkStyle) {
              selectedStyle = streetStyle;
            } else {
              selectedStyle = darkStyle;
            }
            _onStyleLoaded();
            setState(() {});
          }
        )
      ],
    );
  }

  MapboxMap createMap() {
    return MapboxMap(
      styleString: selectedStyle,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: center, zoom: 14),
    );
  }
}
