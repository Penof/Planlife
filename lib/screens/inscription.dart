import 'package:flutter/material.dart';
import 'package:planlife/class/user.dart';
import 'package:planlife/database/databasehelper.dart';
import 'connexion.dart';

class Inscription extends StatefulWidget {
  @override
  _Inscription createState() => _Inscription();
}

class _Inscription extends State<Inscription> {
  var dbHelper;
  User user;
  String pseudo = "";
  String mdp = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Inscription"),
        ),
        actions: <Widget>[],
      ),
      body: Center(
        child: Container(
          child: ListView(children: <Widget>[
            SizedBox(
              width: 300,
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(1),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    verticalDirection: VerticalDirection.down,
                    children: <Widget>[formConnexion()],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  inscription(pseudo, mdp) {
    setState(() {
      user = new User(pseudo, mdp, 0);
      dbHelper.insertUser(user).then((res) {
        if (res != null) {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return Connexion();
          }));
        }
      });
    });
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
                      inscription(pseudo, mdp);
                    }
                  },
                  child: Text('Valider'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
