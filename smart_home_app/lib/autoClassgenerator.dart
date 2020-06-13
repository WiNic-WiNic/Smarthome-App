// To parse this JSON data, do
//
//     final home = homeFromJson(jsonString);

import 'dart:convert';

Home homeFromJson(String str) => Home.fromJson(json.decode(str));

String homeToJson(Home data) => json.encode(data.toJson());

class Home {
  Home({
    this.roomList,
    this.groupList,
  });

  List<RoomList> roomList;
  List<GroupListElement> groupList;

  factory Home.fromJson(Map<String, dynamic> json) => Home(
    roomList: List<RoomList>.from(json["roomList"].map((x) => RoomList.fromJson(x))),
    groupList: List<GroupListElement>.from(json["groupList"].map((x) => GroupListElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "roomList": List<dynamic>.from(roomList.map((x) => x.toJson())),
    "groupList": List<dynamic>.from(groupList.map((x) => x.toJson())),
  };
}

class GroupListElement {
  GroupListElement({
    this.name,
    this.id,
    this.state,
    this.dim,
    this.grpId,
  });

  String name;
  int id;
  int state;
  int dim;
  List<int> grpId;

  factory GroupListElement.fromJson(Map<String, dynamic> json) => GroupListElement(
    name: json["name"] == null ? null : json["name"],
    id: json["id"],
    state: json["state"],
    dim: json["dim"],
    grpId: json["grp_id"] == null ? null : List<int>.from(json["grp_id"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "id": id,
    "state": state,
    "dim": dim,
    "grp_id": grpId == null ? null : List<dynamic>.from(grpId.map((x) => x)),
  };
}

class RoomList {
  RoomList({
    this.roomname,
    this.shutterList,
    this.lightList,
  });

  String roomname;
  List<ShutterList> shutterList;
  List<GroupListElement> lightList;

  factory RoomList.fromJson(Map<String, dynamic> json) => RoomList(
    roomname: json["roomname"],
    shutterList: List<ShutterList>.from(json["shutterList"].map((x) => ShutterList.fromJson(x))),
    lightList: List<GroupListElement>.from(json["lightList"].map((x) => GroupListElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "roomname": roomname,
    "shutterList": List<dynamic>.from(shutterList.map((x) => x.toJson())),
    "lightList": List<dynamic>.from(lightList.map((x) => x.toJson())),
  };
}

class ShutterList {
  ShutterList({
    this.id,
    this.pos,
    this.block,
  });

  int id;
  int pos;
  int block;

  factory ShutterList.fromJson(Map<String, dynamic> json) => ShutterList(
    id: json["id"],
    pos: json["pos"],
    block: json["block"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "pos": pos,
    "block": block,
  };
}
