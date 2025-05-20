import 'package:fl2_arangali/AllEntriesPage.dart';
import 'package:fl2_arangali/calendar.dart';
import 'package:fl2_arangali/create_whyspr.dart';
import 'package:fl2_arangali/homepage.dart';
import 'package:fl2_arangali/sampler.dart';
import 'package:fl2_arangali/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  // Hide the system UI (status bar and navigation bar)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const mainPage());
}


class mainPage extends StatelessWidget {
  const mainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SplashScreen()
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // If logged in, navigate to the main screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } else {
      // If not logged in, navigate to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // You can show a loading indicator while checking the login status
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
class MainScreen extends StatefulWidget {
  final int? index;

  const MainScreen({Key? key, this.index}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    // If widget.index is provided, use it, otherwise default to 0
    _selectedIndex = widget.index ?? 1;
  }

  //place pages here
  final List<Widget> _pages = [
    WhispyrApp(), // Home page
    CalendarPage(), // Calendar page
    AllEntriesPage(), // View page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _goToCreateWhysper() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateWhysper()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 0.0), // Padding at the bottom
        child: BottomNavigationBar(
          backgroundColor: Colors.brown,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: (int index) async {

            print(index);
            int newIndex = index >= 2 ? 2 : index;

            print("selected: $index, modified: $newIndex");

            if (index == 4) {
              print("Sign out");

              final prefs = await SharedPreferences.getInstance();

              await prefs.clear();


              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                    (Route<dynamic> route) => false,
              );
              return;
            }
            setState(() {
              _selectedIndex = newIndex;
            });


          },
          iconSize: 30.0, // Make the icons larger
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '', // Empty label
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: '', // Empty label
            ),
            BottomNavigationBarItem(
              icon: SizedBox.shrink(), // Placeholder for FAB
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '', // Empty label
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lock),
              label: '', // Empty label
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 72,  // Increase height
        width: 72,   // Increase width
        child: FloatingActionButton(
          onPressed: _goToCreateWhysper,
          backgroundColor: Colors.orangeAccent,
          child: Icon(Icons.edit, size: 36, color: Colors.white), // Larger icon
          shape: const CircleBorder(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
// Center the FAB
    );
  }
}
