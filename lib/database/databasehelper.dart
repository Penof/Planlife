import 'package:path/path.dart';
import 'package:planlife/class/indicateur.dart';
import 'package:planlife/class/journal.dart';
import 'package:planlife/class/user.dart';
import 'package:planlife/class/valeurindicateur.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DatabaseHelper {
  static const databaseName = 'planlife_db5.db';
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initializeDatabase();
    return _db;
  }

  initializeDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), databaseName),
      version: 1,
      onCreate: (db, version) => _createDb(db),
    );
  }

  static void _createDb(Database db) {
    db.execute(
        "CREATE TABLE journal(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, nom TEXT, id_user INTEGER)");
    db.execute(
        "CREATE TABLE indicateur(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, nom TEXT, id_journal INTEGER, type TEXT, recurrence TEXT)");
    db.execute(
        "CREATE TABLE valeur_indicateur(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, number_value REAL, string_value TEXT, date_remplissage INTEGER, id_indicateur INTEGER)");
    db.execute(
        "CREATE TABLE user(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, pseudo TEXT, mdp TEXT, connected INTEGER)");
  }

  Future<Journal> insertJournal(Journal journal) async {
    // Get a reference to the database.
    var db = await _db;
    journal.id = await db.insert("journal", journal.toMap());
    return journal;
  }

  Future<User> insertUser(User user) async {
    // Get a reference to the database.
    var db = await _db;
    print(user.pseudo);
    user.id = await db.insert("user", user.toMap());
    return user;
  }

  Future<Indicateur> insertIndicateur(Indicateur indicateur) async {
    // Get a reference to the database.

    var db = await _db;
    indicateur.id = await db.insert("indicateur", indicateur.toMap());

    return indicateur;
  }

  Future<ValeurIndicateur> insertValeurIndicateur(
      ValeurIndicateur valeurIndicateur) async {
    // Get a reference to the database.

    var db = await _db;
    valeurIndicateur.id =
        await db.insert("valeur_indicateur", valeurIndicateur.toMap());

    return valeurIndicateur;
  }

  Future<List<Journal>> getJournauxByUser(id_user) async {
    final dbJounraux = await db;
    List<Map> maps = await dbJounraux.query(
      "journal",
      columns: [
        "id",
        "nom",
        "id_user",
      ],
      where: 'id_user = ?',
      whereArgs: [id_user],
    );
    List<Journal> journaux = [];
    if (maps.length > 0) {
      for (var i = 0; i < maps.length; i++) {
        journaux.add(Journal.fromMap(maps[i]));
      }
    }
    return journaux;
  }

  Future<List<Indicateur>> getIndicateur() async {
    final dbIndicateurs = await db;
    List<Map> maps = await dbIndicateurs.query("indicateur", columns: [
      "id",
      "nom",
      'id_journal',
      'type',
      'recurrence',
    ]);
    List<Indicateur> indicateurs = [];
    if (maps.length > 0) {
      for (var i = 0; i < maps.length; i++) {
        indicateurs.add(Indicateur.fromMap(maps[i]));
      }
    }
    return indicateurs;
  }

  Future<List<Indicateur>> getIndicateursByIdJournal(int id_journal) async {
    final dbIndicateurs = await db;
    List<Map> maps = await dbIndicateurs.query(
      "indicateur",
      columns: [
        "id",
        "nom",
        'id_journal',
        'type',
        'recurrence',
      ],
      where: 'id_journal = ?',
      whereArgs: [id_journal],
    );
    List<Indicateur> indicateurs = [];
    if (maps.length > 0) {
      for (var i = 0; i < maps.length; i++) {
        indicateurs.add(Indicateur.fromMap(maps[i]));
      }
    }
    return indicateurs;
  }

  Future<List<ValeurIndicateur>> getValeurIndicateursByIdIndicateur(
      int id_indicateur) async {
    final dbValeurIndicateur = await db;
    List<Map> maps = await dbValeurIndicateur.query(
      "valeur_indicateur",
      columns: [
        "id",
        "number_value",
        'string_value',
        'date_remplissage',
        'id_indicateur',
      ],
      where: 'id_indicateur = ?',
      whereArgs: [id_indicateur],
      orderBy: 'date_remplissage ASC',
    );
    List<ValeurIndicateur> valeurIndicateurs = [];
    if (maps.length > 0) {
      for (var i = 0; i < maps.length; i++) {
        valeurIndicateurs.add(ValeurIndicateur.fromMap(maps[i]));
      }
    }
    return valeurIndicateurs;
  }

  Future<ValeurIndicateur> getValeurIndicateursByIdIndicateurAndDateDay(
      int id_indicateur, int date) async {
    final dbValeurIndicateur = await db;
    List<Map> maps = await dbValeurIndicateur.query(
      "valeur_indicateur",
      columns: [
        "id",
        "number_value",
        'string_value',
        'date_remplissage',
        'id_indicateur',
      ],
      where: 'id_indicateur = ? AND date_remplissage = ?',
      whereArgs: [id_indicateur, date],
    );
    ValeurIndicateur valeurIndicateurs;
    if (maps.length > 0) {
      for (var i = 0; i < maps.length; i++) {
        valeurIndicateurs = ValeurIndicateur.fromMap(maps[i]);
      }
    }
    return valeurIndicateurs;
  }

  Future<ValeurIndicateur> getValeurIndicateursByIdIndicateurAndDateWeek(
      int id_indicateur, int debut_semaine, int fin_semaine) async {
    final dbValeurIndicateur = await db;
    List<Map> maps = await dbValeurIndicateur.query(
      "valeur_indicateur",
      columns: [
        "id",
        "number_value",
        'string_value',
        'date_remplissage',
        'id_indicateur',
      ],
      where:
          'id_indicateur = ? AND date_remplissage > ? AND date_remplissage < ?',
      whereArgs: [id_indicateur, debut_semaine, fin_semaine],
    );
    ValeurIndicateur valeurIndicateurs;
    if (maps.length > 0) {
      for (var i = 0; i < maps.length; i++) {
        valeurIndicateurs = ValeurIndicateur.fromMap(maps[i]);
      }
    }
    return valeurIndicateurs;
  }

  Future<ValeurIndicateur> getValeurIndicateursByIdIndicateurAndDateMonth(
      int id_indicateur, int debut_mois, int fin_mois) async {
    final dbValeurIndicateur = await db;
    List<Map> maps = await dbValeurIndicateur.query(
      "valeur_indicateur",
      columns: [
        "id",
        "number_value",
        'string_value',
        'date_remplissage',
        'id_indicateur',
      ],
      where:
          'id_indicateur = ? AND date_remplissage > ? AND date_remplissage < ?',
      whereArgs: [id_indicateur, debut_mois, fin_mois],
    );
    ValeurIndicateur valeurIndicateurs;
    if (maps.length > 0) {
      for (var i = 0; i < maps.length; i++) {
        valeurIndicateurs = ValeurIndicateur.fromMap(maps[i]);
      }
    }
    return valeurIndicateurs;
  }

  Future<int> deleteJournaux(int id) async {
    var dbClient = await db;
    return await dbClient.delete("journal", where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateJournaux(Journal journal) async {
    var dbClient = await db;
    return await dbClient.update("journal", journal.toMap(),
        where: 'id = ?', whereArgs: [journal.id]);
  }

  Future<int> updateValeurIndicateur(ValeurIndicateur valeurIndicateurs) async {
    var dbClient = await db;
    return await dbClient.update("valeur_indicateur", valeurIndicateurs.toMap(),
        where: 'date_remplissage = ? AND id_indicateur = ?',
        whereArgs: [
          valeurIndicateurs.date_remplissage,
          valeurIndicateurs.id_indicateur
        ]);
  }

  Future<int> deleteValeurIndicateur(ValeurIndicateur valeurIndicateurs) async {
    var dbClient = await db;
    return await dbClient.delete("valeur_indicateur",
        where: 'date_remplissage = ? AND id_indicateur = ?',
        whereArgs: [
          valeurIndicateurs.date_remplissage,
          valeurIndicateurs.id_indicateur
        ]);
  }

  Future<int> updateUser(User user) async {
    var dbClient = await db;
    return await dbClient
        .update("user", user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<User> getUser(pseudo, mdp) async {
    final dbJounraux = await db;
    List<Map> maps = await dbJounraux.query(
      "user",
      columns: [
        "id",
        "pseudo",
        "mdp",
        "connected",
      ],
      where: 'pseudo = ? AND mdp = ?',
      whereArgs: [
        pseudo,
        mdp,
      ],
    );
    User user;
    if (maps.length > 0) {
      for (var i = 0; i < maps.length; i++) {
        user = User.fromMap(maps[i]);
      }
    }

    return user;
  }

  Future<User> getUserConnected() async {
    final dbJounraux = await db;
    List<Map> maps = await dbJounraux.query(
      "user",
      columns: [
        "id",
        "pseudo",
        "mdp",
        "connected",
      ],
      where: 'connected = ?',
      whereArgs: [1],
    );
    User user;
    if (maps.length > 0) {
      for (var i = 0; i < maps.length; i++) {
        user = User.fromMap(maps[i]);
      }
    }
    return user;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
