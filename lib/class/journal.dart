class Journal {
  int id;
  String nom_journal;
  int id_user;

  Journal(this.nom_journal, this.id_user);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom_journal,
      'id_user': id_user,
    };
  }

  Journal.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    nom_journal = map["nom"];
    id_user = map["id_user"];
  }
}
