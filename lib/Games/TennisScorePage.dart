import 'package:flutter/material.dart';

class TennisScorePage extends StatefulWidget {
  final bool isAdmin; // Added isAdmin flag

  TennisScorePage({required this.isAdmin});

  @override
  _TennisScorePageState createState() => _TennisScorePageState();
}

class _TennisScorePageState extends State<TennisScorePage> {
  // Track Games, Sets, and Matches for both players
  int playerAGames = 0;
  int playerASets = 0;
  int playerAMatches = 0;

  int playerBGames = 0;
  int playerBSets = 0;
  int playerBMatches = 0;

  final TextEditingController playerAGamesController = TextEditingController();
  final TextEditingController playerASetsController = TextEditingController();
  final TextEditingController playerAMatchesController = TextEditingController();

  final TextEditingController playerBGamesController = TextEditingController();
  final TextEditingController playerBSetsController = TextEditingController();
  final TextEditingController playerBMatchesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text('Tennis Score'),
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
                    Column(
                      children: [
                        Text('Player A', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                        Text('Games: $playerAGames', style: TextStyle(fontSize: 24, color: Colors.blue)),
                        Text('Sets: $playerASets', style: TextStyle(fontSize: 16, color: Colors.blue)),
                        Text('Matches: $playerAMatches', style: TextStyle(fontSize: 16, color: Colors.blue)),
                      ],
                    ),
                    VerticalDivider(color: Colors.black, width: 1),
                    Column(
                      children: [
                        Text('Player B', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red)),
                        Text('Games: $playerBGames', style: TextStyle(fontSize: 24, color: Colors.red)),
                        Text('Sets: $playerBSets', style: TextStyle(fontSize: 16, color: Colors.red)),
                        Text('Matches: $playerBMatches', style: TextStyle(fontSize: 16, color: Colors.red)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Update Score Section (Only visible if admin)
            widget.isAdmin
                ? Card(
              color: Colors.blue[50],
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Update Scores:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextField(
                      controller: playerAGamesController,
                      decoration: InputDecoration(labelText: 'Update Player A Games'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          playerAGames = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                    TextField(
                      controller: playerASetsController,
                      decoration: InputDecoration(labelText: 'Update Player A Sets'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          playerASets = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                    TextField(
                      controller: playerAMatchesController,
                      decoration: InputDecoration(labelText: 'Update Player A Matches'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          playerAMatches = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: playerBGamesController,
                      decoration: InputDecoration(labelText: 'Update Player B Games'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          playerBGames = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                    TextField(
                      controller: playerBSetsController,
                      decoration: InputDecoration(labelText: 'Update Player B Sets'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          playerBSets = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                    TextField(
                      controller: playerBMatchesController,
                      decoration: InputDecoration(labelText: 'Update Player B Matches'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          playerBMatches = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          playerAGames = int.tryParse(playerAGamesController.text) ?? playerAGames;
                          playerASets = int.tryParse(playerASetsController.text) ?? playerASets;
                          playerAMatches = int.tryParse(playerAMatchesController.text) ?? playerAMatches;

                          playerBGames = int.tryParse(playerBGamesController.text) ?? playerBGames;
                          playerBSets = int.tryParse(playerBSetsController.text) ?? playerBSets;
                          playerBMatches = int.tryParse(playerBMatchesController.text) ?? playerBMatches;
                        });
                      },
                      child: Text('Update Score'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                    ),
                  ],
                ),
              ),
            )
                : Container(), // No input fields if the user is not an admin
          ],
        ),
      ),
    );
  }
}