import 'package:flutter/material.dart';
import 'package:livebuzz/detail1.dart'; // Import the Detail1 page

class BasketballPage extends StatelessWidget {
  final List<Map<String, dynamic>> matches = [
    {
      "team1": "Lakers",
      "team2": "Bulls",
      "score1": 85,
      "score2": 79,
      "players1": ["LeBron", "Davis", "Westbrook", "Schroder", "Tucker","LeBron", "Davis", "Westbrook", "Schroder", "Tucker"],
      "players2": ["Zach LaVine", "DeRozan", "Vucevic", "Caruso", "Williams","LaVine", "DeRozan", "Vucevic", "Caruso", "Williams"]
    },
    {
      "team1": "Warriors",
      "team2": "Heat",
      "score1": 92,
      "score2": 88,
      "players1": ["Curry", "Thompson", "Green", "Wiggins", "Poole"],
      "players2": ["Butler", "Adebayo", "Lowry", "Herro", "Vincent"]
    },
    {
      "team1": "Celtics",
      "team2": "Knicks",
      "score1": 101,
      "score2": 97,
      "players1": ["Tatum", "Brown", "Smart", "Horford", "Williams"],
      "players2": ["Barrett", "Randle", "Brunson", "Quickley", "Robinson"]
    },
    {
      "team1": "king",
      "team2": "Knights",
      "score1": 89,
      "score2": 91,
      "players1": ["Tatum", "Brown", "Smart", "Horford", "Williams"],
      "players2": ["Barrett", "Randle", "Brunson", "Quickley", "Robinson"]
    },
    {
      "team1": "bulls",
      "team2": "heat",
      "score1": 44,
      "score2": 62,
      "players1": ["Tatum", "Brown", "Smart", "Horford", "Williams"],
      "players2": ["Barrett", "Randle", "Brunson", "Quickley", "Robinson"]
    },
    {
      "team1": "king",
      "team2": "lakers",
      "score1": 89,
      "score2": 91,
      "players1": ["Tatum", "Brown", "Smart", "Horford", "Williams"],
      "players2": ["Barrett", "Randle", "Brunson", "Quickley", "Robinson"]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Basketball Matches"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: matches.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => detail1(
                      team1: matches[index]["team1"],
                      team2: matches[index]["team2"],
                      score1: matches[index]["score1"],
                      score2: matches[index]["score2"],
                      players1: matches[index]["players1"],
                      players2: matches[index]["players2"],
                    ),
                  ),
                );
              },
              child: MatchCard(
                team1: matches[index]["team1"],
                team2: matches[index]["team2"],
                score1: matches[index]["score1"],
                score2: matches[index]["score2"],
              ),
            );
          },
        ),
      ),
    );
  }
}

class MatchCard extends StatelessWidget {
  final String team1, team2;
  final int score1, score2;

  MatchCard({
    required this.team1,
    required this.team2,
    required this.score1,
    required this.score2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 5)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$team1 vs $team2",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 10),
          Text(
            "$score1 - $score2",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
          ),
        ],
      ),
    );
  }
}
