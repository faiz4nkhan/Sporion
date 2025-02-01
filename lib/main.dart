
import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'package:livebuzz/sports.dart'; // Ensure the correct import
import 'package:livebuzz/LoginPage.dart';
void main() {
  runApp(LiveBuzzApp());
}

class LiveBuzzApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LiveBuzz',
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
              Icons.flash_on,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            // App name
            Text(
              'LiveBuzz',
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
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Home Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Sports  Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Table Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Statistics Page', style: TextStyle(fontSize: 24))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // LiveBuzz Logo (Placeholder Text)
            Text(
              'LiveBuzz',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
        onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
    );

            },
            child: Text(
              'Log In',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) { // Check if the Sports tab is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SportsPage(), // Navigate to the BlankPage
              ),
            );
          } else {
            setState(() {
              _selectedIndex = index; // Update the selected index for other tabs
            });
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_volleyball_rounded),
            label: 'Sports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.point_of_sale_rounded),
            label: 'Tables',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_comfortable),
            label: 'Statistics',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}

class BlankPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Sports '),
      ),
      body: Center(
        child: Text(
          'This is a blank page for Sports',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
