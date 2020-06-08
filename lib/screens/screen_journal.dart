import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:planlife/class/indicateur.dart';
import 'package:planlife/class/journal.dart';
import 'package:planlife/class/valeurindicateur.dart';
import 'package:planlife/database/databasehelper.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:loader/src/loadingMixin.dart';

import 'graph.dart';
import 'lineGraph.dart';

List<ValeurIndicateur> valeursIndicateurs = [];
List<List<TimeSeriesSales>> dataTEST = List<List<TimeSeriesSales>>();

class ScreenJournal extends StatefulWidget {
  final Journal journal;

  ScreenJournal(this.journal, {Key key}) : super(key: key);
  @override
  State<ScreenJournal> createState() {
    return _ScreenJournal();
  }
}

class _ScreenJournal extends State<ScreenJournal>
    with LoadingMixin<ScreenJournal> {
  final _formKey = GlobalKey<FormState>();
  Future<List<Indicateur>> indicateurs;

  final dbHelper = DatabaseHelper();
  CalendarController _controller;

  int debut_semaine;
  int fin_semaine;
  int debut_mois;
  int fin_mois;
  int date_selection;

  /*final ValeurIndicateur valeur_indicateurs1 =
      new ValeurIndicateur.boolean(new DateTime.now(), 1, 1);
  final ValeurIndicateur valeur_indicateurs2 =
      new ValeurIndicateur.string(new DateTime.now(), 1, "ccc");
  final ValeurIndicateur valeur_indicateurs3 =
      new ValeurIndicateur.number(new DateTime.now(), 1, 150);
*/
  /*final List<Indicateur> indicateurs = [
    new Indicateur("Fumer ?", 1, "bool", "jour"),
    new Indicateur("avis ?", 1, "string", "jour"),
    new Indicateur("combien ?", 1, "number", "mois"),
  ];*/

  refreshValeurIndicateur(int date) async {
    setState(() {
      indicateurs = dbHelper.getIndicateursByIdJournal(widget.journal.id);
      indicateurs.then((res) {
        if (res != null) {
          res.forEach((indicateur) => {
                if (indicateur != null)
                  {
                    if (indicateur.recurrence == "Jour")
                      {
                        dbHelper
                            .getValeurIndicateursByIdIndicateurAndDateDay(
                                indicateur.id, date)
                            .then((valeur) {
                          if (valeur != null) {
                            indicateur.setValeur(valeur);
                          }
                        })
                      }
                    else if (indicateur.recurrence == "Semaine")
                      {
                        dbHelper
                            .getValeurIndicateursByIdIndicateurAndDateWeek(
                                indicateur.id, debut_semaine, fin_semaine)
                            .then((valeur) {
                          if (valeur != null) {
                            indicateur.setValeur(valeur);
                          }
                        })
                      }
                    else if (indicateur.recurrence == "Mois")
                      {
                        dbHelper
                            .getValeurIndicateursByIdIndicateurAndDateMonth(
                                indicateur.id, debut_mois, fin_mois)
                            .then((valeur) {
                          if (valeur != null) {
                            indicateur.setValeur(valeur);
                          }
                        })
                      }
                  }
              });
        }
      });
    });
  }

  @override
  Future<void> load() async {
    _controller = CalendarController();
    final date_today = new DateTime.now();
    date_selection =
        new DateTime(date_today.year, date_today.month, date_today.day, 14)
            .millisecondsSinceEpoch;
    debut_semaine = date_selection - ((date_today.weekday - 1) * 24 * 3600000);
    fin_semaine = date_selection + ((7 - (date_today.weekday)) * 24 * 3600000);

    debut_mois = (new DateTime(date_today.year, date_today.month, 0, 13))
            .millisecondsSinceEpoch +
        (24 * 3600000);
    fin_mois = (new DateTime(date_today.year, date_today.month + 1, 0, 13))
        .millisecondsSinceEpoch;

    refreshValeurIndicateur(date_selection);
  }

  @override
  void initState() {
    super.initState();
  }

  final availableCalendarFormats = {
    CalendarFormat.month: 'Month',
  };

  list() {
    return Expanded(
      child: FutureBuilder(
        future: indicateurs,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return listIndicateurs(snapshot.data);
          }

          if (null == snapshot.data || snapshot.data.length == 0) {
            return Text("Pas d'indicateurs");
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }

  ListView listIndicateurs(List<Indicateur> indicateurs) {
    return ListView(
      children: <Widget>[
        TableCalendar(
          initialCalendarFormat: CalendarFormat.month,
          availableCalendarFormats: availableCalendarFormats,
          calendarController: _controller,
          calendarStyle: CalendarStyle(
            todayColor: Colors.green[200],
            selectedColor: Colors.green,
          ),
          startingDayOfWeek: StartingDayOfWeek.monday,
          onDaySelected: (date, event) {
            date_selection = date.millisecondsSinceEpoch;
            debut_semaine =
                date_selection - ((date.weekday - 1) * 24 * 3600000);
            fin_semaine =
                date_selection + ((7 - (date.weekday)) * 24 * 3600000);

            debut_mois = (new DateTime(date.year, date.month, 0, 13))
                    .millisecondsSinceEpoch +
                (24 * 3600000);
            fin_mois = (new DateTime(date.year, date.month + 1, 0, 13))
                .millisecondsSinceEpoch;

            refreshValeurIndicateur(date_selection);
          },
        ),
        Container(
            margin: const EdgeInsets.only(top: 10.0),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Indicateurs Journaliers :",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.green[200]),
                            ),
                            for (var i in indicateurs) _indicateurJournalier(i),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Indicateurs Hebdomadires :",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.green[200]),
                            ),
                            for (var i in indicateurs)
                              _indicateurHebdomadaire(i),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Indicateurs Mensuels :",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.green[200]),
                            ),
                            for (var i in indicateurs) _indicateurMensuels(i),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        body: new Container(),
      );
    } else if (hasError) {
      return Text(error);
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(widget.journal.nom_journal),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.white,
              onPressed: () {
                dbHelper.deleteJournaux(widget.journal.id).then((res) {
                  Navigator.pop(context, "Your journal has been deleted.");
                });
              },
            ),
          ],
        ),
        body: new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              list(),
              RaisedButton(
                onPressed: () {
                  _formKey.currentState.save();
                  valeursIndicateurs.forEach((e) => {
                        dbHelper.deleteValeurIndicateur(e).then((res) {
                          dbHelper.insertValeurIndicateur(e).then((value) {
                            print(value.id);
                          });
                        })
                      });
                  valeursIndicateurs.clear();
                },
                color: Colors.green,
                textColor: Colors.white,
                child: Text('Valider'),
              ),
              ButtonTheme(
                minWidth: 250.0,
                child: RaisedButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () {
                    final indics =
                        dbHelper.getIndicateursByIdJournal(widget.journal.id);
                    indics.then((res) {
                      if (res != null) {
                        res.forEach((indicateur) {
                          if (indicateur != null) {
                            if (indicateur.recurrence == "Jour" &&
                                indicateur.type == "Nombre") {
                              dbHelper
                                  .getValeurIndicateursByIdIndicateur(
                                      indicateur.id)
                                  .then((valeurs) {
                                if (valeurs != null) {
                                  List<TimeSeriesSales> data =
                                      List<TimeSeriesSales>();
                                  valeurs.forEach((valeur) {
                                    data.add(new TimeSeriesSales(
                                        new DateTime.fromMillisecondsSinceEpoch(
                                            valeur.date_remplissage),
                                        valeur.number_value.toInt()));
                                  });

                                  dataTEST.add(data);
                                }
                              });
                            }
                          }
                        });
                        print(dataTEST.length);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return Graph(dataTEST, res);
                        }));
                      }
                    });
                  },
                  child: Text('Graphique'),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _indicateurJournalier(indicateur) {
    if (indicateur.recurrence == "Jour") {
      return Container(
        child: _getIndicateur(indicateur),
      );
    } else {
      return Container();
    }
  }

  Widget _indicateurHebdomadaire(indicateur) {
    if (indicateur.recurrence == "Semaine") {
      return Container(
        child: _getIndicateur(indicateur),
      );
    } else {
      return Container();
    }
  }

  Widget _indicateurMensuels(indicateur) {
    if (indicateur.recurrence == "Mois") {
      return Container(
        child: _getIndicateur(indicateur),
      );
    } else {
      return Container();
    }
  }

  Widget _getIndicateur(indicateur) {
    switch (indicateur.type) {
      case "Nombre":
        final controller = TextEditingController();
        if (indicateur.valeur != null) {
          controller.text = indicateur.valeur.number_value.toString();
        }
        return Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              indicateur.nom,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.green),
              textAlign: TextAlign.left,
            ),
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
              onSaved: (value) {
                if (value != "") {
                  print(value);
                  valeursIndicateurs.add(new ValeurIndicateur.number(
                      date_selection, indicateur.id, double.parse(value)));
                }
              },
            ),
          ],
        ));
        break;
      case "Texte":
        final controller = TextEditingController();
        if (indicateur.valeur != null) {
          controller.text = indicateur.valeur.string_value;
        }
        return Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              indicateur.nom,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.green),
            ),
            TextFormField(
              controller: controller,
              onSaved: (value) {
                valeursIndicateurs.add(new ValeurIndicateur.string(
                    date_selection, indicateur.id, value));
              },
            ),
          ],
        ));

        break;
      default:
        return Container(
          child: Text("vide"),
        );
    }
  }
}
