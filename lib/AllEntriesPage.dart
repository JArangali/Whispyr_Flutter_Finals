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
  final Color green = Color(0xFF9FC088);
  final Color yellow = Color(0xFFE8C07D);
  final Color orange = Color(0xFFCC704B);
  final Color brown = Color(0xFF614124);


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
      backgroundColor: const Color(0xFFF6F1E7),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          "All Entries",
          style: TextStyle(
            fontSize: 28,
            color: CupertinoColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.brown,
        elevation: 1,
      ),
      body: _loadingPenname
          ? const Center(
        child: CircularProgressIndicator(
          color: Colors.orangeAccent,
          strokeWidth: 4,
        ),
      )
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0.0, bottom: 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8BC7C),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: yellow.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Mood of the Day',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: brown,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('📝', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Reflect & Record',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: brown,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Capture your thoughts and feelings today—every detail matters.',
                      style: TextStyle(
                        fontSize: 13,
                        color: brown.withOpacity(0.85),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),


            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('whispyr_journal_entries')
                    .where('user', isEqualTo: _penname)
                    .orderBy('date', descending: true)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.orangeAccent,
                        strokeWidth: 4,
                      ),
                    );
                  }

                  final entries = snapshot.hasData ? snapshot.data!.docs : [];

                  if (entries.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        "No entries found.",
                        style: TextStyle(fontSize: 20, color: Colors.brown),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      final timestamp = entry['date'] as Timestamp;

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white, // White background for tile
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.brown.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            DateFormat('yyyy, MM dd | HH:mm').format(timestamp.toDate()),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.brown,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            entry['title'],
                            style: const TextStyle(
                              color: Colors.brown,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewEntryPage(entry: entry),
                              ),
                            );
                            setState(() {}); // Refresh list after viewing
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
