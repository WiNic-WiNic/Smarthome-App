import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import '../klassen.dart';
import '../autoClassgenerator.dart';
import 'roomScreen.dart';

class HomePage extends StatefulWidget {

  @protected
  void initState() {
print("initialised");
  }

  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {


  final String basicApiUrl =
      "https://myveryfirstsmarthomeapi.azurewebsites.net/api/home/location";

  //gets data from url
  Future<List<Room>> _getRooms() async {
    print("hey");
    final data = await http.get(basicApiUrl);
    print("downloaded");
    //convert data
    List<Room> rooms = parseRooms(data.body);

    return rooms;
  }

  List<Room> parseRooms(String dataBody) {
    final parsed = json.decode(dataBody).cast<Map<String, dynamic>>();

    List<Room> rooms = parsed.map<Room>((json) => Room.fromJson(json)).toList();

    return rooms;
  }

  Future<Room> createRoom(String roomname) async {
    print("hey");
    Room room = new Room();
    room.roomname = roomname;
    room.shutterList = List<ShutterList>();
    room.lightList = List<LightList>();
    final String requestBody = jsonEncode(room);
    print("Body: " + requestBody);
    final response = await http.post(basicApiUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody
      /*{
      "roomname": roomname,
        "shutterList": [],
        "lightList": []
    }*/
    );
    print("uploaded Status: " + response.statusCode.toString());
    myRefresh();
return null;
  }


Future<String> createPopUp(BuildContext context)async{

    TextEditingController myController = TextEditingController();

    return showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text("Pls enter Roomname"),
        content: TextField(
          controller: myController,
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text("Submit Room"),
            onPressed: (){
              Navigator.of(context).pop(myController.text.toString());
            },
          )
        ],
      );
    });
}


  @override
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
              }),
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
              onTap: () async {
                createPopUp(context).then((getString){
                  if(getString !=null) createRoom(getString);
                });
               //

                print('Add');
              }),
        ],
      ),
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getRooms(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            //asyncsnapshot gives the data when future happens
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Container(
                    child: Center(
                  child: Text("No connection"),
                ));
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Container(child: Center(child: Text('Loading JSON...')));
              case ConnectionState.done:
                if (snapshot.data == null) {
                  return Container(
                      child: Center(child: Text('No Data available')));

                } else {
                  return RefreshIndicator(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(snapshot.data[index].roomname),
                            subtitle: Text("Lights: " +
                                snapshot.data[index].lightList.length
                                    .toString() +
                                ", Shutters; " +
                                snapshot.data[index].shutterList.length
                                    .toString()),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          RoomPage(snapshot.data[index])));
                            },
                          );
                        },
                      ),
                      onRefresh: myRefresh);
                }
            }
            return Container(
                child: Center(
                  child: Text("Something went terrible wrong"),
            ));
          },
        ),
      ),
    );
  }

   Future<Null> myRefresh() async {
    setState(() { });
    return null;
  }


}
