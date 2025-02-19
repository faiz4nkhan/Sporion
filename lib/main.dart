
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';// Ensure the correct import
import 'package:livebuzz/Games/BasketballPage.dart';
import 'package:livebuzz/Games/CricketScorePage.dart';
import 'package:livebuzz/Games/Kabbadi.dart';
import 'package:livebuzz/Games/khokho.dart';
import 'package:livebuzz/LoginPage.dart';
import 'package:livebuzz/Games/VolleyballScorePage.dart';
import 'package:livebuzz/sports.dart';

import 'Games/noticeboard.dart';
import 'global.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  runApp(LiveBuzzApp());
}
class LiveBuzzApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SPORION',
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
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LiveBuzzHomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent, // Background color for splash screen.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo or placeholder icon
            Image.asset("assets/images/ball.png",color: Colors.white,),
//Image(image: AssetImage("assets/images/ball.png",)),
            SizedBox(height: 20),
            // App name
            Text(
              "SPORION'25",
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
        backgroundColor: Colors.white,
        elevation: 0,
        /*  leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),*/
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [//SizedBox(width: 50,),
            // LiveBuzz Logo (Placeholder Text)
            Center(
              child: Text(
                'SPORION',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
    actions: [
    if (!isLoggedIn) // Only show if user is NOT logged in
    TextButton(
    onPressed: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
    );
    },
    child: Text(
    'Log In',
    style: TextStyle(color: Colors.black),
    ),
    ),
    ],
      ),
    body: SingleChildScrollView(
        child: Column(
          children: [
            Container( width:double.infinity, // Or any other specific size
              height: 400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/logoSporian.png"), // Provide your image asset path here
                  fit: BoxFit.cover, // You can adjust the fit (cover, contain, fill, etc.)
                ),
              ),
              child: Center(
                child: Column(
                  children: [SizedBox(height: 100,),
                    //Text("Sporion 2025",style: TextStyle(fontSize: 25,color: Colors.white),),
                    SizedBox(height: 20,),
                    //Text("GEC Jhalawar's Premier Sports \nTournament",style: TextStyle(fontSize: 15,color: Colors.white),),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        SizedBox(width: 100,),
                       /* ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Rounded corners
                        ), padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Padding
                          elevation: 10, // Shadow elevation
                        ).copyWith(
                          backgroundColor:  MaterialStateProperty.all(Colors.pinkAccent), // Ensures transparency for gradient
                        ), child: Text("View Schedule",style: TextStyle(color: Colors.white),)) ,*/
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50,),
            Container(height: 1650,width: 350,
              decoration: BoxDecoration(
                color: Colors.white, // container color
                borderRadius: BorderRadius.circular(12), // optional rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // shadow color
                    spreadRadius: 5, // how much the shadow spreads
                    blurRadius: 7, // how blurred the shadow is
                    offset: Offset(0, 3), // shadow position (x, y)
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 20,),
                      Text("Matches",style: TextStyle(fontSize: 25),),
                      SizedBox(width: 130,height: 80,),
                      // Icon(Icons.sports)
                    ],
                  ),
                  SizedBox(height: 30,),
                  InkWell(
                    child: Container(height: 250,width: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/cricket-bat-ball-foreground-pitch.jpg"), // Provide your image asset path here
                          fit: BoxFit.cover, // You can adjust the fit (cover, contain, fill, etc.)
                        ),

                        color: Colors.grey, // container color
                        borderRadius: BorderRadius.circular(12), // optional rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // shadow color
                            spreadRadius: 5, // how much the shadow spreads
                            blurRadius: 7, // how blurred the shadow is
                            offset: Offset(0, 3), // shadow position (x, y)
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [SizedBox(width: 20,height: 50,),
                              Text("CRICKET",style: TextStyle(color: Colors.black,fontSize: 18),)
                            ],
                          ),
                        ],
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Cricketscorepage(isLoggedIn: true,isAdmin: isAdmin)),);
                    },
                  ),
                  SizedBox(height: 60,),
                  InkWell(
                    child: Container(height: 250,width: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/basketball-hoop-with-blue-sky.jpg"), // Provide your image asset path here
                          fit: BoxFit.cover, // You can adjust the fit (cover, contain, fill, etc.)
                        ),

                        color: Colors.grey, // container color
                        borderRadius: BorderRadius.circular(12), // optional rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // shadow color
                            spreadRadius: 5, // how much the shadow spreads
                            blurRadius: 7, // how blurred the shadow is
                            offset: Offset(0, 3), // shadow position (x, y)
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [SizedBox(width: 20,height: 50,),
                              Text("BASKETBALL",style: TextStyle(color: Colors.black,fontSize: 18),)
                            ],
                          ),
                        ],
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BasketballPage(isLoggedIn: true,isAdmin: isAdmin )));
                    },
                  ),
                  SizedBox(height: 60,),
                  InkWell(
                    child: Container(height: 250,width: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/kho-kho.jpeg"), // Provide your image asset path here
                          fit: BoxFit.cover, // You can adjust the fit (cover, contain, fill, etc.)
                        ),

                        color: Colors.grey, // container color
                        borderRadius: BorderRadius.circular(12), // optional rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // shadow color
                            spreadRadius: 5, // how much the shadow spreads
                            blurRadius: 7, // how blurred the shadow is
                            offset: Offset(0, 3), // shadow position (x, y)
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [SizedBox(width: 20,height: 50,),
                              Text("KHO-KHO",style: TextStyle(color: Colors.black,fontSize: 18),)
                            ],
                          ),
                        ],
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => KhokhoPage(isLoggedIn: true, isAdmin: isAdmin)),);
                    },
                  ),
                  SizedBox(height: 60,),
                  InkWell(
                    child: Container(height: 250,width: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/vollyball.jpg"), // Provide your image asset path here
                          fit: BoxFit.cover, // You can adjust the fit (cover, contain, fill, etc.)
                        ),

                        color: Colors.grey, // container color
                        borderRadius: BorderRadius.circular(12), // optional rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // shadow color
                            spreadRadius: 5, // how much the shadow spreads
                            blurRadius: 7, // how blurred the shadow is
                            offset: Offset(0, 3), // shadow position (x, y)
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [SizedBox(width: 20,height: 50,),
                              Text("VOLLYBALL",style: TextStyle(color: Colors.black,fontSize: 18),)
                            ],
                          ),
                        ],
                      ),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => VolleyballScorePage(isLoggedIn: true,isAdmin: isAdmin)),);
                    },
                  ),
                  SizedBox(height: 60,),
                  InkWell(
                    child: Container(height: 250,width: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/kabbadi.jpeg"), // Provide your image asset path here
                          fit: BoxFit.cover, // You can adjust the fit (cover, contain, fill, etc.)
                        ),

                        color: Colors.grey, // container color
                        borderRadius: BorderRadius.circular(12), // optional rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2), // shadow color
                            spreadRadius: 5, // how much the shadow spreads
                            blurRadius: 7, // how blurred the shadow is
                            offset: Offset(0, 3), // shadow position (x, y)
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [SizedBox(width: 20,height: 50,),
                              Text("KABBADI",style: TextStyle(color: Colors.black,fontSize: 18),)

                            ],),

                        ],
                      ),

                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Kabbadi(isLoggedIn: true,isAdmin:isAdmin)),);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 50,),

          ],
        ),
      ) ,

      //_pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,

        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: InkWell(child: Icon(Icons.sports_baseball_rounded),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SportsPage()),);},),
            label: 'Sports',),
            BottomNavigationBarItem(
            icon: InkWell(child: Icon(Icons.notifications),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => NoticeBoardScreen(isLoggedIn: true,isAdmin:isAdmin)));

            },
            ),

            label: 'Tables',
          ),
         /* BottomNavigationBarItem(
            icon: InkWell(child: Icon(Icons.view_comfortable),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage(isLoggedIn: true,isAdmin: isAdmin)),);

              },

            ),
            label: 'Result',
          ),*/
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
      ),git


    );
  }
}

