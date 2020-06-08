import 'package:planlife/class/valeurindicateur.dart';

class Indicateur {
  int id;
  String nom;
  int id_journal;
  String type;
  String recurrence;
  ValeurIndicateur valeur;

  Indicateur(this.nom, this.id_journal, this.type, this.recurrence);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'id_journal': id_journal,
      'type': type,
      'recurrence': recurrence,
    };
  }

  Indicateur.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    nom = map["nom"];
    id_journal = map["id_journal"];
    type = map["type"];
    recurrence = map["recurrence"];
  }

  setValeur(ValeurIndicateur valeur) {
    this.valeur = valeur;
  }

  @override
  String toString() {
    return this.id_journal.toString() +
        " " +
        this.nom +
        " " +
        this.type +
        " " +
        this.recurrence +
        " " +
        this.id_journal.toString();
  }
}
