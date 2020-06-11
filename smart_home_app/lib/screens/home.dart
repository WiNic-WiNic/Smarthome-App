import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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


  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          print("hihihi");
        },
      ),
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getRooms(),
          builder: (BuildContext context, AsyncSnapshot snapshot ){//asyncsnapshot gives the data when future happens
            if(snapshot.data==null){
              return Container(
                  child: Center(
                    child: Text("Loading..."),
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
          },
        ),
      ),
    );
  }
}
