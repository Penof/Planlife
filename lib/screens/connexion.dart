import 'package:flutter/material.dart';
import 'package:planlife/class/user.dart';
import 'package:planlife/database/databasehelper.dart';

import 'accueil.dart';
import 'inscription.dart';

class Connexion extends StatefulWidget {
  @override
  _Connexion createState() => _Connexion();
}

class _Connexion extends State<Connexion> {
  var dbHelper;
  User user;
  String pseudo = "";
  String mdp = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    dbHelper.getUserConnected().then((res) {
      if (res != null) {
        user = res;
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return Accueil(user);
        }));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Center(
          child: Text("Connexion"),
        ),
        actions: <Widget>[],
      ),
      body: Center(
        child: Container(
          child: ListView(
            children: <Widget>[
              SizedBox(
                width: 300,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      verticalDirection: VerticalDirection.down,
                      children: <Widget>[formConnexion()],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  connexion(pseudo, mdp) {
    setState(() {
      dbHelper.getUser(pseudo, mdp).then((res) {
        if (res != null) {
          user = res;
          user.setConnected();
          dbHelper.updateUser(user);
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return Accueil(user);
          }));
        } else {
          print("nope");
        }
      });
    });
  }

  inscription() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return Inscription();
    }));
  }

  Widget formConnexion() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(hintText: "Pseudo"),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Champ obligatoire';
                } else {
                  pseudo = value;
                }
              },
            ),
            TextFormField(
              decoration: InputDecoration(hintText: "Mot de passe"),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Champ obligatoire';
                } else {
                  mdp = value;
                }
              },
              obscureText: true,
            ),
            Center(
              child: ButtonTheme(
                minWidth: 250.0,
                child: RaisedButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      connexion(pseudo, mdp);
                    }
                  },
                  child: Text('Connexion'),
                ),
              ),
            ),
            Center(
              child: ButtonTheme(
                minWidth: 250.0,
                child: RaisedButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return Inscription();
                    }));
                  },
                  child: Text('Inscription'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
