import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../autoClassgenerator.dart';
import 'home.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({ Key key }) : super(key: key);

  @override
  _GroupPage createState() => _GroupPage();
}


class _GroupPage extends State<GroupPage> {

  final HomePage home = new HomePage();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Group Page"),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getGroups(),
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
                            title: Text(snapshot.data[index].name),
                            subtitle: Text("Lights will be dimmed to: "+snapshot.data[index].dim.toString()+"%"),
                            leading: Icon(
                              Icons.check_box,
                            color: checkColor(snapshot.data[index].state),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: (){print("edited");
                                  },
                                ),

                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: (){
                                    print("deleted");
                                  },
                                ),
                              ],
                            ),
                            onTap: () {/*
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          RoomPage(snapshot.data[index])));
                            */},
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

  Future<List<Group>> _getGroups() async {
    print("hey");
    final data = await http.get(home.getAPI()+"group");
    print("downloaded groups");
    //convert data
    List<Group> groups = parseGroups(data.body);

    return groups;
  }

  List<Group> parseGroups(String dataBody) {
      final parsed = json.decode(dataBody).cast<Map<String, dynamic>>();
      List<Group> groups = parsed.map<Group>((json) => Group.fromJson(json)).toList();
      return groups;
    }

Color checkColor(int c){
    if(c==1) return Colors.greenAccent;
    else return Colors.grey;
}

  Future<Null> myRefresh() async {
    setState(() { });
    return null;
  }

  }




/*
api:
https://myveryfirstsmarthomeapi.azurewebsites.net/api/home/shutter/kitchen
 */
