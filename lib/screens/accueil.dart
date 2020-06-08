import 'package:flutter/material.Dart';
import 'package:planlife/class/journal.dart';
import 'package:planlife/class/user.dart';
import 'package:planlife/database/databasehelper.dart';
import 'package:planlife/screens/connexion.dart';
import 'package:planlife/screens/new_journal.dart';
import 'package:planlife/screens/screen_journal.dart';

class Accueil extends StatefulWidget {
  final User user;

  Accueil(this.user, {Key key}) : super(key: key);
  @override
  _Accueil createState() => _Accueil();
}

class _Accueil extends State<Accueil> {
  Future<List<Journal>> journaux;
  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();

    refreshList();
  }

  refreshList() {
    setState(() {
      print(widget.user.id);
      journaux = dbHelper.getJournauxByUser(widget.user.id);
    });
  }

  ListView listJournaux(List<Journal> journaux) {
    return ListView(
      children: <Widget>[
        Column(
          children: <Widget>[
            for (var i in journaux)
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: ButtonTheme(
                  minWidth: 300.0,
                  height: 100.0,
                  child: RaisedButton(
                    color: Colors.green,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return ScreenJournal(i);
                      })).then((onValue) {
                        setState(() {
                          refreshList();
                        });
                      });
                    },
                    child: Text(i.nom_journal,
                        style: TextStyle(fontSize: 30, color: Colors.white)),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  deconnexion() {
    widget.user.setDisconnected();
    dbHelper.updateUser(widget.user).then((res) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return Connexion();
      }));
    });
  }

  list() {
    return Expanded(
      child: FutureBuilder(
        future: journaux,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return listJournaux(snapshot.data);
          }

          if (null == snapshot.data || snapshot.data.length == 0) {
            return Text("Pas de journaux");
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Planlife"),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => new NewJournal(widget.user)),
              ).then((onValue) {
                setState(() {
                  refreshList();
                });
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
            Center(
              child: ButtonTheme(
                minWidth: 250.0,
                child: RaisedButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () {
                    deconnexion();
                  },
                  child: Text('Deconnexion'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
