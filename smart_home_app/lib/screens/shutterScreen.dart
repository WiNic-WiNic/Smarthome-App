import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../klassen.dart';

//only shutter to test this
class ShutterPage extends StatelessWidget{

  String ON_OFF ="OFF";

  //gets data from url
  Future<List<Shutter>> _getShutters () async{
    var data = await http.get("https://myveryfirstsmarthomeapi.azurewebsites.net/api/home/shutter/kitchen");
    //convert data
    var shutterList = jsonDecode((data.body));
    //Liste vollfüllen
    List<Shutter> shutters =[];
    for (var s in shutterList ){
      Shutter shutter = Shutter(s["id"], s["pos"], s["block"]);
      shutters.add(shutter);
    }
    print(shutters.length);
    return shutters;
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getShutters(),
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
                    title: Text("Shutter "+snapshot.data[index].id.toString()),
                    subtitle: Text("Shutter position is at "+snapshot.data[index].pos.toString()+"%"),
                    onTap: (){
                      Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[index]))
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

class DetailPage extends StatelessWidget{

  final Shutter shutter;

  DetailPage(this.shutter);

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Shutter "+shutter.id.toString()),

      ),
        body: Center(
          child: Text("Actual position of this shutter is at "+shutter.pos.toString())
        ),
    );
  }
}