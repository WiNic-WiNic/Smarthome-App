class Room {
  final String name;
  final List<Shutter> shutterList;
  final List<Light> lightList;

  Room({this.name, this.shutterList, this.lightList});

  factory Room.fromJson(Map<String, dynamic> json){
    return Room(
      name : json['roomname'] as String,
      shutterList: parseShutter(json),
      lightList: parseLight(json),
    );
  }

  static List<Shutter> parseShutter(shutterJson){
    var list = shutterJson['shutterList'] as List;
    List<Shutter> shutterList = list.map((data)=> Shutter.fromJson(data)).toList();
    return shutterList;
  }
  
  
//parses the jsonArray into a list
    static List<Light> parseLight(lightJson){
      var list = lightJson['lightList'] as List;
      List<Light> lightList = list.map((data)=> Light.fromJson(data)).toList();
      return lightList;
    }
    
    
}

class Light {
  final int id;
  final int state;
  final int dim;
  final List<int> grp_id;

  Light({this.id, this.state, this.dim, this.grp_id});

  factory Light.fromJson(Map<String, dynamic> parsedJson){
    return Light(
      id: parsedJson['id'],
      state: parsedJson['state'],
      dim: parsedJson['dim'],
      grp_id: parseGroupids(parsedJson['grp_id'])
    );
  }
  static List<int> parseGroupids(groupJson){
    List<int> grpIdList = new List<int>.from(groupJson);
    return grpIdList;
  }
}

class Shutter {
  final int id;
  final int pos;
  final int block;

  Shutter({this.id, this.pos, this.block});

  factory Shutter.fromJson(Map<String, dynamic> parsedJson){
    return Shutter(
        id: parsedJson['id'],
        pos: parsedJson['pos'],
        block: parsedJson['block'],
    );
  }

}

class Group {
  final String name;
  final int id;
  final int state;
  final int dim;

  Group({this.name, this.id, this.state, this.dim});

  factory Group.fromJson(Map<String, dynamic> parsedJson){
    return Group(
      name: parsedJson['name'],
      id: parsedJson['id'],
      state: parsedJson['state'],
      dim: parsedJson['dim'],
    );
  }

}
