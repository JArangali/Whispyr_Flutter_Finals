
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl2_arangali/main.dart';

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

class CreateWhysper extends StatefulWidget {
  @override
  _CreateWhysperState createState() => _CreateWhysperState();
}

class _CreateWhysperState extends State<CreateWhysper> {
  final TextEditingController _titleTextController = TextEditingController();

  final TextEditingController _storyTextController = TextEditingController();

  String? userKey;


  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadPenname();
  }

  Future<void> _loadPenname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userKey = prefs.getString('penName') ?? '';
    });
  }

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
    else {
      setState(() {
        _selectedDate = DateTime.now();
      });
    }
  }

  void _submitEntry() async {
    if (_titleTextController.text.isEmpty || _storyTextController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please make you that your Whyspr is complete')),
      );
      return;
    }

    if ( _selectedDate == null ) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a date')),
      );
      return;
    }

    print({
      'user': userKey,
      'title': _titleTextController.text,
      'story': _storyTextController.text,
      'date': Timestamp.fromDate(_selectedDate!),
    });


    await FirebaseFirestore.instance.collection('whispyr_journal_entries').add({
      'user': userKey,
      'title': _titleTextController.text,
      'story': _storyTextController.text,
      'date': Timestamp.fromDate(_selectedDate!),
    });

    setState(() {
      _titleTextController.clear();
      _storyTextController.clear();
      _selectedDate = null;
    });

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Whysper added to your journal!')),
    // );


    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Whysper added to your journal!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen(index: 1,)), // Use the LoginPage widget directly
                );
              },
              child: Text('Yay!'),
            ),
          ],
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {


    String displayDate = _selectedDate != null
        ? DateFormat('EEEE, dd MMMM yyyy').format(_selectedDate!)
        : DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now());

    print("$userKey during ${DateFormat('EEEE, dd MMMM yyyy').format(DateTime.now())}");

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Entry', style: TextStyle(fontSize: 24, color: CupertinoColors.white),),
        centerTitle: true,
        backgroundColor: Colors.brown,
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.close, size: 30,),
        //     onPressed: () {
        //
        //       print('Pop this page');
        //
        //       //Navigator.pop(context); // This will pop the page when the "X" button is pressed
        //     },
        //   ),
        // ],
      ),
      body: Container(
        child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 5, 24.0, 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Row(
              children: [
                Text(displayDate, style: TextStyle(fontSize: 16, color: Colors.orange),),
                SizedBox(width: 4),
                IconButton(
                  onPressed: _pickDate,
                  icon: Icon(Icons.calendar_today, color: Colors.orangeAccent,),
                ),
              ],
            ),

            SizedBox(height: 16.0),
            Text('Title', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.fromLTRB(3.0, 0.0, 0.0, 0.0),
              child:TextField(
                controller: _titleTextController,
                maxLines: 2,
                maxLength: 50,
                decoration: InputDecoration(
                  hintText: 'Add a title to this entry',
                  hintStyle: TextStyle(color: CupertinoColors.inactiveGray),
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 20),
              ),
            ),

            SizedBox(height: 30.0),
            Text('Story', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.fromLTRB(3.0, 0.0, 0.0, 0.0),
              child:TextField(
                controller: _storyTextController,
                maxLines: 10,
                maxLength: 500,
                decoration: InputDecoration(
                  hintText: 'Write something',
                  hintStyle: TextStyle(color: CupertinoColors.inactiveGray),
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 20),
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: _submitEntry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown, // Set the background color to orange
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 36.0),
                ),
                child: Text('Submit', style:  TextStyle(fontSize: 24,color: Colors.white, fontWeight: FontWeight.bold),),
              ),
            ),
            SizedBox(height: 30.0),
          ],
        ),
      ),)
    );
  }
}
