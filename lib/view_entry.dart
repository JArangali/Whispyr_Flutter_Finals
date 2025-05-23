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
        title: const Text("Delete Entry"),
        content: const Text("Are you sure you want to delete this journal entry?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
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
    final title = _entry['title'] ?? '';
    final story = _entry['story'] ?? '';
    final date = (_entry['date'] as Timestamp).toDate();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F1E7), // warm beige background
      appBar: AppBar(
        title: const Text(
          "Your Entry",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.brown,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Entry',
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditEntryPage(entry: _entry),
                ),
              );

              if (result == true) {
                await _refreshEntry(); // Refresh the entry if updated
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete Entry',
            onPressed: () {
              _deleteEntry(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.brown.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                // Format date to a nicer string
                '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.brown.shade300,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    story,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.brown,
                      height: 1.4,
                    ),
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
