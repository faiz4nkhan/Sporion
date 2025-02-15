import 'package:flutter/material.dart';

// Define the KhoKhoScoreCard widget
class KhoKhoScoreCard extends StatelessWidget {
  final String teamName1;
  final String teamName2;
  final List<int> setScores1;
  final List<int> setScores2;
  final String matchStatus;
  final List<String> players1;
  final List<String> players2;

  KhoKhoScoreCard({
    required this.teamName1,
    required this.teamName2,
    required this.setScores1,
    required this.setScores2,
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
            builder: (context) => KhoKhoMatchDetailPage(
              teamName1: teamName1,
              teamName2: teamName2,
              setScores1: setScores1,
              setScores2: setScores2,
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
              // Display Set Scores
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Set Scores: ${setScores1.join(', ')}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Set Scores: ${setScores2.join(', ')}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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

// KhoKhoMatchDetailPage to show detailed match information
class KhoKhoMatchDetailPage extends StatelessWidget {
  final String teamName1;
  final String teamName2;
  final List<int> setScores1;
  final List<int> setScores2;
  final String matchStatus;
  final List<String> players1;
  final List<String> players2;

  KhoKhoMatchDetailPage({
    required this.teamName1,
    required this.setScores1,
    required this.setScores2,
    required this.teamName2,
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
            // Display Set Scores in bold at the top
            Container(
              decoration: BoxDecoration(
                color: Colors.blue[100], // Blue background for the score section
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Team A Set Scores (on the left side)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$teamName1 Set :",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      SizedBox(height: 5), // Space between label and scores
                      Text(
                        "${setScores1.join(', ')}", // Show set scores for Team A
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  // Space between Team A and Team B Set Scores
                  SizedBox(width: 30),
                  // Team B Set Scores (on the right side)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$teamName2 Set :",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                      SizedBox(height: 5), // Space between label and scores
                      Text(
                        "${setScores2.join(', ')}", // Show set scores for Team B
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
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

// The main KhoKhoScorePage widget
class KhoKhoScorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kho Kho Match Scores'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        children: [
          KhoKhoScoreCard(
            teamName1: "Team A",
            teamName2: "Team B",
            setScores1: [25, 20, 18],
            setScores2: [20, 25, 25],
            matchStatus: "Live",
            players1: ["Player A1", "Player A2", "Player A3", "Player A4", "Player A5"],
            players2: ["Player B1", "Player B2", "Player B3", "Player B4", "Player B5"],
          ),
          KhoKhoScoreCard(
            teamName1: "Team C",
            teamName2: "Team D",
            setScores1: [12, 21, 18],
            setScores2: [27, 29, 15],
            matchStatus: "Completed",
            players1: ["Player C1", "Player C2", "Player C3", "Player C4", "Player C5"],
            players2: ["Player D1", "Player D2", "Player D3", "Player D4", "Player D5"],
          ),
          KhoKhoScoreCard(
            teamName1: "Team E",
            teamName2: "Team F",
            setScores1: [30, 28],
            setScores2: [22, 25],
            matchStatus: "Upcoming",
            players1: ["Player E1", "Player E2", "Player E3", "Player E4", "Player E5"],
            players2: ["Player F1", "Player F2", "Player F3", "Player F4", "Player F5"],
          ),
          KhoKhoScoreCard(
            teamName1: "Team G",
            teamName2: "Team H",
            setScores1: [20, 25],
            setScores2: [25, 25],
            matchStatus: "",
            players1: ["Player E1", "Player E2", "Player E3", "Player E4", "Player E5"],
            players2: ["Player F1", "Player F2", "Player F3", "Player F4", "Player F5"],
          ),
        ],
      ),
    );
  }
}
