
import 'package:flutter/material.dart';
import 'package:livebuzz/splash_screen.dart';
import 'package:livebuzz/sports.dart';


import 'package:livebuzz/LoginPage.dart';
import 'package:livebuzz/news.dart';

import 'package:livebuzz/TablesPage.dart';
void main() {
  runApp(LiveBuzzApp());
}

class LiveBuzzApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sporion',
      home: SplashScreen(), // Set SplashScreen as the initial screen.
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
    // Navigate to LiveBuzzHomePage after 3 seconds.
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LiveBuzzHomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent, // Background color for splash screen.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo or placeholder icon
            Icon(
              Icons.sports_cricket_outlined,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            // App name
            Text(
              'Sporion',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            // Loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class LiveBuzzHomePage extends StatefulWidget {
  @override
  _LiveBuzzHomePageState createState() => _LiveBuzzHomePageState();
}



class _LiveBuzzHomePageState extends State<LiveBuzzHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    HomePageContent(),
    SportsPage(),
    Center(child: Text('Table Page', style: TextStyle(fontSize: 24))), // Placeholder for TablesPage
    NewsPage(),
  ];

  void _onItemTapped(int index) {
    if (index == 1) { // Navigate to SportsPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SportsPage()),
      );
    } else if (index == 2) { // Navigate to TablesPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TablesPage()),
      );
    } else if (index == 3) { // Navigate to NewsPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NewsPage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Text(
          'Sporion',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text('Log In', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_volleyball_rounded), label: 'Sports'),
          BottomNavigationBarItem(icon: Icon(Icons.point_of_sale_rounded), label: 'Tables'),
          BottomNavigationBarItem(icon: Icon(Icons.view_comfortable), label: 'Statistics'),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}

// TablesPage Widget
/*class TablesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tables Page')),
      body: Center(child: Text('This is the Tables Page', style: TextStyle(fontSize: 24))),
    );
  }
}*/

// 📌 Home Page Content with Live and Upcoming Matches
class HomePageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔴 LIVE MATCHES SECTION
            Text(
              '🔴 Live Matches',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildMatchList(isLive: true), // Live Matches

            SizedBox(height: 20), // Space between sections

            // ⏳ UPCOMING MATCHES SECTION
            Text(
              '⏳ Upcoming Matches',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildMatchList(isLive: false), // Upcoming Matches
          ],
        ),
      ),
    );
  }

  // 🏏🏀🏐 FUNCTION TO GENERATE MATCH LIST (LIVE OR UPCOMING)
  static Widget _buildMatchList({required bool isLive}) {
    List<Map<String, String>> matches = [
      {"sport": "Cricket", "teams": "Team A vs Team B", "time": "10:30 AM"},
      {"sport": "Basketball", "teams": "Lakers vs Bulls", "time": "12:00 PM"},
      {"sport": "Volleyball", "teams": "Team X vs Team Y", "time": "2:00 PM"},
    ];

    return Column(
      children: matches.map((match) {
        return _buildMatchCard(
          sport: match["sport"]!,
          teams: match["teams"]!,
          time: match["time"]!,
          isLive: isLive,
        );
      }).toList(),
    );
  }

  // 🎟 MATCH CARD WIDGET
  static Widget _buildMatchCard(
      {required String sport,
        required String teams,
        required String time,
        required bool isLive}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(
          Icons.sports,
          color: isLive ? Colors.red : Colors.grey, // Red for live matches
          size: 30,
        ),
        title: Text(
          sport,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(teams, style: TextStyle(fontSize: 16)),
            SizedBox(height: 5),
            Text(isLive ? 'LIVE 🔴' : 'Starts at: $time',
                style: TextStyle(
                    fontSize: 14,
                    color: isLive ? Colors.red : Colors.black54,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 20),
        onTap: () {
          // Action when match card is tapped
        },
      ),
    );
  }
}


class BlankPage extends StatelessWidget {
  _buildContent(){

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Date Selector Row
          Container(
            color: Colors.grey[900],
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDateButton("Yesterday"),
                _buildDateButton("Today"),
                _buildDateButton("Tomorrow"),
              ],
            ),
          ),
          _buildContent(),
          // Content related to the selected date

        ],
      ),
    );
  }

  _buildDateButton(String s) {}
}


