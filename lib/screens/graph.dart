import 'package:flutter/material.dart';
import 'package:loader/loader.dart';
import 'package:planlife/class/indicateur.dart';
import 'package:planlife/class/journal.dart';
import 'package:planlife/database/databasehelper.dart';
import 'package:planlife/screens/lineGraph.dart';

class Graph extends StatefulWidget {
  final List<List<TimeSeriesSales>> dataTEST;
  final List<Indicateur> indicateurs;
  Graph(this.dataTEST, this.indicateurs, {Key key}) : super(key: key);
  @override
  _Graph createState() => _Graph();
}

class _Graph extends State<Graph> {
  var dbHelper;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    print(widget.indicateurs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Graphique"),
        ),
        actions: <Widget>[],
      ),
      body: Center(
        child: Column(children: <Widget>[
          Text(widget.indicateurs[0].nom),
          Container(
            child: Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SimpleTimeSeriesChart.withSampleData(widget.dataTEST[0]),
              ),
            ),
          ),
          /*Text(widget.indicateurs[1].nom),
          Container(
            child: Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SimpleTimeSeriesChart.withSampleData(widget.dataTEST[1]),
              ),
            ),
          ),*/
        ]),
      ),
    );
  }
}
/*
          */
