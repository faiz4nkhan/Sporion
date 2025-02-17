import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(VolleyballScoreApp());
}

class ApiService {
  final String baseUrl = 'https://your-api-url.com'; // Replace with your API base URL

  // Function to fetch all match data
  Future<List<Map<String, dynamic>>> getMatches() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/matches'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((match) => match as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to load matches');
      }
    } catch (e) {
      print("Error fetching match data: $e");
      return [];
    }
  }

  // Function to save match data (for adding new match)
  Future<void> saveMatchData(Map<String, dynamic> matchData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/matches'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(matchData),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to add match');
      }
    } catch (e) {
      print("Error saving match data: $e");
    }
  }

  // Function to update match data
  Future<void> updateMatchData(String matchId, Map<String, dynamic> matchData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/matches/$matchId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(matchData),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update match');
      }
    } catch (e) {
      print("Error updating match data: $e");
    }
  }

  // Function to delete match
  Future<void> deleteMatch(String matchId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/matches/$matchId'));
      if (response.statusCode != 200) {
        throw Exception('Failed to delete match');
      }
    } catch (e) {
      print("Error deleting match: $e");
    }
  }
}

class VolleyballScoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Volleyball Score App',
      theme: ThemeData(
        primaryColor: Colors.blue,
        textTheme: TextTheme(bodyLarge: TextStyle(color: Colors.white)),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.amber),
      ),
      home: VolleyballScorePage(isAdmin: true), // Set isAdmin flag to true or false
    );
  }
}

class VolleyballScorePage extends StatefulWidget {
  final bool isAdmin; // Flag to differentiate between admin and user

  VolleyballScorePage({required this.isAdmin});

  @override
  _VolleyballScorePageState createState() => _VolleyballScorePageState();
}

class _VolleyballScorePageState extends State<VolleyballScorePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _apiService = ApiService();
  final TextEditingController teamANameController = TextEditingController();
  final TextEditingController teamBNameController = TextEditingController();
  final TextEditingController matchStatusController = TextEditingController();
  final TextEditingController teamAPointsController = TextEditingController();
  final TextEditingController teamASetsController = TextEditingController();
  final TextEditingController teamAGamesController = TextEditingController();
  final TextEditingController teamBPointsController = TextEditingController();
  final TextEditingController teamBSetsController = TextEditingController();
  final TextEditingController teamBGamesController = TextEditingController();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // 3 tabs: Live, Upcoming, Past
    _startPolling();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Function to start polling for real-time updates
  void _startPolling() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {
        // Trigger a re-fetch of data every 10 seconds
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text('Volleyball Score'),
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
          buildMatchListTab('live'),
          buildMatchListTab('upcoming'),
          buildMatchListTab('past'),
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
          : null, // No floating action button for non-admin users
    );
  }

  // Function to build match list based on match status
  Widget buildMatchListTab(String status) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _apiService.getMatches(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final matches = snapshot.data!.where((doc) {
          return doc['matchStatus'] == status;
        }).toList();

        if (matches.isEmpty) {
          return Center(child: Text('No $status matches found.'));
        }

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
                      '${match['teamAName']} vs ${match['teamBName']}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text('Status: ${match['matchStatus'] ?? 'Unknown'}', style: TextStyle(fontSize: 16)),
                    Text('Team A Points: ${match['teamAPoints']}'),
                    Text('Team B Points: ${match['teamBPoints']}'),
                    Text('Team A Sets: ${match['teamASets']}'),
                    Text('Team B Sets: ${match['teamBSets']}'),
                    Text('Team A Games: ${match['teamAGames']}'),
                    Text('Team B Games: ${match['teamBGames']}'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Function to show admin dialog to add match data
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
                _buildTextField(teamANameController, 'Enter Team A Name'),
                _buildTextField(teamBNameController, 'Enter Team B Name'),
                _buildTextField(matchStatusController, 'Match Status (Live, Upcoming, Past)'),
                _buildTextField(teamAPointsController, 'Enter Team A Points', TextInputType.number),
                _buildTextField(teamASetsController, 'Enter Team A Sets', TextInputType.number),
                _buildTextField(teamAGamesController, 'Enter Team A Games', TextInputType.number),
                _buildTextField(teamBPointsController, 'Enter Team B Points', TextInputType.number),
                _buildTextField(teamBSetsController, 'Enter Team B Sets', TextInputType.number),
                _buildTextField(teamBGamesController, 'Enter Team B Games', TextInputType.number),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Map<String, dynamic> matchData = {
                  'teamAName': teamANameController.text,
                  'teamBName': teamBNameController.text,
                  'matchStatus': matchStatusController.text.isEmpty ? 'Upcoming' : matchStatusController.text,
                  'teamAPoints': int.tryParse(teamAPointsController.text) ?? 0,
                  'teamASets': int.tryParse(teamASetsController.text) ?? 0,
                  'teamAGames': int.tryParse(teamAGamesController.text) ?? 0,
                  'teamBPoints': int.tryParse(teamBPointsController.text) ?? 0,
                  'teamBSets': int.tryParse(teamBSetsController.text) ?? 0,
                  'teamBGames': int.tryParse(teamBGamesController.text) ?? 0,
                };

                _apiService.saveMatchData(matchData);
                Navigator.of(context).pop();
              },
              child: Text('Save Match Info'),
            ),
          ],
        );
      },
    );
  }

  // Helper function to build text fields
  Widget _buildTextField(TextEditingController controller, String labelText, [TextInputType keyboardType = TextInputType.text]) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: labelText),
    );
  }
}
