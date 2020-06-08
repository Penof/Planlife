class User {
  int id;
  String pseudo;
  String mdp;
  int connected;

  User(this.pseudo, this.mdp, this.connected);

  setConnected() {
    this.connected = 1;
  }

  setDisconnected() {
    this.connected = 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pseudo': pseudo,
      'mdp': mdp,
      'connected': connected,
    };
  }

  User.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    pseudo = map["pseudo"];
    mdp = map["mdp"];
    connected = map["connected"];
  }
}
