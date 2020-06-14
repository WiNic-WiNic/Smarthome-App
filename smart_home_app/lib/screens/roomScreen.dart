import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
//import '../klassen.dart';
import '../autoClassgenerator.dart';

class RoomPage extends StatelessWidget {

  final Room room;

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
              onTap: () async {/*
                createPopUp(context).then((getString){
                  if(getString !=null) createRoom(getString);
                });
               //
*/
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
                return ListTile(
                  title: Text("Light "+room.lightList[index].id.toString()),
                  subtitle: Text("Light is "+checkState(room.lightList[index])),
                  onTap: (){
                    print(checkState(room.lightList[index]));
                  },
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
                );
              },
            ),
            ),
          ],

        ),
      ),
    );
  }
}

String checkState(LightList light){
  if(light.state==1) return ("ON with "+light.dim.toString()+"%");
  else return "OFF";
}