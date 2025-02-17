import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // To work with JSON responses

class BasketballPage extends StatefulWidget {
  final bool isLoggedIn;
  final bool isAdmin; // Admin flag

  BasketballPage({required this.isLoggedIn, required this.isAdmin});

  @override
  _BasketballPageState createState() => _BasketballPageState();
}

class _BasketballPageState extends State<BasketballPage> {
  int teamAScore = 0;
  int teamBScore = 0;
  int period = 1;
  String teamAName = "Team A";
  String teamBName = "Team B";
  String matchId = "match1"; // Match document ID

  int _selectedIndex = 0; // Track selected tab for the bottom navigation

  // Text editing controllers for team names and scores
  TextEditingController teamAController = TextEditingController();
  TextEditingController teamBController = TextEditingController();
  TextEditingController teamAScoreController = TextEditingController();
  TextEditingController teamBScoreController = TextEditingController();

  // API endpoint (replace with actual API URL)
  final String apiUrl = "https://example.com/api/matches";

  // Fetch match data from the API
  Future<List<dynamic>> _fetchMatches(String status) async {
    final response = await http.get(Uri.parse('$apiUrl?status=$status'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load matches');
    }
  }

  // Delete a match using its ID (admin only)
  Future<void> _deleteMatch(String matchId) async {
    if (widget.isAdmin) {
      final response = await http.delete(
        Uri.parse('$apiUrl/$matchId'),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Match Deleted')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete match')),
        );
      }
    } else {
      _showUnauthorizedMessage();
    }
  }

  // Show message if the user is unauthorized
  void _showUnauthorizedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You must be an admin to perform this action!')),
    );
  }
// Positive button for admin to add/update team names and scores

  // Update match details (team names and scores) via API
  void _updateMatchDetails() {
    if (widget.isAdmin) {
      // Update match details in API
      final matchData = {
        'teamAName': teamAController.text,
        'teamBName': teamBController.text,
        'teamAScore': teamAScore,
        'teamBScore': teamBScore,
        'period': period,
      };
      // Send update request to API
      http.put(Uri.parse('$apiUrl/$matchId'), body: json.encode(matchData));
    } else {
      _showUnauthorizedMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('Basketball Scoreboard'),
          backgroundColor: Colors.pinkAccent,
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(text: 'PAST MATCHES'),
              Tab(text: 'UPCOMING'),
              Tab(text: 'LIVE'),
            ],
          ),
        ),
        body: widget.isLoggedIn
            ? _getSelectedPage(_selectedIndex)
            : Center(
          child: Text(
            'You must log in to view this page!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        floatingActionButton: widget.isAdmin
            ? FloatingActionButton(
          onPressed: _onPositiveButtonPressed,
          backgroundColor: Colors.green,
          child: Icon(Icons.add),
        )
            : null, // Show only for admins
      ),
    );
  }

  // Display content based on selected tab
  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return _buildPastMatchesPage();
      case 1:
        return _buildUpcomingMatchesPage();
      case 2:
        return _buildLivePage();
      default:
        return _buildLivePage();
    }
  }

  // Live page content with real-time score updates
  Widget _buildLivePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Period: $period',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          // Team Names Editing Section (Admin Only)
          if (widget.isAdmin)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: teamAController..text = teamAName,
                    decoration: InputDecoration(labelText: 'Team A Name'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: teamBController..text = teamBName,
                    decoration: InputDecoration(labelText: 'Team B Name'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.save),
                  onPressed: _updateMatchDetails,
                ),
              ],
            ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Team A
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      teamAName,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$teamAScore',
                      style: TextStyle(fontSize: 48, color: Colors.green),
                    ),
                  ],
                ),
              ),
              // Team B
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      teamBName,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$teamBScore',
                      style: TextStyle(fontSize: 48, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  void _showDialogToAddDetails() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Team Names and Scores'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: teamAController..text = teamAName,
                decoration: InputDecoration(labelText: 'Team A Name'),
              ),
              TextField(
                controller: teamBController..text = teamBName,
                decoration: InputDecoration(labelText: 'Team B Name'),
              ),
              TextField(
                controller: teamAScoreController..text = teamAScore.toString(),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Team A Score'),
              ),
              TextField(
                controller: teamBScoreController..text = teamBScore.toString(),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Team B Score'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateMatchDetails();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
  void _onPositiveButtonPressed() {
    _showDialogToAddDetails();
  }


  // Past matches page with API data
  Widget _buildPastMatchesPage() {
    return FutureBuilder<List<dynamic>>(
      future: _fetchMatches('completed'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.hasData && snapshot.data!.isEmpty) {
          return Center(child: Text('No completed matches'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var match = snapshot.data![index];
            return ListTile(
              title: Text('${match['teamAName']} vs ${match['teamBName']}'),
              subtitle: Text('Score: ${match['teamAScore']} - ${match['teamBScore']}'),
              trailing: widget.isAdmin
                  ? IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _deleteMatch(match['id']);
                },
              )
                  : null, // Only show delete button if admin
            );
          },
        );
      },
    );
  }

  // Upcoming matches page with API data
  Widget _buildUpcomingMatchesPage() {
    return FutureBuilder<List<dynamic>>(
      future: _fetchMatches('upcoming'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.hasData && snapshot.data!.isEmpty) {
          return Center(child: Text('No upcoming matches'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            var match = snapshot.data![index];
            return ListTile(
              title: Text('${match['teamAName']} vs ${match['teamBName']}'),
              subtitle: Text('Date: ${match['date']}'),
            );
          },
        );
      },
    );
  }
}
// Show dialog for adding team names and scores
