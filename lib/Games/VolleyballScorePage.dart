import 'package:flutter/material.dart';

void main() {
  runApp(VolleyballScoreApp());
}

class VolleyballScoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Volleyball Score App',
      theme: ThemeData(
        primaryColor: Colors.blue,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.amber),
      ),
      home: VolleyballScorePage(isAdmin: true), // Set isAdmin flag to true or false
    );
  }
}

class VolleyballScorePage extends StatefulWidget {
  final bool isAdmin; // Added isAdmin flag to differentiate between admin and user

  VolleyballScorePage({required this.isAdmin});

  @override
  _VolleyballScorePageState createState() => _VolleyballScorePageState();
}

class _VolleyballScorePageState extends State<VolleyballScorePage> {
  // Track Points, Sets, and Games for both teams
  int teamAPoints = 0;
  int teamASets = 0;
  int teamAGames = 0;

  int teamBPoints = 0;
  int teamBSets = 0;
  int teamBGames = 0;

  // Controllers for updating score, sets, and games
  final TextEditingController teamAPointsController = TextEditingController();
  final TextEditingController teamASetsController = TextEditingController();
  final TextEditingController teamAGamesController = TextEditingController();

  final TextEditingController teamBPointsController = TextEditingController();
  final TextEditingController teamBSetsController = TextEditingController();
  final TextEditingController teamBGamesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text('Volleyball Score'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Score Display Section
            Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Team A Section
                    Column(
                      children: [
                        Text('Team A', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                        Text('Points: $teamAPoints', style: TextStyle(fontSize: 24, color: Colors.blue)),
                        Text('Sets: $teamASets', style: TextStyle(fontSize: 16, color: Colors.blue)),
                        Text('Games: $teamAGames', style: TextStyle(fontSize: 16, color: Colors.blue)),
                      ],
                    ),
                    VerticalDivider(color: Colors.black, width: 1),
                    // Team B Section
                    Column(
                      children: [
                        Text('Team B', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
                        Text('Points: $teamBPoints', style: TextStyle(fontSize: 24, color: Colors.red)),
                        Text('Sets: $teamBSets', style: TextStyle(fontSize: 16, color: Colors.red)),
                        Text('Games: $teamBGames', style: TextStyle(fontSize: 16, color: Colors.red)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Update Score Section (only visible for admin)
            if (widget.isAdmin)
              Card(
                color: Colors.blue[50],
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Update Scores:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextField(
                        controller: teamAPointsController,
                        decoration: InputDecoration(labelText: 'Update Team A Points'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            teamAPoints = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                      TextField(
                        controller: teamASetsController,
                        decoration: InputDecoration(labelText: 'Update Team A Sets'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            teamASets = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                      TextField(
                        controller: teamAGamesController,
                        decoration: InputDecoration(labelText: 'Update Team A Games'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            teamAGames = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: teamBPointsController,
                        decoration: InputDecoration(labelText: 'Update Team B Points'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            teamBPoints = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                      TextField(
                        controller: teamBSetsController,
                        decoration: InputDecoration(labelText: 'Update Team B Sets'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            teamBSets = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                      TextField(
                        controller: teamBGamesController,
                        decoration: InputDecoration(labelText: 'Update Team B Games'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            teamBGames = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // Save the updated values
                            teamAPoints = int.tryParse(teamAPointsController.text) ?? teamAPoints;
                            teamASets = int.tryParse(teamASetsController.text) ?? teamASets;
                            teamAGames = int.tryParse(teamAGamesController.text) ?? teamAGames;

                            teamBPoints = int.tryParse(teamBPointsController.text) ?? teamBPoints;
                            teamBSets = int.tryParse(teamBSetsController.text) ?? teamBSets;
                            teamBGames = int.tryParse(teamBGamesController.text) ?? teamBGames;
                          });
                        },
                        child: Text('Update Score'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black, // Button Color
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
        onPressed: () {
          // Optionally, perform actions like adding/removing scores.
        },
        child: Icon(Icons.edit),
        backgroundColor: Colors.blue[700],
      )
          : null, // No floating action button for non-admin users
    );
  }
}