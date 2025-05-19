import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_entry.dart';

class ViewEntryPage extends StatefulWidget {
  final DocumentSnapshot entry;

  const ViewEntryPage({Key? key, required this.entry}) : super(key: key);

  @override
  _ViewEntryPageState createState() => _ViewEntryPageState();
}

class _ViewEntryPageState extends State<ViewEntryPage> {
  late DocumentSnapshot _entry;

  @override
  void initState() {
    super.initState();
    _entry = widget.entry;
  }

  Future<void> _refreshEntry() async {
    final updated = await FirebaseFirestore.instance
        .collection('whispyr_journal_entries')
        .doc(widget.entry.id)
        .get();
    setState(() {
      _entry = updated;
    });
  }

  Future<void> _deleteEntry(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Entry"),
        content: Text("Are you sure you want to delete this journal entry?"),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text("Cancel")),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text("Delete")),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('whispyr_journal_entries')
          .doc(_entry.id)
          .delete();

      Navigator.pop(context); // Go back after delete
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _entry['title'];
    final story = _entry['story'];
    final date = (_entry['date'] as Timestamp).toDate();

    return Scaffold(
      appBar: AppBar(
        title: Text("Your Entry"),
        backgroundColor: Colors.brown,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditEntryPage(entry: _entry),
                ),
              );

              if (result == true) {
                await _refreshEntry(); // Refresh the entry if it was updated
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteEntry(context); // This already includes the confirmation dialog
            },
          ),

        ],
      ),
      body: Container(
        width: double.infinity, // Ensures the white background fills full width
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              date.toString(),
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  story,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
