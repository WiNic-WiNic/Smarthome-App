import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../klassen.dart';

class RoomPage extends StatelessWidget {

  final Room room;

  RoomPage(this.room);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(room.name+" Page"),
      ),
      body: Container(

      ),
    );
  }
}
