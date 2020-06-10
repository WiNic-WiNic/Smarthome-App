import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../klassen.dart';

class GroupPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Group Page"),
      ),
      body: Center(
        child: Text("Hello my Groups"),
      ),
    );
  }
}

/*
api:
https://myveryfirstsmarthomeapi.azurewebsites.net/api/home/shutter/kitchen
 */
