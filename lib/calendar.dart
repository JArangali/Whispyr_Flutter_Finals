import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
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
    String todayText = "Today is ${DateFormat('MMM dd').format(DateTime.now())}";

    return Scaffold(
      backgroundColor: const Color(0xFFFDF6EC), // soft cream background
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Calendar",
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF614124), // deep brown
        elevation: 1,
      ),
      body: _loadingPenname
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text(
                todayText,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF614124),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFFFFF4DE),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TableCalendar(
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.utc(2100, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: const Color(0xFF9FC088).withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: Color(0xFF9FC088),
                      shape: BoxShape.circle,
                    ),
                    weekendTextStyle: TextStyle(color: Colors.redAccent),
                    todayTextStyle: TextStyle(color: Colors.white),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Entries",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF614124),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('whispyr_journal_entries')
                    .where('user', isEqualTo: _penname)
                    .where('date', isGreaterThanOrEqualTo: DateTime(
                  _selectedDay.year,
                  _selectedDay.month,
                  _selectedDay.day,
                ))
                    .where('date', isLessThan: DateTime(
                  _selectedDay.year,
                  _selectedDay.month,
                  _selectedDay.day + 1,
                ))
                    .orderBy('date', descending: true)
                    .limit(10)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.orange));
                  }

                  final entries = snapshot.hasData ? snapshot.data!.docs : [];

                  if (entries.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "No Entries yet",
                        style: TextStyle(fontSize: 20, color: Colors.grey),
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
                          color: const Color(0xFFCC704B),
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                          title: Text(
                            DateFormat('MMM dd, yyyy | HH:mm').format(timestamp.toDate()),
                            style: const TextStyle(fontSize: 12, color: Colors.white70),
                          ),
                          subtitle: Text(
                            entry['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          onTap: () {
                            // Handle navigation to full entry view
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Tapped on '${entry.id}'")),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
