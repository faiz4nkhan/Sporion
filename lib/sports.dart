import 'package:flutter/material.dart';
import 'package:livebuzz/Games/BasketballPage.dart';
import 'package:livebuzz/Games/CricketScorePage.dart';
import 'package:livebuzz/Games/FootballScorePage.dart';
import 'package:livebuzz/Games/Kabbadi.dart';
import 'package:livebuzz/Games/noticeboard.dart';
import 'package:livebuzz/ResultPage.dart';
import 'package:livebuzz/Games/TennisScorePage.dart';
import 'package:livebuzz/Games/VolleyballScorePage.dart';
import 'package:livebuzz/global.dart';
import 'package:livebuzz/main.dart';

import 'Games/khokho.dart';

class SportsPage extends StatelessWidget {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    Center(child: Text('Home Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Sports Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Table Page', style: TextStyle(fontSize: 24))),
    Center(child: Text('Statistics Page', style: TextStyle(fontSize: 24))),
  ];

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
    {
      'name':'Kho-Kho',
      'image':'assets/images/kho-kho.jpeg'
    },
    {
      'name':'Kabbadi',
      'image':'assets/images/kabbadi.jpeg'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sports'),
        backgroundColor: Colors.white,
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
                      builder: (context) => BasketballPage(isLoggedIn: true, isAdmin: isAdmin),
                    ),
                  );
                } else if (sports[index]['name'] == 'Cricket') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Cricketscorepage(isLoggedIn: true,isAdmin : isAdmin),
                    ),
                  );
                } else if (sports[index]['name'] == 'Volleyball') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VolleyballScorePage(isLoggedIn: true,isAdmin: isAdmin),
                    ),
                  );
                } else if (sports[index]['name'] == 'Football') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FootballScorePage(isAdmin: isAdmin),
                    ),
                  );
                } else if (sports[index]['name'] == 'Tennis') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Tennisscorepage(isLoggedIn: true, isAdmin: isAdmin), // Navigate to TennisScorePage
                    ),
                  );
                }
                else if (sports[index]['name'] == 'Kho-Kho') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KhokhoPage(isLoggedIn: true, isAdmin: isAdmin), // Navigate to TennisScorePage
                    ),
                  );
                } if (sports[index]['name'] == 'Kabbadi') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Kabbadi(), // Navigate to TennisScorePage
                    ),
                  );
                } else {
                  print('${sports[index]['name']} is not available');
                }
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,

        items: [
          BottomNavigationBarItem(
            icon:  InkWell(child: Icon(Icons.home),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LiveBuzzHomePage()),);},),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: InkWell(child: Icon(Icons.sports_volleyball_rounded),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SportsPage()),);},),

            label: 'Sports',),
           BottomNavigationBarItem(
            icon: InkWell(child: Icon(Icons.notifications),
              onTap: (){
    Navigator.push(context, MaterialPageRoute(builder: (context) => NoticeBoardScreen(isLoggedIn: true,isAdmin: isAdmin)),);},),


            label: 'Tables',
          ),
          BottomNavigationBarItem(
            icon: InkWell(child: Icon(Icons.view_comfortable),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(isLoggedIn: true,isAdmin:isAdmin)),);},),

            label: 'Result',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
      ),

    );
  }
}