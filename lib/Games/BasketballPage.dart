import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class BasketballPage extends StatefulWidget {
  final bool isLoggedIn;
  final bool isAdmin;

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
  String matchId = "match1";
  String matchStatus = "Status";

  int _selectedIndex = 0;

  TextEditingController teamAController = TextEditingController();
  TextEditingController teamBController = TextEditingController();
  TextEditingController teamAScoreController = TextEditingController();
  TextEditingController teamBScoreController = TextEditingController();
  TextEditingController matchStatuses = TextEditingController();
  TextEditingController winners = TextEditingController();

  final String apiUrl = "https://bec3-117-235-167-111.ngrok-free.app/api/basketball";

  // Fetch match data from the API
  Future<List<dynamic>> _fetchMatches(String status) async {
    final String endpoint;
print(status);
    if (status == 'live') {
    endpoint = '$apiUrl/get-live';
    }
    else if (status == 'completed') {
      endpoint = '$apiUrl/get-completed';
    } else if (status == 'upcoming') {
      endpoint = '$apiUrl/get-scheduled';
    }  else {
      throw Exception("Invalid match status: $status");
    }
    print(endpoint);

    final response = await http.get(Uri.parse(endpoint));
print(response);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
print("sfdgsdf: $data,$status");
      if (data is Map<String, dynamic> && data.containsKey('matches')) {
        return data['matches'] as List<dynamic>;
      } else {
        throw Exception("Invalid data format: Expected a list under 'matches' key");
      }
    } else {
      throw Exception('Failed to load matches');
    }
  }

  // Add a match using its details (admin only)
  Future<void> _addMatch() async {
    if (!widget.isAdmin) {
      _showUnauthorizedMessage();
      return;
    }

    final matchData = {
      'teamAName': teamAController.text,
      'teamBName': teamBController.text,
      'teamAScore': int.tryParse(teamAScoreController.text) ?? 0,
      'teamBScore': int.tryParse(teamBScoreController.text) ?? 0,
      'period': period,
      'matchStatus': matchStatuses.text,
      'winner': winners.text
    };

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/add-match'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(matchData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Match Added Successfully')));
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add match')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _deleteMatch(String matchId) async {
    if (!widget.isAdmin) {
      _showUnauthorizedMessage();
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/delete-match/$matchId'),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Match Deleted Successfully')));
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete match')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _showUnauthorizedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You must be an admin to perform this action!')));
  }

  // Update match details (admin only)
  void _updateMatchDetails() {
    if (widget.isAdmin) {
      final matchData = {
        'teamAName': teamAController.text,
        'teamBName': teamBController.text,
        'teamAScore': teamAScore,
        'teamBScore': teamBScore,
        'period': period,
      };
      http.put(Uri.parse('$apiUrl/$matchId'), body: json.encode(matchData));
    } else {
      _showUnauthorizedMessage();
    }
  }

  void _showDialogToAddMatch() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Match'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: teamAController,
                decoration: InputDecoration(labelText: 'Team A Name'),
              ),
              TextField(
                controller: teamBController,
                decoration: InputDecoration(labelText: 'Team B Name'),
              ),
              TextField(
                controller: teamAScoreController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Team A Score'),
              ),
              TextField(
                controller: teamBScoreController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Team B Score'),
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Period'),
                onChanged: (value) => period = int.tryParse(value) ?? 1,
              ),
              TextField(
                controller: matchStatuses,
                decoration: InputDecoration(labelText: 'Match Status'),
              ),
              TextField(
                controller: winners,
                decoration: InputDecoration(labelText: 'Winner'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addMatch();
                Navigator.of(context).pop();
              },
              child: Text('Add Match'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Basketball Scoreboard'),
          backgroundColor: Colors.pinkAccent,
          centerTitle: true,

          bottom: TabBar(
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: [
              Tab(text: 'PAST MATCHES'),
              Tab(text: 'UPCOMING'),
              Tab(text: 'LIVE'),
            ],
          ),
        ),
        body: widget.isLoggedIn ? _getSelectedPage(_selectedIndex) : Center(
          child: Text('You must log in to view this page!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        floatingActionButton: widget.isAdmin ? FloatingActionButton(
          onPressed: _showDialogToAddMatch,
          backgroundColor: Colors.green,
          child: Icon(Icons.add),
        ) : null,
      ),
    );
  }

  Widget _getSelectedPage(int index) {
    print(index);
    switch (index) {
      case 0: return _buildPastMatchesPage();
      case 1: return _buildUpcomingMatchesPage();
      case 2: return _buildLivePage();
      default: return _buildLivePage();
    }
  }

  Widget _buildLivePage() {
    return FutureBuilder<List<dynamic>>(
      future: _fetchMatches('live'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.hasData && snapshot.data!.isEmpty) {
          return Center(child: Text('No matches found'));
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
                  _deleteMatch(match['_id']);
                },
              )
                  : null,
            );
          },
        );
      },
    );
  }


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
                  _deleteMatch(match['_id']);
                },
              )
                  : null,
            );
          },
        );
      },
    );
  }

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
              trailing: widget.isAdmin
                  ? IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _deleteMatch(match['_id']);
                },
              )
                  : null,
            );
          },
        );
      },
    );
  }
}
