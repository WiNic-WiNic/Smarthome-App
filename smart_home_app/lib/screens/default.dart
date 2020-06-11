import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../klassen.dart';

class WeatherPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weahter Page"),
      ),
      body: Center(
        child: Text("Weahter Data..."),
      ),
    );
  }
}
