import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl2_arangali/main.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    } else {
      setState(() {
        _selectedDate = DateTime.now();
      });
    }
  }

  void _submitEntry() async {
    if (_titleTextController.text.isEmpty || _storyTextController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please make sure that your Whysper is complete')),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a date')),
      );
      return;
    }

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

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Success'),
          content: Text('Whysper added to your journal!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen(index: 1)),
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

    return Scaffold(
      backgroundColor: Color(0xFFFDF6EC),
      appBar: AppBar(
        title: Text('Create Entry', style: TextStyle(fontSize: 24, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color(0xFF614124),
        elevation: 3,
      ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Picker Row
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Color(0xFFCC704B), size: 16), // reduced from 20 → 16
                    SizedBox(width: 6), // reduced from 8 → 6
                    Text(
                      displayDate,
                      style: TextStyle(
                        fontSize: 14, // reduced from 16 → 14
                        color: Color(0xFFCC704B),
                        fontWeight: FontWeight.w500, // slightly lighter
                      ),
                    ),
                    Spacer(),
                    ElevatedButton.icon(
                      onPressed: _pickDate,
                      icon: Icon(Icons.edit_calendar, size: 16), // reduced from 18 → 16
                      label: Text(
                        "Change",
                        style: TextStyle(fontSize: 13), // added to shrink label text
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF9FC088),
                        foregroundColor: Colors.black87,
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6), // reduced padding
                        textStyle: TextStyle(fontSize: 13), // for internal consistency
                      ),
                    ),
                  ],
                ),


                SizedBox(height: 24.0),

                // Title
                Text('Title', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF614124))),
                SizedBox(height: 8),
                TextField(
                  controller: _titleTextController,
                  maxLength: 50,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFE8C07D).withOpacity(0.2),
                    hintText: 'Add a title to this entry',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),

                SizedBox(height: 16),

                // Story
                Text('Story', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF614124))),
                SizedBox(height: 8),
                TextField(
                  controller: _storyTextController,
                  maxLines: null,
                  minLines: 6,
                  maxLength: 500,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFE8C07D).withOpacity(0.15),
                    hintText: 'Write something from your heart...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.all(16),
                  ),
                ),

                SizedBox(height: 16),

                Center(
                  child: ElevatedButton(
                    onPressed: _submitEntry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFCC704B),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

    );
  }
}
