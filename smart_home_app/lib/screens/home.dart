import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../klassen.dart';
import 'roomScreen.dart';


class HomePage extends StatelessWidget {

  //gets data from url
  Future<List<Room>> _getRooms () async{
    print("hey");
    var data = await http.get("https://myveryfirstsmarthomeapi.azurewebsites.net/api/home/location");
    print("downloaded");
    //convert data
    List<Room> rooms =parseRooms(data.body);

    return rooms;
  }

  static List<Room> parseRooms(String dataBody){
    final parsed = json.decode(dataBody).cast<Map<String, dynamic>>();

    List<Room> rooms = parsed.map<Room>((json)=>Room.fromJson(json)).toList();

    return rooms;
  }

  Future<>



  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
              child: Icon(Icons.delete),
              backgroundColor: Colors.red,
              label: 'Delete',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                 print('Delete');
              }
          ),
          SpeedDialChild(
            child: Icon(Icons.border_color),
            backgroundColor: Colors.blue,
            label: 'Change',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => print('Change'),
          ),
          SpeedDialChild(
            child: Icon(Icons.add_to_photos),
            backgroundColor: Colors.green,
            label: 'Add',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              print('Add');
            }

          ),
        ],
      ),
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getRooms(),
          builder: (BuildContext context, AsyncSnapshot snapshot ){//asyncsnapshot gives the data when future happens
           switch(snapshot.connectionState) {
             case ConnectionState.none:
               return Container(
                   child: Center(
                     child: Text("No connection"),
                   )
               );
             case ConnectionState.active:
             case ConnectionState.waiting:
               return Container(
                   child: Center(
                       child: Text(
                           'Loading JSON...'
                       )
                   )
               );
             case ConnectionState.done:
               if (snapshot.data==null) {
                 return Container(
                     child: Center(
                         child: Text(
                             'No Data available'
                         )
                     )
                 );
               }else {
                 return ListView.builder(
                   itemCount: snapshot.data.length,
                   itemBuilder: (BuildContext context, int index) {
                     return ListTile(
                       title: Text(snapshot.data[index].name),
                       subtitle: Text("Lights: " + snapshot.data[index].lightList.length.toString()+
                           ", Shutters; "+ snapshot.data[index].shutterList.length.toString()),
                       onTap: (){
                         Navigator.push(context,
                             new MaterialPageRoute(builder: (context) => RoomPage(snapshot.data[index]))
                         );
                       },
                     );
                   },

                 );
               }

            }
           return  Container(
               child: Center(
                 child: Text("Something went terrible wrong"),
               )
           );
          },
        ),
      ),
    );
  }
}
