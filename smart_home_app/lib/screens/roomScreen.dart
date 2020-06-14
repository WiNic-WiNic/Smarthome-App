import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
//import '../klassen.dart';
import '../autoClassgenerator.dart';
import 'home.dart';

class RoomPage extends StatelessWidget {

  final HomePage home = new HomePage();
  final Room room;
  Color _iconColor = Colors.white;

  RoomPage(this.room);

    Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
         SpeedDialChild(
            child: Icon(Icons.border_all),
            backgroundColor: Colors.blueGrey,
            label: 'Add Shutter',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => print('Shutter added'),
          ),
          SpeedDialChild(
              child: Icon(Icons.lightbulb_outline),
              backgroundColor: Colors.amberAccent,
              label: 'Add Light',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () async {
                createLightPopUp(context,-1).then((lightItem){
                if(lightItem !=null) {
                  createLight(lightItem);
                }
                });

                /*
                createPopUp(context).then((getString){
                  if(getString !=null) createRoom(getString);
                });
               //
*/            home.getAPI();
                print('Light added');
              }),
        ],
      ),
      appBar: AppBar(
        title: Text(room.roomname+" Page"),
      ),
      body: Container(

        child: Column(
          children: [
            Container(
              child: Text("Lights:",
          style: TextStyle(fontSize: 20),
        ),
      ),


            Flexible(
             child: ListView.builder(
              itemCount: room.lightList.length,
              itemBuilder: (BuildContext context, int index){
                String allGrpIDs = room.lightList[index].grpId.join(", ");
                return ListTile(
                  title: Text("Light "+room.lightList[index].id.toString()),
                  subtitle: Text("Light is "+checkState(room.lightList[index])+
                      "\n Group IDs: "+allGrpIDs),
                  isThreeLine: true,
                  dense: true,
                  leading: Icon(
                    Icons.lightbulb_outline,
                    color:  _iconColor,
                  ),
                  onTap: (){
                    print(checkState(room.lightList[index]));
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: (){
                          createLightPopUp(context,room.lightList[index].id).then((lightItem){
                            if(lightItem !=null) {
                              editLight(lightItem);
                            }
                          });
                        },
                      ),

                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: (){
                          deleteLight(room.lightList[index].id);
                        },
                      ),
                    ],
                  ),

                );
              },
            ),
      ),

            Container(
              child: Text("Shutters:"),
            ),
            Flexible(
            child: ListView.builder(
              itemCount: room.shutterList.length,
              itemBuilder: (BuildContext context, int index){
                return ListTile(
                  title: Text("Shutter "+room.shutterList[index].id.toString()),
                  subtitle: Text("Light Test"),
                  onTap: (){

                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: (){},
                      ),

                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: (){},
                      ),
                    ],
                  ),
                );
              },
            ),
            ),
          ],

        ),
      ),
    );
  }

  Future<Null> deleteLight(int lightID) async {
    print("inside delete light");
 final response = await http.delete(home.getAPI()+"light/"+room.roomname+"/"+lightID.toString());
    print("uploaded Status: " + response.statusCode.toString());
    // myRefresh();
    return null;
  }

  Future<Null> createLight(LightList light) async {
    print("inside create light");
    final String requestBody = jsonEncode(light);
    print("Body: " + requestBody);
    final response = await http.put(home.getAPI()+"light/"+room.roomname,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody
    );
    print("uploaded Status: " + response.statusCode.toString());
   // myRefresh();
    return null;
  }
//todo: only change brightness and groupids
  Future<Null> editLight(LightList light) async {
    print("inside create light");
    final String requestBody = jsonEncode(light);
    print("Body: " + requestBody);
    final response = await http.put(home.getAPI()+"light/"+room.roomname+"/"+light.id.toString(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody
    );
    print("uploaded Status: " + response.statusCode.toString());
    // myRefresh();
    return null;
  }

LightList demoLightInit(){
      LightList light =new LightList();
      light.id=12;
      light.state=1;
      light.dim=98;
      light.grpId=[1,2,3,4,5];
      return light;
}

//gives light item back
  Future<LightList> createLightPopUp(BuildContext context,int lightid)async{

    TextEditingController id = TextEditingController();
    TextEditingController state = TextEditingController();
    TextEditingController dim = TextEditingController();

    LightList light = new LightList();

    return showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text("Pls enter Light "),
        content: ListView(
          //mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: Text("Light ID:"),
            ),
          TextField(
          controller: id,
        ),
            Container(
              child: Text("Light state:"),
            ),
            TextField(
              controller: state,
            ),
            Container(
              child: Text("Light brightness:"),
            ),
            TextField(
              controller: dim,
            ),
        ],
        ),
        actions: <Widget>[
          MaterialButton(

            child: Text("Submit Room"),
            onPressed: (){
              //todo: check if input is ok
              //todo: think how to add group items
              if(lightid<0) { //only for edits
                light.id = int.parse(id.text.toString());
              }
              else{ light.id = lightid;}
              light.state=int.parse(state.text.toString());
              light.dim=int.parse(dim.text.toString());
              light.grpId=[1,2];
              Navigator.of(context).pop(light);
            },
          )
        ],
      );
    });
  }






  String checkState(LightList light){
    if(light.state==1) {
      _iconColor= Colors.amber;
      return ("ON with "+light.dim.toString()+"%");
    }
    else{
      _iconColor= Colors.grey;
      return "OFF";
    }

  }
}