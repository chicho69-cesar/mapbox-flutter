import 'package:flutter/material.dart';

import 'package:mapbox_flutter/src/views/fullscreenmap.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Mapas App',
      debugShowCheckedModeBanner: false,
      home: FullScreenMap(),
    );
  }
}
