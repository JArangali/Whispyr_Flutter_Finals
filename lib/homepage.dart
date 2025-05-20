import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fl2_arangali/AllEntriesPage.dart';
import 'package:fl2_arangali/view_entry.dart';


void main() {
  runApp(WhispyrApp());
}

class WhispyrApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whispyr',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color green = Color(0xFF9FC088);
  final Color yellow = Color(0xFFE8C07D);
  final Color orange = Color(0xFFCC704B);
  final Color brown = Color(0xFF614124);
  String penName = '';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DateFormat _dateFormat = DateFormat('dd MMMM yyyy');

  @override
  void initState() {
    super.initState();
    _loadPenName();
  }

  Future<void> _loadPenName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      penName = prefs.getString('penName') ?? '';
    });
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good morning,';
    } else if (hour >= 12 && hour < 18) {
      return 'Good afternoon,';
    } else {
      return 'Good evening,';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF8F4E1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(getGreeting(),
                      style: TextStyle(fontSize: 16, color: brown)),
                ],
              ),
              SizedBox(height: 6),
              Text('$penName!',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: brown)),
              SizedBox(height: 20),

              // Mood of the Day Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: yellow,
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
                        Text('Mood of the Day',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: brown)),
                        SizedBox(width: 8),
                        Text('🌿', style: TextStyle(fontSize: 20)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Peaceful & Grounded',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: brown),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Take a moment to breathe and appreciate the little things.',
                      style: TextStyle(
                          fontSize: 13,
                          color: brown.withOpacity(0.85),
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Quick Tips Title
              Text('Quick Tips',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: brown)),
              SizedBox(height: 8),

              // Quick Tips Cards
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: orange,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: orange.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lightbulb_outline, color: Colors.white, size: 28),
                          SizedBox(height: 6),
                          Text("Write Freely",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 14)),
                          SizedBox(height: 4),
                          Text("Don't overthink—just express your thoughts.",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: green,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: green.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.nightlight_round, color: brown, size: 28),
                          SizedBox(height: 6),
                          Text("Night Reflection",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: brown,
                                  fontSize: 14)),
                          SizedBox(height: 4),
                          Text("Reflecting before bed helps clear your mind.",
                              style: TextStyle(
                                  color: brown.withOpacity(0.8),
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Quote of the Day Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: green,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: green.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quote of the Day',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: brown)),
                    SizedBox(height: 8),
                    Text(
                      '"The secret of getting ahead is getting started."',
                      style: TextStyle(
                          fontStyle: FontStyle.italic, fontSize: 14, color: brown),
                    ),
                    SizedBox(height: 6),
                    Text('- Mark Twain',
                        style: TextStyle(fontSize: 12, color: brown.withOpacity(0.7))),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Journal Entries Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Entries',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: brown)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AllEntriesPage()),
                      );
                    },
                    child: Text('See All',
                        style: TextStyle(
                            color: orange,
                            fontWeight: FontWeight.bold)),
                  ),

                ],
              ),
              SizedBox(height: 10),

              // Journal Entries from Firestore
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('whispyr_journal_entries')
                      .where('user', isEqualTo: penName)
                      .orderBy('date', descending: true)
                      .limit(10)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text('No entries yet',
                            style: TextStyle(color: brown)),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var entry = snapshot.data!.docs[index];
                        var entryData = entry.data() as Map<String, dynamic>;
                        var date = (entryData['date'] as Timestamp).toDate();

                        return GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewEntryPage(entry: entry),
                              ),
                            );
                            setState(() {}); // Refresh list after viewing
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 12),
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: brown.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                Text('📓', style: TextStyle(fontSize: 26)),
                                SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(entryData['title'] ?? 'Untitled',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: brown)),
                                    SizedBox(height: 4),
                                    Text(_dateFormat.format(date),
                                        style: TextStyle(fontSize: 12, color: Colors.brown)),
                                  ],
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
                              ],
                            ),
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
      ),
    );
  }
}