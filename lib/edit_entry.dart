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
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: const Color(0xFF614124), // deep brown for header
            onPrimary: Colors.white,          // text color on header
            onSurface: const Color(0xFF614124), // brown for dates
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF614124), // brown for buttons
            ),
          ),
        ),
        child: child!,
      ),
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
        const SnackBar(
          content: Text('Please complete all fields'),
          backgroundColor: Color(0xFF614124), // brown snackbar
        ),
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
      backgroundColor: const Color(0xFFFDF6EC), // soft cream background
      appBar: AppBar(
        title: const Text(
          'Edit Entry',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF614124), // deep brown
        centerTitle: true,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Row(
              children: [
                Text(
                  displayDate,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF9FC088), // a calm green
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  color: const Color(0xFF9FC088),
                  onPressed: _pickDate,
                  tooltip: 'Pick Date',
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Title',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF614124),
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _titleController,
              maxLength: 50,
              maxLines: 2,
              style: const TextStyle(color: Color(0xFF614124)),
              decoration: InputDecoration(
                hintText: 'Edit the title',
                hintStyle: TextStyle(color: Colors.brown.shade300),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Story',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF614124),
              ),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: _storyController,
              maxLength: 500,
              maxLines: 10,
              style: const TextStyle(color: Color(0xFF614124)),
              decoration: InputDecoration(
                hintText: 'Edit your story',
                hintStyle: TextStyle(color: Colors.brown.shade300),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF614124),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
