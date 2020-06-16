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

 final String basicApiUrl = "https://myveryfirstsmarthomeapi.azurewebsites.net/api/home/";
 String getAPI(){return basicApiUrl;}

  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {

  final HomePage home = new HomePage();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_to_photos),
        onPressed: (){
          createaddPopUp(context).then((getString){
            if(getString !=null) createRoom(getString);
          });
          print('pressed Add-Button');
        },
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
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                            IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: (){
                              createeditPopUp(context).then((getString){
                              if(getString !=null) {
                                editRoomname(snapshot.data[index].roomname,
                                     getString);
                              }
                              print("edited");
                              },);
                            },
                            ),

                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: (){
                                deleteRoom(snapshot.data[index].roomname);
                                print("deleted");
                                  },
                                ),
                              ],
                            ),
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

  //gets data from url
  Future<List<Room>> _getRooms() async {
    print("hey");
    final data = await http.get(home.getAPI()+"location");
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

  Future<Null> createRoom(String roomname) async {
    print("hey");
    Room room = new Room();
    room.roomname = roomname;
    room.shutterList = List<ShutterList>();
    room.lightList = List<LightList>();
    final String requestBody = jsonEncode(room);
    print("Body: " + requestBody);
    final response = await http.post(home.getAPI()+"location",
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

  Future<Null> deleteRoom(String roomname) async{
    http.delete(home.getAPI()+"location/"+roomname);
    myRefresh();
    return null;
  }

  Future<Null> editRoomname(String oldroomname,String newroomname) async {


    final response = await http.put(home.getAPI()+"location/"+oldroomname,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: '"'+newroomname+'"'
    );
    print("uploaded Status: " + response.statusCode.toString());
    myRefresh();
    return null;
  }


  Future<String> createaddPopUp(BuildContext context)async{

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

  Future<String> createeditPopUp(BuildContext context)async{

    TextEditingController myController = TextEditingController();

    return showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text("Pls enter new Roomname"),
        content: TextField(
          controller: myController,
        ),
        actions: <Widget>[
          MaterialButton(
            elevation: 5.0,
            child: Text("Submit name"),
            onPressed: (){
              Navigator.of(context).pop(myController.text.toString());
            },
          )
        ],
      );
    });
  }

   Future<Null> myRefresh() async {
    setState(() { });
    return null;
  }


}
