import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
      ///Speed Dial
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        children: [
         SpeedDialChild(
            child: Icon(Icons.border_all),
            backgroundColor: Colors.blueGrey,
            label: 'Add Shutter',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              createShutterPopUp(context, new ShutterList()).then((shutterItem){
                if(shutterItem !=null) {
                  createShutter(shutterItem);
                  refreshShutter();
                }
              });
              print('Shutter added');
              },
          ),
          SpeedDialChild(
              child: Icon(Icons.lightbulb_outline),
              backgroundColor: Colors.amberAccent,
              label: 'Add Light',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () async {
                createLightPopUp(context,new LightList()).then((lightItem){
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
            ///Light ListView Start
            Flexible(

             child: RefreshIndicator(child:   ListView.builder(
               itemCount: room.lightList.length,
               itemBuilder: (BuildContext context, int index){
                 String allGrpIDs = room.lightList[index].grpId.join(", ");
                 return Card(
                   color: Colors.white70,
                     child: ListTile(
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
                               createLightPopUp(context,room.lightList[index]).then((lightItem){
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

                     ),
                 );
               },
             ),
                 onRefresh: refreshLights)
      ),

            Container(
              child: Text("Shutters:",
                style: TextStyle(fontSize: 20),
              ),
            ),
            ///Shutter ListView Start
            Flexible(
            child: RefreshIndicator(child: ListView.builder(
              itemCount: room.shutterList.length,
              itemBuilder: (BuildContext context, int index){
                IconData _icon;
                if(room.shutterList[index].pos>0){
                  _icon = Icons.border_all;
                }
                else{
                  _icon = Icons.border_top;
                }
                return Card(
                    color: Colors.white70,
                    child:ListTile(
                  title: Text("Shutter "+room.shutterList[index].id.toString()),
                  subtitle: Text("Shutter position: "+room.shutterList[index].pos.toString()),
                  dense: true,
                  leading:  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_up),
                        onPressed: (){
                          onTapShutter(room.shutterList[index], "UP");
                        },
                      ),
                      Icon(_icon),
                      IconButton(
                        icon: Icon(Icons.keyboard_arrow_down),
                        onPressed: (){
                          onTapShutter(room.shutterList[index], "DOWN");
                        },
                      ),
                    ],),// //todo: change icons for visible effect
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: (){
                          deleteShutter(room.shutterList[index].id);
                        },
                      ),
                    ],
                  ),
                    ),
                );
              },
            ),
                onRefresh: refreshShutter)
            ),
          ],

        ),
      ),
    );
  }

  ///Light Functions Start:

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
    print("deleted Status: " + response.statusCode.toString());
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
//gives light item back with user input
  Future<LightList> createLightPopUp(BuildContext context,LightList getLight)async{



    TextEditingController string_grpID = TextEditingController();
    List<bool> _selections =  List.generate(1, (_) => false);
    String state="";
    int state_int;
    double brightness;

    List<int> grpID;

    LightList light = new LightList();

    if(getLight.id==null){
      //init light with default
    state="OFF";
    brightness=50;
    state_int=0;
    grpID=[];
    }
    else {
      //init light with old param
      if(getLight.state==1){
    _selections = List.generate(1, (_) => true);
    state="ON";
      }
      else {
        _selections = List.generate(1, (_) => false);
        state="OFF";
      }

      brightness=getLight.dim.toDouble();
      state_int=getLight.state;
      grpID=getLight.grpId;
    }

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
                      child: Text(" "+state),
                    )
                  ],
                ),

                Container(
                  child: Text("Light brightness: "+ brightness.toInt().toString()+"%"),
                ),
                Slider(
                  value: brightness,
                  min: 0,
                  max: 100,
                  divisions:100,
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
      return ButtonTheme(
        minWidth: 40,
        height: 40,
        child: RaisedButton(
            child: Text(grpID[index].toString()),
            onPressed: (){
              grpID.removeAt(index);
              setState(() {});
            },
          ),
      );//
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
                       string_grpID.clear();
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
              //todo: check if group input is ok
              if(getLight.id==null) { //only for create
                for(int i=0;i<=room.lightList.length;i++){
                  if(!room.lightList.contains(i))  light.id = i;
                }
              }
              else{ light.id = getLight.id;}
              light.state=state_int;
              light.dim=brightness.toInt();
              light.grpId=grpID;
              print(grpID.join(", "));
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

  ///Light Functions End:

  ///Shutter Functions Start:

  Future<List<ShutterList>> _getShutter(Room room) async {
    print("hey");
    final data = await http.get(home.getAPI()+"location/"+room.roomname);
    print("downloaded shutter");
    //convert data
    List<ShutterList> shutter = parseShutter(data.body);

    return shutter;
  }

  List<ShutterList> parseShutter(String dataBody) {
    final parsed = json.decode(dataBody);
    Room room = Room.fromJson(parsed);
    List<ShutterList> shutter = room.shutterList;
    return shutter;
  }

  Future<Null> refreshShutter() async {
    room.shutterList = await _getShutter(room);
    setState(() {});
  }

  Future<Null> createShutter(ShutterList shutter) async {
    print("inside create Shutter");
    final String requestBody = jsonEncode(shutter);
    print("Body: " + requestBody);
    final response = await http.put(home.getAPI()+"shutter/"+room.roomname,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody
    );
    print("uploaded Status: " + response.statusCode.toString());
    refreshShutter();
    return null;
  }

  Future<Null> deleteShutter(int shutterID) async {
    print("inside delete light");
    final response = await http.delete(home.getAPI()+"shutter/"+room.roomname+"/"+shutterID.toString());
    print("deleted Status: " + response.statusCode.toString());
    refreshShutter();
    return null;
  }

  Future<Null> onTapShutter(ShutterList shutter,String state) async {
    final response = await http.put(home.getAPI()+"shutter/"+room.roomname+"/"+shutter.id.toString()+"/"+state);
    print("uploaded Status: " + response.statusCode.toString());
    refreshShutter();
    return null;
  }

  Future<ShutterList> createShutterPopUp(BuildContext context,ShutterList getShutter)async{

    double position;

    if(getShutter.id==null){
      //todo: init shutter with uid (should happen in rest)
      getShutter.id = room.shutterList.length;
      getShutter.block=0;
      //init light with default (create)
    position=0;
    }
    else {
      ///maybe not editable
      //init light with old param (edit)
    position=getShutter.pos.toDouble();
    }

    return showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text("Pls enter Shutter "),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){
            return ListView(
              //mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Text("Shutter Position: "+position.toInt().toString()+"%"),
                ),
                Slider(
                  value: position,
                  min: 0,
                  max: 100,
                  divisions:100,
                  onChanged: (newposition){
                    setState(()=>position = newposition);
                  },

                ),
              ],
            );
          },
        ),
        actions: <Widget>[
          MaterialButton(

            child: Text("Submit Shutter"),
            onPressed: (){
              getShutter.pos=position.toInt();
              Navigator.of(context).pop(getShutter);
            },
          )
        ],
      );
    });
  }
}