import 'package:flutter/material.dart';
import 'package:planlife/screens/accueil.dart';
import 'package:planlife/screens/connexion.dart';
import 'package:planlife/screens/graph.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlanLife',
      theme: ThemeData(primarySwatch: Colors.green),
      home: Connexion(),
    );
  }
}
