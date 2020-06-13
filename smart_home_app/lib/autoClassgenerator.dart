// To parse this JSON data, do
//
//     final room = roomFromJson(jsonString);

import 'dart:convert';

List<Room> roomFromJson(String str) => List<Room>.from(json.decode(str).map((x) => Room.fromJson(x)));

String roomToJson(List<Room> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Room {
  Room({
    this.roomname,
    this.shutterList,
    this.lightList,
  });

  String roomname;
  List<ShutterList> shutterList;
  List<LightList> lightList;

  factory Room.fromJson(Map<String, dynamic> json) => Room(
    roomname: json["roomname"],
    shutterList: List<ShutterList>.from(json["shutterList"].map((x) => ShutterList.fromJson(x))),
    lightList: List<LightList>.from(json["lightList"].map((x) => LightList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "roomname": roomname,
    "shutterList": List<dynamic>.from(shutterList.map((x) => x.toJson())),
    "lightList": List<dynamic>.from(lightList.map((x) => x.toJson())),
  };
}

class LightList {
  LightList({
    this.id,
    this.state,
    this.dim,
    this.grpId,
  });

  int id;
  int state;
  int dim;
  List<int> grpId;

  factory LightList.fromJson(Map<String, dynamic> json) => LightList(
    id: json["id"],
    state: json["state"],
    dim: json["dim"],
    grpId: List<int>.from(json["grp_id"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "state": state,
    "dim": dim,
    "grp_id": List<dynamic>.from(grpId.map((x) => x)),
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
