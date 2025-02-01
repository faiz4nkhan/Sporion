import 'package:flutter/material.dart';
import 'package:livebuzz/CricketScorePage.dart';
import 'package:livebuzz/BasketballPage.dart';// Ensure this import is needed

// Sports Page
class SportsPage extends StatelessWidget {
  final List<Map<String, String>> sports = [
    {
      'name': 'Basketball',
      'image': 'assets/images/basketball-hoop-with-blue-sky.jpg',
    },
    {
      'name': 'Cricket',
      'image': 'assets/images/cricket-bat-ball-foreground-pitch.jpg',
    },
    {
      'name': 'Volleyball',
      'image': 'assets/images/vollyball.jpg',
    },
    {
      'name': 'Football',
      'image': 'assets/images/football.jpg',
    },
    {
      'name': 'Tennis',
      'image': 'assets/images/tt.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sports'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: sports.length,
        itemBuilder: (context, index) {
          String imagePath = sports[index]['image'] ?? 'assets/default_logo.png';

          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              leading: CircleAvatar(
                backgroundImage: AssetImage(imagePath),
                radius: 30,
              ),
              title: Text(
                sports[index]['name'] ?? 'No Name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                if (sports[index]['name'] == 'Basketball') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BasketballPage(isLoggedIn: true),

                    ),
                  );
                } else if (sports[index]['name'] == 'Cricket') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CricketScorePage(), // Navigate to CricketScorePage
                    ),
                  );
                } else {
                  print('${sports[index]['name']} tapped');
                }
              },
            ),
          );
        },
      ),
    );
  }
}
