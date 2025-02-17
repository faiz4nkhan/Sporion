import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GameResult {
  final String gameType;
  final String teamA;
  final String teamB;
  final String winner;
  final String scoreA;
  final String scoreB;
  final String status;

  GameResult({
    required this.gameType,
    required this.teamA,
    required this.teamB,
    required this.winner,
    required this.scoreA,
    required this.scoreB,
    required this.status, // Added status field for live, upcoming, past
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

class _ResultPageState extends State<ResultPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // List to hold all game results
  List<GameResult> liveMatches = [];
  List<GameResult> upcomingMatches = [];
  List<GameResult> pastMatches = [];

  // Text Controllers for adding results
  final TextEditingController teamAController = TextEditingController();
  final TextEditingController teamBController = TextEditingController();
  final TextEditingController winnerController = TextEditingController();
  final TextEditingController scoreAController = TextEditingController();
  final TextEditingController scoreBController = TextEditingController();
  final TextEditingController gameTypeController = TextEditingController();
  final String apiUrl = "https://your-api-endpoint.com"; // Replace with your API URL

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchMatchData(); // Fetch match data when the page loads
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose of the TabController when the widget is removed
    super.dispose();
  }

  // Function to fetch match data from the API
  Future<void> fetchMatchData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(json.decode(response.body));
        setState(() {
          liveMatches = data.where((match) => match['status'] == 'Live').map((match) {
            return GameResult(
              gameType: match['gameType'],
              teamA: match['teamA'],
              teamB: match['teamB'],
              winner: match['winner'],
              scoreA: match['scoreA'],
              scoreB: match['scoreB'],
              status: match['status'],
            );
          }).toList();

          upcomingMatches = data.where((match) => match['status'] == 'Upcoming').map((match) {
            return GameResult(
              gameType: match['gameType'],
              teamA: match['teamA'],
              teamB: match['teamB'],
              winner: match['winner'],
              scoreA: match['scoreA'],
              scoreB: match['scoreB'],
              status: match['status'],
            );
          }).toList();

          pastMatches = data.where((match) => match['status'] == 'Past').map((match) {
            return GameResult(
              gameType: match['gameType'],
              teamA: match['teamA'],
              teamB: match['teamB'],
              winner: match['winner'],
              scoreA: match['scoreA'],
              scoreB: match['scoreB'],
              status: match['status'],
            );
          }).toList();
        });
      } else {
        throw Exception('Failed to load matches');
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // Function to add a new result
  void _addResult() {
    setState(() {
      liveMatches.add(GameResult(
        gameType: gameTypeController.text,
        teamA: teamAController.text,
        teamB: teamBController.text,
        winner: winnerController.text,
        scoreA: scoreAController.text,
        scoreB: scoreBController.text,
        status: 'Live', // Default status to Live
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

  // Function to show the admin dialog for adding and updating matches
  void _showAdminDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Match Information'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _addResult(); // Add new result
                Navigator.of(context).pop();
              },
              child: Text('Save Match Info'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Results'),
        backgroundColor: Colors.blue,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Live'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Past'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildMatchListTab(liveMatches),
          buildMatchListTab(upcomingMatches),
          buildMatchListTab(pastMatches),
        ],
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
        onPressed: _showAdminDialog, // Show the admin dialog to add or update match info
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[700],
      )
          : null, // Only show the button if the user is an admin
    );
  }

  // Function to build the match list based on match status (Live, Upcoming, Past)
  Widget buildMatchListTab(List<GameResult> matches) {
    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final result = matches[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          color: Colors.blue[50],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${result.gameType}'),
                Text('${result.teamA} vs ${result.teamB}'),
                Text('Winner: ${result.winner}'),
                Text('Score: ${result.scoreA} - ${result.scoreB}'),
                Text('Status: ${result.status}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
