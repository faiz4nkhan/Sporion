import 'package:flutter/material.dart';

// Define the ScoreCard widget here
class ScoreCard extends StatelessWidget {
  final String teamName1;
  final String teamName2;
  final int runs1;
  final int wickets1;
  final double overs1;
  final int maxOvers1;
  final int runs2;
  final int wickets2;
  final double overs2;
  final int maxOvers2;
  final String matchStatus;
  final List<String> players1;
  final List<String> players2;

  ScoreCard({
    required this.teamName1,
    required this.teamName2,
    required this.runs1,
    required this.wickets1,
    required this.overs1,
    required this.maxOvers1,
    required this.runs2,
    required this.wickets2,
    required this.overs2,
    required this.maxOvers2,
    required this.matchStatus,
    required this.players1,
    required this.players2,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the MatchDetailPage on tap
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatchDetailPage(
              teamName1: teamName1,
              teamName2: teamName2,
              runs1: runs1,
              wickets1: wickets1,
              overs1: overs1,
              maxOvers1: maxOvers1,
              runs2: runs2,
              wickets2: wickets2,
              overs2: overs2,
              maxOvers2: maxOvers2,
              matchStatus: matchStatus,
              players1: players1,
              players2: players2,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        color: Colors.white70, // Light background for the card
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                matchStatus,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    teamName1,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    teamName2,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Score: $runs1/$wickets1",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Overs: $overs1/$maxOvers1",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Score: $runs2/$wickets2",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Overs: $overs2/$maxOvers2",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// MatchDetailPage to show detailed match information
class MatchDetailPage extends StatelessWidget {
  final String teamName1;
  final String teamName2;
  final int runs1;
  final int wickets1;
  final double overs1;
  final int maxOvers1;
  final int runs2;
  final int wickets2;
  final double overs2;
  final int maxOvers2;
  final String matchStatus;
  final List<String> players1;
  final List<String> players2;

  MatchDetailPage({
    required this.teamName1,
    required this.teamName2,
    required this.runs1,
    required this.wickets1,
    required this.overs1,
    required this.maxOvers1,
    required this.runs2,
    required this.wickets2,
    required this.overs2,
    required this.maxOvers2,
    required this.matchStatus,
    required this.players1,
    required this.players2,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$teamName1 vs $teamName2'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Display Score and Overs in bold at the top
            Container(
              decoration: BoxDecoration(
                color: Colors.blue[100], // Blue background for the score section
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$teamName1: $runs1/$wickets1",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Overs: $overs1/$maxOvers1",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$teamName2: $runs2/$wickets2",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Overs: $overs2/$maxOvers2",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Display Team A players on the left and Team B players on the right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Team A players
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue[50], // Light blue background for Team A
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$teamName1 Players:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                        SizedBox(height: 10),
                        for (var player in players1)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(player, style: TextStyle(fontSize: 16)),
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 20),
                // Team B players
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue[50], // Light blue background for Team B
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$teamName2 Players:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                        SizedBox(height: 10),
                        for (var player in players2)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(player, style: TextStyle(fontSize: 16)),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// The main CricketScorePage widget
class CricketScorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cricket Match Scores'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        children: [
          ScoreCard(
            teamName1: "Team A",
            teamName2: "Team B",
            runs1: 120,
            wickets1: 4,
            overs1: 12.3,
            maxOvers1: 20,
            runs2: 110,
            wickets2: 3,
            overs2: 10.5,
            maxOvers2: 20,
            matchStatus: "Live",
            players1: ["Player A1", "Player A2", "Player A3", "Player A4", "Player A5", "Player A6", "Player A7", "Player A8", "Player A9", "Player A10", "Player A11"],
            players2: ["Player B1", "Player B2", "Player B3", "Player B4", "Player B5", "Player B6", "Player B7", "Player B8", "Player B9", "Player B10", "Player B11"],
          ),
          ScoreCard(
            teamName1: "Team C",
            teamName2: "Team D",
            runs1: 180,
            wickets1: 4,
            overs1: 10.3,
            maxOvers1: 20,
            runs2: 100,
            wickets2: 3,
            overs2: 15.5,
            maxOvers2: 20,
            matchStatus: "",
            players1: ["Player A1", "Player A2", "Player A3", "Player A4", "Player A5", "Player A6", "Player A7", "Player A8", "Player A9", "Player A10", "Player A11"],
            players2: ["Player B1", "Player B2", "Player B3", "Player B4", "Player B5", "Player B6", "Player B7", "Player B8", "Player B9", "Player B10", "Player B11"],
          ),
          ScoreCard(
            teamName1: "Team E",
            teamName2: "Team F",
            runs1: 90,
            wickets1: 8,
            overs1: 9.2,
            maxOvers1: 20,
            runs2: 80,
            wickets2: 10,
            overs2: 5.5,
            maxOvers2: 20,
            matchStatus: "Live",
            players1: ["Player A1", "Player A2", "Player A3", "Player A4", "Player A5", "Player A6", "Player A7", "Player A8", "Player A9", "Player A10", "Player A11"],
            players2: ["Player B1", "Player B2", "Player B3", "Player B4", "Player B5", "Player B6", "Player B7", "Player B8", "Player B9", "Player B10", "Player B11"],
          ),
          ScoreCard(
            teamName1: "Team G",
            teamName2: "Team H",
            runs1: 150,
            wickets1: 6,
            overs1: 15.3,
            maxOvers1: 20,
            runs2: 152,
            wickets2: 3,
            overs2: 19.0,
            maxOvers2: 20,
            matchStatus: "",
            players1: ["Player A1", "Player A2", "Player A3", "Player A4", "Player A5", "Player A6", "Player A7", "Player A8", "Player A9", "Player A10", "Player A11"],
            players2: ["Player B1", "Player B2", "Player B3", "Player B4", "Player B5", "Player B6", "Player B7", "Player B8", "Player B9", "Player B10", "Player B11"],
          ),
          ScoreCard(
            teamName1: "Team I",
            teamName2: "Team J",
            runs1: 89,
            wickets1: 7,
            overs1: 11.3,
            maxOvers1: 20,
            runs2: 90,
            wickets2: 3,
            overs2: 9.5,
            maxOvers2: 20,
            matchStatus: "",
            players1: ["Player A1", "Player A2", "Player A3", "Player A4", "Player A5", "Player A6", "Player A7", "Player A8", "Player A9", "Player A10", "Player A11"],
            players2: ["Player B1", "Player B2", "Player B3", "Player B4", "Player B5", "Player B6", "Player B7", "Player B8", "Player B9", "Player B10", "Player B11"],
          ),
          //
          //
          //
          //
          // Add more ScoreCards here...
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CricketScorePage(),
  ));
}
