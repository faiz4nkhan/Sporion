import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TennisScorePage extends StatefulWidget {
  final bool isAdmin;

  TennisScorePage({required this.isAdmin});

  @override
  _TennisScorePageState createState() => _TennisScorePageState();
}

class _TennisScorePageState extends State<TennisScorePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> liveMatches = [];
  List<Map<String, dynamic>> upcomingMatches = [];
  List<Map<String, dynamic>> pastMatches = [];

  final TextEditingController playerAGamesController = TextEditingController();
  final TextEditingController playerASetsController = TextEditingController();
  final TextEditingController playerAMatchesController = TextEditingController();

  final TextEditingController playerBGamesController = TextEditingController();
  final TextEditingController playerBSetsController = TextEditingController();
  final TextEditingController playerBMatchesController = TextEditingController();

  final String apiUrl = "https://api.example.com/matches"; // Your API URL

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchMatchData();
  }

  // Fetch match data from API
  Future<void> fetchMatchData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        // Casting the dynamic list to List<Map<String, dynamic>>
        List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(json.decode(response.body));
        setState(() {
          // Separate matches based on their status
          liveMatches = data.where((match) => match['status'] == 'Live').toList();
          upcomingMatches = data.where((match) => match['status'] == 'Upcoming').toList();
          pastMatches = data.where((match) => match['status'] == 'Past').toList();
        });
      } else {
        throw Exception('Failed to load matches');
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // Update match data via API
  Future<void> updateMatchData(String matchId, Map<String, dynamic> updatedData) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/$matchId'), // Assuming you can update match by ID
        headers: {"Content-Type": "application/json"},
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        fetchMatchData(); // Refresh the match data after updating
      } else {
        throw Exception('Failed to update match');
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  // Delete match data via API
  Future<void> deleteMatch(String matchId) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$matchId'), // Assuming you can delete match by ID
      );

      if (response.statusCode == 200) {
        fetchMatchData(); // Refresh the match data after deletion
      } else {
        throw Exception('Failed to delete match');
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text('Tennis Score'),
        centerTitle: true,
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
        onPressed: () {
          _showAdminDialog();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[700],
      )
          : null,
    );
  }

  // Function to build match list for different match statuses
  Widget buildMatchListTab(List<Map<String, dynamic>> matches) {
    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        var match = matches[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          color: Colors.blue[50],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${match['playerA']} vs ${match['playerB']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text('Status: ${match['status']}'),
                Text('Player A Games: ${match['playerAGames']}'),
                Text('Player B Games: ${match['playerBGames']}'),
                if (widget.isAdmin)
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showUpdateDialog(match);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteMatch(match['id']);  // Delete by match ID
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Admin dialog to add/update match information
  void _showAdminDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Match Information'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: playerAGamesController,
                  decoration: InputDecoration(labelText: 'Player A Games'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: playerASetsController,
                  decoration: InputDecoration(labelText: 'Player A Sets'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: playerAMatchesController,
                  decoration: InputDecoration(labelText: 'Player A Matches'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: playerBGamesController,
                  decoration: InputDecoration(labelText: 'Player B Games'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: playerBSetsController,
                  decoration: InputDecoration(labelText: 'Player B Sets'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: playerBMatchesController,
                  decoration: InputDecoration(labelText: 'Player B Matches'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Map<String, dynamic> newMatch = {
                  'playerA': 'Player A', // Can take from user input
                  'playerB': 'Player B',
                  'status': 'Upcoming',
                  'playerAGames': int.tryParse(playerAGamesController.text) ?? 0,
                  'playerBGames': int.tryParse(playerBGamesController.text) ?? 0,
                };
                updateMatchData('new_id', newMatch); // Add match (simulate with a new ID)
                Navigator.of(context).pop();
              },
              child: Text('Save Match Info'),
            ),
          ],
        );
      },
    );
  }

  // Function to show update dialog
  void _showUpdateDialog(Map<String, dynamic> match) {
    playerAGamesController.text = match['playerAGames'].toString();
    playerBGamesController.text = match['playerBGames'].toString();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Match Info'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: playerAGamesController,
                  decoration: InputDecoration(labelText: 'Player A Games'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: playerBGamesController,
                  decoration: InputDecoration(labelText: 'Player B Games'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Map<String, dynamic> updatedMatch = {
                  'playerA': match['playerA'],
                  'playerB': match['playerB'],
                  'status': match['status'],
                  'playerAGames': int.tryParse(playerAGamesController.text) ?? match['playerAGames'],
                  'playerBGames': int.tryParse(playerBGamesController.text) ?? match['playerBGames'],
                };
                updateMatchData(match['id'], updatedMatch); // Update match by ID
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
