class ValeurIndicateur {
  int id;
  double number_value;
  String string_value;
  int date_remplissage;
  int id_indicateur;

  ValeurIndicateur(this.date_remplissage, this.id_indicateur, this.number_value,
      this.string_value);

  ValeurIndicateur.number(
      this.date_remplissage, this.id_indicateur, this.number_value);

  ValeurIndicateur.string(
      this.date_remplissage, this.id_indicateur, this.string_value);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'number_value': number_value,
      'string_value': string_value,
      'date_remplissage': date_remplissage,
      'id_indicateur': id_indicateur,
    };
  }

  ValeurIndicateur.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    number_value = map["number_value"];
    string_value = map["string_value"];
    date_remplissage = map["date_remplissage"];
    id_indicateur = map["id_indicateur"];
  }
}
