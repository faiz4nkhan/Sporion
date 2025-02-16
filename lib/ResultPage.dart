import 'package:flutter/material.dart';
class GameResult {
  final String gameType;
  final String teamA;
  final String teamB;
  final String winner;
  final String scoreA;
  final String scoreB;

  GameResult({
    required this.gameType,
    required this.teamA,
    required this.teamB,
    required this.winner,
    required this.scoreA,
    required this.scoreB,
  });
}


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Game Results',
      theme: ThemeData(
        primaryColor: Colors.blue,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.amber),
      ),
      home: ResultPage(isAdmin: true), // Change to false for regular users
    );
  }
}

class ResultPage extends StatefulWidget {
  final bool isAdmin; // True if admin, False if user

  ResultPage({required this.isAdmin});

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  // List to hold all game results
  List<GameResult> results = [];

  // Text Controllers for adding results
  final TextEditingController teamAController = TextEditingController();
  final TextEditingController teamBController = TextEditingController();
  final TextEditingController winnerController = TextEditingController();
  final TextEditingController scoreAController = TextEditingController();
  final TextEditingController scoreBController = TextEditingController();
  final TextEditingController gameTypeController = TextEditingController();

  // Function to add a new result
  void _addResult() {
    setState(() {
      results.add(GameResult(
        gameType: gameTypeController.text,
        teamA: teamAController.text,
        teamB: teamBController.text,
        winner: winnerController.text,
        scoreA: scoreAController.text,
        scoreB: scoreBController.text,
      ));

      // Clear text fields
      teamAController.clear();
      teamBController.clear();
      winnerController.clear();
      scoreAController.clear();
      scoreBController.clear();
      gameTypeController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Results'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // If Admin, show form to add result
            if (widget.isAdmin)
              Card(
                color: Colors.blue[50],
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add New Result', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextField(
                        controller: gameTypeController,
                        decoration: InputDecoration(labelText: 'Game Type (e.g., Volleyball, Football, etc.)'),
                      ),
                      TextField(
                        controller: teamAController,
                        decoration: InputDecoration(labelText: 'Team A'),
                      ),
                      TextField(
                        controller: teamBController,
                        decoration: InputDecoration(labelText: 'Team B'),
                      ),
                      TextField(
                        controller: winnerController,
                        decoration: InputDecoration(labelText: 'Winner'),
                      ),
                      TextField(
                        controller: scoreAController,
                        decoration: InputDecoration(labelText: 'Score of Team A'),
                      ),
                      TextField(
                        controller: scoreBController,
                        decoration: InputDecoration(labelText: 'Score of Team B'),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _addResult,
                        child: Text('Add Result'),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 20),
            // Results List for All Users
            Text('Results:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListView.builder(
              shrinkWrap: true,
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        // Display Game Type, Teams, Winner, and Scores
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Game Type: ${result.gameType}', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Teams: ${result.teamA} vs ${result.teamB}'),
                            Text('Winner: ${result.winner}'),
                            Text('Score: ${result.scoreA} - ${result.scoreB}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

