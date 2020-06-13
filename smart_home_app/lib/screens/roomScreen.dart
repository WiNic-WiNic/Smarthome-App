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

        child: Column(
          children: [
            Container(
              child: Text("Lights:"),
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

String checkState(Light light){
  if(light.state==1) return ("ON with "+light.dim.toString()+"%");
  else return "OFF";
}