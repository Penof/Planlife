import 'package:flutter/material.dart';
import 'package:planlife/class/indicateur.dart';
import 'package:planlife/class/journal.dart';
import 'package:planlife/class/user.dart';
import 'package:planlife/database/databasehelper.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

List<String> noms = [];
List<String> types = [];
List<String> recurrences = [];

class NewJournal extends StatefulWidget {
  final User user;
  NewJournal(this.user, {Key key}) : super(key: key);
  @override
  _NewJournal createState() => _NewJournal();
}

class _NewJournal extends State<NewJournal> {
  @override
  void initState() {
    super.initState();
    noms.clear();
    types.clear();
    recurrences.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Center(
          child: Text("Nouveau journal"),
        ),
      ),
      body: MyCustomForm(widget.user),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  final User user;
  MyCustomForm(this.user, {Key key}) : super(key: key);
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.

  int _count = 0;
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper();
  final List<Indicateur> indicateurs = [];
  String nom_journal = "";

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    List<Widget> _formIndicateur =
        new List.generate(_count, (int i) => new FormIndicateur(_count));
    return Center(
      child: Container(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(hintText: "Nom du journal"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Champ obligatoire';
                    } else {
                      nom_journal = value;
                    }
                  },
                ),
                new Container(
                  child: Expanded(
                    child: ListView(
                      children: _formIndicateur,
                    ),
                  ),
                ),
                Center(
                  child: IconButton(
                    icon: Icon(Icons.add_circle),
                    color: Colors.green,
                    iconSize: 50,
                    onPressed: () {
                      _addNewFormIndicateur();
                    },
                  ),
                ),
                Center(
                  child: RaisedButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.
                      if (_formKey.currentState.validate()) {
                        dbHelper
                            .insertJournal(Journal(
                          nom_journal,
                          widget.user.id,
                        ))
                            .then((value) {
                          print(noms.length);

                          for (var i = 0; i < _count; i++) {
                            print(noms[i]);

                            dbHelper
                                .insertIndicateur(Indicateur(noms[i], value.id,
                                    types[i], recurrences[i]))
                                .then((value) {
                              noms.clear();
                              types.clear();
                              recurrences.clear();
                              print(value.id);
                            });
                          }
                        });

                        Navigator.pop(context, "Your todo has been saved.");
                      }
                    },
                    child: Text('Valider la creation'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addNewFormIndicateur() {
    setState(() {
      _count = _count + 1;
    });
  }
}

class FormIndicateur extends StatefulWidget {
  final int indice;

  FormIndicateur(this.indice, {Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => new _FormIndicateur();
}

class _FormIndicateur extends State<FormIndicateur> {
  String value_type = "";
  String value_recurrence = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    types.add("");
    recurrences.add("");
    return new Center(
      child: Container(
        child: SizedBox(
          width: 300,
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration:
                        InputDecoration(hintText: "Nom de l'indicateur"),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Champ obligatoire';
                      } else {
                        print(value);
                        noms.add(value);
                      }
                    },
                  ),
                  DropDownFormField(
                    titleText: 'Frequence',
                    hintText: 'Choississez la recurrence',
                    value: value_recurrence,
                    onSaved: (value) {
                      setState(() {
                        recurrences[widget.indice - 1] = value;
                        value_recurrence = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        recurrences[widget.indice - 1] = value;
                        value_recurrence = value;
                      });
                    },
                    validator: (value) =>
                        value == "" ? 'Champ obligatoire' : null,
                    dataSource: [
                      {
                        "display": "Jour",
                        "value": "Jour",
                      },
                      {
                        "display": "Semaine",
                        "value": "Semaine",
                      },
                      {
                        "display": "Mois",
                        "value": "Mois",
                      },
                    ],
                    textField: 'display',
                    valueField: 'value',
                  ),
                  DropDownFormField(
                    titleText: 'Type',
                    hintText: 'Choississez un type',
                    value: value_type,
                    onSaved: (value) {
                      setState(() {
                        types[widget.indice - 1] = value;
                        value_type = value;
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        types[widget.indice - 1] = value;
                        value_type = value;
                      });
                    },
                    validator: (value) {
                      if (value == "") {
                        return 'Champ obligatoire';
                      }
                    },
                    dataSource: [
                      {
                        "display": "Nombre",
                        "value": "Nombre",
                      },
                      {
                        "display": "Texte",
                        "value": "Texte",
                      },
                    ],
                    textField: 'display',
                    valueField: 'value',
                  ),

                  /*RaisedButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    onPressed: () {},
                    child: Text('Valider la creation'),
                  ),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
