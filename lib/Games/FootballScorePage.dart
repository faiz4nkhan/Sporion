import 'package:flutter/material.dart';

void main() {
  runApp(FootballScoreApp());
}

class FootballScoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Football Score App',
      theme: ThemeData(
        primaryColor: Colors.green,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.amber),
      ),
      home: FootballScorePage(isAdmin: true), // Pass isAdmin here
    );
  }
}

class FootballScorePage extends StatefulWidget {
  final bool isAdmin;

  FootballScorePage({required this.isAdmin});

  @override
  _FootballScorePageState createState() => _FootballScorePageState();
}

class _FootballScorePageState extends State<FootballScorePage> {
  // Track Goals, Half, and Matches for both teams
  int teamAGoals = 0;
  int teamAHalf = 0;
  int teamAMatches = 0;

  int teamBGoals = 0;
  int teamBHalf = 0;
  int teamBMatches = 0;

  // Controllers for updating score, half, and matches
  final TextEditingController teamAGoalsController = TextEditingController();
  final TextEditingController teamAHalfController = TextEditingController();
  final TextEditingController teamAMatchesController = TextEditingController();

  final TextEditingController teamBGoalsController = TextEditingController();
  final TextEditingController teamBHalfController = TextEditingController();
  final TextEditingController teamBMatchesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text('Football Score'),
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
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Team A Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Team A', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Goals: $teamAGoals', style: TextStyle(fontSize: 24, color: Colors.green)),
                            Text('Halves: $teamAHalf', style: TextStyle(fontSize: 16, color: Colors.green)),
                            Text('Matches: $teamAMatches', style: TextStyle(fontSize: 16, color: Colors.green)),
                          ],
                        ),
                      ],
                    ),
                    Divider(color: Colors.black),
                    // Team B Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Team B', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Goals: $teamBGoals', style: TextStyle(fontSize: 24, color: Colors.red)),
                            Text('Halves: $teamBHalf', style: TextStyle(fontSize: 16, color: Colors.red)),
                            Text('Matches: $teamBMatches', style: TextStyle(fontSize: 16, color: Colors.red)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Only allow updates if admin
            if (widget.isAdmin)
            // Update Score Section (Admin can update)
              Card(
                color: Colors.green[50],
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Update Scores:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextField(
                        controller: teamAGoalsController,
                        decoration: InputDecoration(labelText: 'Update Team A Goals'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            teamAGoals = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                      TextField(
                        controller: teamAHalfController,
                        decoration: InputDecoration(labelText: 'Update Team A Halves'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            teamAHalf = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                      TextField(
                        controller: teamAMatchesController,
                        decoration: InputDecoration(labelText: 'Update Team A Matches'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            teamAMatches = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: teamBGoalsController,
                        decoration: InputDecoration(labelText: 'Update Team B Goals'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            teamBGoals = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                      TextField(
                        controller: teamBHalfController,
                        decoration: InputDecoration(labelText: 'Update Team B Halves'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            teamBHalf = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                      TextField(
                        controller: teamBMatchesController,
                        decoration: InputDecoration(labelText: 'Update Team B Matches'),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            teamBMatches = int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // Save the updated values
                            teamAGoals = int.tryParse(teamAGoalsController.text) ?? teamAGoals;
                            teamAHalf = int.tryParse(teamAHalfController.text) ?? teamAHalf;
                            teamAMatches = int.tryParse(teamAMatchesController.text) ?? teamAMatches;

                            teamBGoals = int.tryParse(teamBGoalsController.text) ?? teamBGoals;
                            teamBHalf = int.tryParse(teamBHalfController.text) ?? teamBHalf;
                            teamBMatches = int.tryParse(teamBMatchesController.text) ?? teamBMatches;
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
            // If not an admin, show message
            if (!widget.isAdmin)
              Center(
                child: Text(
                  'You are a user and cannot modify the scores.',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Optionally, perform actions like adding/removing scores.
        },
        child: Icon(Icons.edit),
        backgroundColor: Colors.green[700],
      ),
    );
  }
}
