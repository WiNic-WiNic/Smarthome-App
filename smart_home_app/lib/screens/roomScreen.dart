import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
//import '../klassen.dart';
import '../autoClassgenerator.dart';
import 'home.dart';

class RoomPage extends StatefulWidget {

  final Room rooms;

  RoomPage(this.rooms);


  @override
  _RoomPageState createState() => _RoomPageState(rooms);
}



class _RoomPageState extends State<RoomPage> {

  final HomePage home = new HomePage();
   Room room;
  _RoomPageState(this.room);

  Color _iconColor = Colors.white;



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
                refreshLights();
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

             child: RefreshIndicator(child:   ListView.builder(
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
                     onTapLight(room.lightList[index]);
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
                 onRefresh: refreshLights)
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

  Future<List<LightList>> _getLights(Room room) async {
    print("hey");
    final data = await http.get(home.getAPI()+"location/"+room.roomname);
    print("downloaded lights");
    //convert data
    List<LightList> lights = parseLights(data.body);

    return lights;
  }

  List<LightList> parseLights(String dataBody) {
    final parsed = json.decode(dataBody);
     Room room = Room.fromJson(parsed);
    List<LightList> lights = room.lightList;
    return lights;
  }

  Future<Null> refreshLights() async {
      room.lightList = await _getLights(room);
      setState(() {});
  }


  Future<Null> deleteLight(int lightID) async {
    print("inside delete light");
 final response = await http.delete(home.getAPI()+"light/"+room.roomname+"/"+lightID.toString());
    print("uploaded Status: " + response.statusCode.toString());
    refreshLights();
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
   refreshLights();
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
    refreshLights();
    return null;
  }

  Future<Null> onTapLight(LightList light) async {
      if(light.state==1) light.state=0;
      else light.state=1;
      editLight(light);
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

    TextEditingController string_grpID = TextEditingController();
    List<bool> _selections = List.generate(1, (_) => false);
    String state="OFF";
    int state_int;
    double brightness=50;

    List<int> grpID=[1,2,3,4];

    LightList light = new LightList();

    return showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text("Pls enter Light "),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){
            return ListView(
              //mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Text("Light state:"),
                ),
                //todo: on/off
                Row(
                  children: <Widget>[
                    ToggleButtons(
                      children: <Widget>[
                        Icon(Icons.lightbulb_outline)
                      ],
                      isSelected: _selections,
                      onPressed: (int index){
                        setState(() {
                          _selections[index] = !_selections[index];
                          if (_selections[index]){
                            state = "ON";
                            state_int = 1;
                        }
                          else {
                            state = "OFF";
                            state_int = 0;
                          }
                        });
                      },
                      color: Colors.grey,
                      selectedColor: Colors.amber,
                    ),
                    Container(
                      child: Text(state),
                    )
                  ],
                ),

                Container(
                  child: Text("Light brightness: "+ brightness.toInt().toString()),
                ),
                Slider(
                  //todo: does not update
                  value: brightness,
                  min: 0,
                  max: 100,
                  divisions:100,
                  label: brightness.toInt().toString(),
                  onChanged: (newBrightness){
                    setState(()=>brightness = newBrightness);
                  },

                ),
                Container(
                  child: Text("Group ID:"),
                ),

            Container(
              height:40,
               child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: grpID.length,
      itemBuilder: (BuildContext context, int index) {
      return Text(grpID[index].toString()+" ");
      },

            ),
            ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: string_grpID,
                      ),
                    ),
            Expanded(
            flex: 1,
                   child: RaisedButton(
                     child: Text("Add Grp"),
                      onPressed: (){
                       int newgrpid=int.parse(string_grpID.text.toString());
                       if(!grpID.contains(newgrpid)) grpID.add(newgrpid);
                        setState(() { });
                      },
                    ),
            ),
                  ],
                ),


              ],
            );
          },
        ),
        actions: <Widget>[
          MaterialButton(

            child: Text("Submit Light"),
            onPressed: (){
              //todo: check if input is ok
              //todo: think how to add group items
              if(lightid<0) { //only for create
               //todo id gen does not work if items get deleted in the middle rework

                light.id = room.lightList.length;
              }
              else{ light.id = lightid;}
              light.state=state_int;
              light.dim=brightness.toInt();
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