
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';


// void main()  {
//   WidgetsFlutterBinding.ensureInitialized();
//   Firebase.initializeApp(); //start connection
//   runApp(MyApp());
//
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false, // Optionally remove the debug banner
//       home: CreateWhysper(), // Your home screen widget
//     );
//   }
// }

class Sample extends StatefulWidget {

  final String title;

  const Sample({super.key, required this.title});

  @override
  _SamplerState createState() => _SamplerState();
}

class _SamplerState extends State<Sample> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(fontSize: 24, color: CupertinoColors.black),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 5, 24.0, 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
]
        ),
      ),
    );
  }
}
