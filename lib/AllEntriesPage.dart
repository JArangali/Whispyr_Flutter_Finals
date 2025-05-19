import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:fl2_arangali/view_entry.dart';

class AllEntriesPage extends StatefulWidget {
  const AllEntriesPage({super.key});

  @override
  _AllEntriesPageState createState() => _AllEntriesPageState();
}

class _AllEntriesPageState extends State<AllEntriesPage> {
  String? _penname;
  bool _loadingPenname = true;

  @override
  void initState() {
    super.initState();
    _loadPenname();
  }

  Future<void> _loadPenname() async {
    final prefs = await SharedPreferences.getInstance();
    final storedPenname = prefs.getString('penName');

    setState(() {
      _penname = storedPenname;
      _loadingPenname = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("All Entries", style: TextStyle(fontSize: 28, color: CupertinoColors.white)),
        centerTitle: true,
        backgroundColor: Colors.brown,
        elevation: 1,
      ),
      body: _loadingPenname
          ? const Center(child: CircularProgressIndicator())
          : Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                "All Your Journal Entries",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('whispyr_journal_entries')
                    .where('user', isEqualTo: _penname)
                    .orderBy('date', descending: true)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.orange));
                  }

                  final entries = snapshot.hasData ? snapshot.data!.docs : [];

                  if (entries.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text("No entries found.", style: TextStyle(fontSize: 20)),
                    );
                  }

                  return ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      final timestamp = entry['date'] as Timestamp;

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            DateFormat('yyyy, MM dd | HH:mm').format(timestamp.toDate()),
                            style: const TextStyle(fontSize: 12, color: Colors.white70),
                          ),
                          subtitle: Text(
                            entry['title'],
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewEntryPage(entry: entry),
                              ),
                            );
                            setState(() {}); // <-- This triggers a rebuild and re-fetches entries
                          },

                        ),
                      );
                    },
                  );

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
