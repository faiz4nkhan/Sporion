import 'package:flutter/material.dart';

void main() {
  runApp(CricketScoreApp());
}

class CricketScoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cricket Score App',
      theme: ThemeData(
        primaryColor: Colors.green,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.amber),
      ),
      home: CricketScorePage(),
    );
  }
}

class CricketScorePage extends StatefulWidget {
  @override
  _CricketScorePageState createState() => _CricketScorePageState();
}

class _CricketScorePageState extends State<CricketScorePage> {
  // Track Runs, Wickets, and Overs for both teams
  int teamARuns = 0;
  int teamAWickets = 0;
  double teamAOvers = 0.0;

  int teamBRuns = 0;
  int teamBWickets = 0;
  double teamBOvers = 0.0;

  // Controllers for updating score, wickets, and overs
  final TextEditingController teamARunsController = TextEditingController();
  final TextEditingController teamAWicketsController = TextEditingController();
  final TextEditingController teamAOversController = TextEditingController();

  final TextEditingController teamBRunsController = TextEditingController();
  final TextEditingController teamBWicketsController = TextEditingController();
  final TextEditingController teamBOversController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Cricket Scoreboard'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent[700],
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Team A Section
                    Column(
                      children: [
                        Text('Team A', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                        Text('$teamARuns/$teamAWickets', style: TextStyle(fontSize: 24, color: Colors.green)),
                        Text('$teamAOvers overs', style: TextStyle(fontSize: 16, color: Colors.green)),
                      ],
                    ),
                    VerticalDivider(color: Colors.black, width: 1),
                    // Team B Section
                    Column(
                      children: [
                        Text('Team B', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
                        Text('$teamBRuns/$teamBWickets', style: TextStyle(fontSize: 24, color: Colors.red)),
                        Text('$teamBOvers overs', style: TextStyle(fontSize: 16, color: Colors.red)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Update Score Section
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
                      controller: teamARunsController,
                      decoration: InputDecoration(labelText: 'Update Team A Runs'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          teamARuns = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                    TextField(
                      controller: teamAWicketsController,
                      decoration: InputDecoration(labelText: 'Update Team A Wickets'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          teamAWickets = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                    TextField(
                      controller: teamAOversController,
                      decoration: InputDecoration(labelText: 'Update Team A Overs'),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) {
                        setState(() {
                          teamAOvers = double.tryParse(value) ?? 0.0;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: teamBRunsController,
                      decoration: InputDecoration(labelText: 'Update Team B Runs'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          teamBRuns = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                    TextField(
                      controller: teamBWicketsController,
                      decoration: InputDecoration(labelText: 'Update Team B Wickets'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          teamBWickets = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                    TextField(
                      controller: teamBOversController,
                      decoration: InputDecoration(labelText: 'Update Team B Overs'),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) {
                        setState(() {
                          teamBOvers = double.tryParse(value) ?? 0.0;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Save the updated values
                          teamARuns = int.tryParse(teamARunsController.text) ?? teamARuns;
                          teamAWickets = int.tryParse(teamAWicketsController.text) ?? teamAWickets;
                          teamAOvers = double.tryParse(teamAOversController.text) ?? teamAOvers;

                          teamBRuns = int.tryParse(teamBRunsController.text) ?? teamBRuns;
                          teamBWickets = int.tryParse(teamBWicketsController.text) ?? teamBWickets;
                          teamBOvers = double.tryParse(teamBOversController.text) ?? teamBOvers;
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
