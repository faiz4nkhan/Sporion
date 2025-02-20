import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../global.dart';
class KhokhoPage extends StatefulWidget {
  final bool isLoggedIn;
  final bool isAdmin;

  KhokhoPage({required this.isLoggedIn, required this.isAdmin});

  @override
  _KhokhoPageState createState() => _KhokhoPageState();
}

class _KhokhoPageState extends State< KhokhoPage> {
  int teamAScore = 0;
  int teamBScore = 0;
 // int period = 1;
  String teamAName = "Team A";
  String teamBName = "Team B";
  String matchId = "match1";
  String matchStatus = "Status";
  String winnerss='Team A';

  int _selectedIndex = 0;

  TextEditingController teamAController = TextEditingController();
  TextEditingController teamBController = TextEditingController();
  TextEditingController teamAScoreController = TextEditingController();
  TextEditingController teamBScoreController = TextEditingController();
  TextEditingController matchStatuses = TextEditingController();
  TextEditingController winners = TextEditingController();

  final String apiUrl = "$api/kho-kho";

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
     // 'period': period,
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
        //'period': period,
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
          content: SingleChildScrollView(
            child: Column(
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
               /* TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Period'),
                  onChanged: (value) => period = int.tryParse(value) ?? 1,
                ),*/
                DropdownButtonFormField<String>(
                  value: matchStatuses.text.isNotEmpty ? matchStatuses.text : null,
                  decoration: InputDecoration(labelText: 'Match Status'),
                  items: ['completed', 'live', 'scheduled']
                      .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ))
                      .toList(),
                  onChanged: (value) {
                    matchStatuses.text = value ?? '';
                  },
                ),
                TextField(
                  controller: winners,
                  decoration: InputDecoration(labelText: 'Winner'),
                ),
              ],
            ),
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
          leading: IconButton(
            icon: Icon(Icons.sports_kabaddi_rounded, color: Colors.black),
            onPressed: () {},
          ),
          title: Text('Kho-Kho '),
          backgroundColor: Colors.white,
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
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _editMatch(match);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteMatch(match['_id']);
                    },
                  ),
                ],
              )
                  : null,
            );
          },
        );
      },
    );
  }
  void _editMatch(Map<String, dynamic> match) {
    TextEditingController teamANameController = TextEditingController(text: match['teamAName']);
    TextEditingController teamBNameController = TextEditingController(text: match['teamBName']);
    TextEditingController teamAScoreController = TextEditingController(text: match['teamAScore'].toString());
    TextEditingController teamBScoreController = TextEditingController(text: match['teamBScore'].toString());
    String matchStatus = match['matchStatus'].toString();
    TextEditingController winnersController = TextEditingController(text: match['winner'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Match'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: teamANameController,
                      decoration: InputDecoration(labelText: 'Team A Name'),
                      onChanged: (value) => setState(() {}),
                    ),
                    TextField(
                      controller: teamBNameController,
                      decoration: InputDecoration(labelText: 'Team B Name'),
                      onChanged: (value) => setState(() {}),
                    ),
                    TextField(
                      controller: teamAScoreController,
                      decoration: InputDecoration(labelText: 'Team A Score'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => setState(() {}),
                    ),
                    TextField(
                      controller: teamBScoreController,
                      decoration: InputDecoration(labelText: 'Team B Score'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => setState(() {}),
                    ),
                    DropdownButtonFormField<String>(
                      value: matchStatus,
                      decoration: InputDecoration(labelText: 'Match Status'),
                      items: ['completed', 'live', 'scheduled']
                          .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          matchStatus = value ?? '';
                        });
                      },
                    ),
                    TextField(
                      controller: winnersController,
                      decoration: InputDecoration(labelText: 'Winner Team'),
                      onChanged: (value) => setState(() {}),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    _updateMatch(
                      match['_id'],
                      teamANameController.text,
                      teamBNameController.text,
                      int.tryParse(teamAScoreController.text) ?? 0,
                      int.tryParse(teamBScoreController.text) ?? 0,
                      matchStatus,
                      winnersController.text,
                    );
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
  Future<void> _updateMatch(
      String matchId,
      String teamAName,
      String teamBName,
      int teamAScore,
      int teamBScore,
      String matchStatus,
      String winner,
      ) async {
    if (!widget.isAdmin) {
      _showUnauthorizedMessage();
      return;
    }

    final matchData = {
      'teamAName': teamAName,
      'teamBName': teamBName,
      'teamAScore': teamAScore,
      'teamBScore': teamBScore,
      'matchStatus': matchStatus,
      'winner': winner,
    };

    try {
      final response = await http.put(
        Uri.parse('$apiUrl/update-match/$matchId'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(matchData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Match Updated Successfully')),
        );

        // Update UI in real time
        setState(() {
          // Refresh or fetch updated data from API
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update match')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
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
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _editMatch(match);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteMatch(match['_id']);
                    },
                  ),
                ],
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
              subtitle: Text('Score: ${match['teamAScore']} - ${match['teamBScore']}'),
              trailing: widget.isAdmin
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      _editMatch(match);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteMatch(match['_id']);
                    },
                  ),
                ],
              )
                  : null,

            );
          },
        );
      },
    );
  }
}
