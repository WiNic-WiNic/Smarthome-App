class Room {
  final String name;
  final List<Light> lightList;
  final List<Shutter> shutterList;

  Room(this.name, this.lightList, this.shutterList);
}

class Light {
  final int id;
  final int state;
  final int dim;
  final List<Shutter> grp_id;

  Light(this.id, this.state, this.dim, this.grp_id);
}

class Shutter {
  final int id;
  final int pos;
  final int block;

  Shutter(this.id, this.pos, this.block);
}

class Group {
  final String name;
  final int id;
  final int state;
  final int dim;

  Group(this.name, this.id, this.state, this.dim);
}
