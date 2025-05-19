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

    if(!_loadingPenname)
      return;

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

    print(todayText);
    print(_loadingPenname);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Calendar", style: TextStyle(fontSize: 28, color: CupertinoColors.white)),
        centerTitle: true,
        backgroundColor: Colors.brown,
        elevation: 1,
      ),
      body: _loadingPenname
          ? const Center(child: CircularProgressIndicator())
          : Container(
        decoration: const BoxDecoration(
          color: Colors.white
        ),
        child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 10, 16.0, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             SizedBox(height: 20),
            Center(child: Text(todayText, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w500)),)
            ,
             SizedBox(height: 20),
            TableCalendar(
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
                  color: Colors.orange.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: false, // hides the button completely
              ),
            ),
            SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.only(left: 16.0),  // Adjust the padding value as needed
              child: Text(
                "Entries",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: _penname == null || _loadingPenname
                  ? const Center(child: CircularProgressIndicator())
                  : FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('whispyr_journal_entries')
                    .where('user', isEqualTo: _penname)
                    .where('date', isGreaterThanOrEqualTo: DateTime(
                  _selectedDay!.year,
                  _selectedDay!.month,
                  _selectedDay!.day,
                ))
                    .where('date', isLessThan: DateTime(
                  _selectedDay!.year,
                  _selectedDay!.month,
                  _selectedDay!.day + 1,
                ))
                    .orderBy('date', descending: true)
                    .limit(10)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print("has data: ${snapshot.hasData}, con state: ${snapshot.connectionState}");
                    return Center(child: CircularProgressIndicator(color: Colors.orange,));
                  }


                  final entries = snapshot.hasData ? snapshot.data!.docs : [];


                  print("entries ${entries}");

                  if (entries.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text("No Entries yet", style: TextStyle(fontSize: 20)),
                    );
                  }

                  return ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      final timestamp = entry['date'] as Timestamp;
                      final date = DateFormat('MMM dd, yyyy').format(timestamp.toDate());

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
                            DateFormat('yyyy, MM dd | HH:mm').format(entry['date'].toDate()),
                            style: const TextStyle(fontSize: 12, color: Colors.white70),
                          ),
                          subtitle: Text(
                            entry['title'],
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          onTap: () {
                            //redirect to view page from here, use entry.id to fetch specific document/record
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
      ),)
    );
  }
}
