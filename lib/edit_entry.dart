import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditEntryPage extends StatefulWidget {
  final DocumentSnapshot entry;

  const EditEntryPage({Key? key, required this.entry}) : super(key: key);

  @override
  State<EditEntryPage> createState() => _EditEntryPageState();
}

class _EditEntryPageState extends State<EditEntryPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _storyController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.entry['title'] ?? '';
    _storyController.text = widget.entry['story'] ?? '';
    Timestamp timestamp = widget.entry['date'];
    _selectedDate = timestamp.toDate();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_titleController.text.isEmpty || _storyController.text.isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    await FirebaseFirestore.instance
        .collection('whispyr_journal_entries')
        .doc(widget.entry.id)
        .update({
      'title': _titleController.text,
      'story': _storyController.text,
      'date': Timestamp.fromDate(_selectedDate!),
    });

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    String displayDate = DateFormat('EEEE, dd MMMM yyyy').format(_selectedDate!);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Entry'),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Row(
              children: [
                Text(displayDate, style: TextStyle(fontSize: 16, color: Colors.orange)),
                IconButton(
                  icon: Icon(Icons.calendar_today, color: Colors.orangeAccent),
                  onPressed: _pickDate,
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Title', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextField(
              controller: _titleController,
              maxLength: 50,
              maxLines: 2,
              decoration: InputDecoration(hintText: 'Edit the title'),
            ),
            SizedBox(height: 20),
            Text('Story', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextField(
              controller: _storyController,
              maxLength: 500,
              maxLines: 10,
              decoration: InputDecoration(hintText: 'Edit your story'),
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: Text('Save Changes', style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
