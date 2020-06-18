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
//todo delete if uid is generated in rest
  List<Group> groups = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_to_photos),
          onPressed: (){
            createGroupPopUp(context, new Group()).then((groupItem){
              if(groupItem !=null) {
                createGroup(groupItem);
              }
            });
        print("added Group");
      }),
      appBar: AppBar(
        title: Text("Group Page"),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getGroups(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            //todo delete if uid is generated in rest
            groups=snapshot.data;
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
                            title: Text("(ID: "+snapshot.data[index].id.toString()+") " + snapshot.data[index].name),
                            subtitle: Text("Lights will have brightness of: "+snapshot.data[index].dim.toString()+"%"),
                            leading: Icon(
                              Icons.check_box,
                            color: checkColor(snapshot.data[index].state),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    createGroupPopUp(
                                        context, snapshot.data[index]).then((
                                        groupItem) {
                                      if (groupItem != null) {
                                        editGroup(groupItem);
                                      }
                                      print("edited");
                                    });

                                  }),

                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: (){
                                    deleteGroup(snapshot.data[index].name);
                                    print("deleted");
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
                              onTapGroup(snapshot.data[index]);
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

  Future<Null> createGroup(Group group) async {
    print("inside create group");
    final String requestBody = jsonEncode(group);
    print("Body: " + requestBody);
    final response = await http.post(home.getAPI()+"group/",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody
    );
    print("uploaded Status: " + response.statusCode.toString());
    myRefresh();
    return null;
  }

  Future<Null> editGroup(Group group) async {
    print("inside create light");
    final String requestBody = jsonEncode(group);
    print("Body: " + requestBody);
    final response = await http.put(home.getAPI()+"group/"+group.name,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody
    );
    print("uploaded Status: " + response.statusCode.toString());
    myRefresh();
    return null;
  }

  Future<Null> onTapGroup(Group group) async {
   String state;
    if(group.state==1) {
      group.state=0;
      state="OFF";
    }
    else{
      group.state=1;
      state="ON";
    }
    final data = await http.put(home.getAPI()+"group/"+group.id.toString()+"/"+state);
    myRefresh();
    return null;
  }

  Future<Null> deleteGroup(String groupID) async {
    print("inside delete group");
    final response = await http.delete(home.getAPI()+"group/"+groupID);
    print("deleted Status: " + response.statusCode.toString());
    myRefresh();
    return null;
  }

  Future<Group> createGroupPopUp(BuildContext context,Group getGroup)async{

    TextEditingController string_grpName = TextEditingController();
    double brightness;

    //inits for create new group
    if(getGroup.id==null){
      brightness=50;
    }
    //edit existing group
    else{
      brightness=getGroup.dim.toDouble();
    }



    return showDialog(context: context,builder: (context){
      return AlertDialog(
        title: Text("Pls enter Group "),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState){
            return ListView(
              children: <Widget>[
               Container(
                child: Text("Enter Group Name:"),
               ),
                TextField(
                  controller: string_grpName,
                ),
                Container(
                  child: Text("Brightness for Group: "+brightness.toInt().toString()+"%"),
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
              ],
            );
          },
        ),
        actions: <Widget>[
          MaterialButton(

            child: Text("Submit Group"),
            onPressed: (){
              //default
              getGroup.state=0;
              //init with unique id //todo delete if uid is generated in rest
              if(getGroup.id==null) { //only for create
                 if(groups!=null) getGroup.id = groups.length;
              }
              else{ getGroup.id = getGroup.id;}
              //set in this call
              getGroup.name=string_grpName.text.toString();
              getGroup.dim=brightness.toInt();
              Navigator.of(context).pop(getGroup);
            },
          )
        ],
      );
    });
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
