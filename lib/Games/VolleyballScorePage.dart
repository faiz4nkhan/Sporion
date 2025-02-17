import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(VolleyballScoreApp());
}

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Function to fetch all match data
  Stream<QuerySnapshot> getMatchesStream() {
    return _db.collection('matches').snapshots();
  }

  // Function to save match data
  Future<void> saveMatchData(String matchId, Map<String, dynamic> matchData) async {
    try {
      await _db.collection('matches').doc(matchId).set(matchData);
    } catch (e) {
      print("Error saving match data: $e");
    }
  }

  // Function to update match data
  Future<void> updateMatchData(String matchId, Map<String, dynamic> matchData) async {
    try {
      await _db.collection('matches').doc(matchId).update(matchData);
    } catch (e) {
      print("Error updating match data: $e");
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
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        ),
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
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // 3 tabs: Live, Upcoming, Past
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          // Live Tab
          buildMatchListTab('live'),
          // Upcoming Tab
          buildMatchListTab('upcoming'),
          // Past Tab
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
    return StreamBuilder<QuerySnapshot>(
      stream: _firebaseService.getMatchesStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        // Filter the matches based on their status
        final matches = snapshot.data!.docs.where((doc) {
          // Check if 'matchStatus' field exists before comparing
          if (doc['matchStatus'] != null) {
            return doc['matchStatus'] == status;
          }
          return false;
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
                    Text('Status: ${match['matchStatus'] ?? 'Unknown'}', // Fallback to 'Unknown' if matchStatus is null
                        style: TextStyle(fontSize: 16)),
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
                TextField(
                  controller: TextEditingController(),
                  decoration: InputDecoration(labelText: 'Enter Team A Name'),
                ),
                TextField(
                  controller: TextEditingController(),
                  decoration: InputDecoration(labelText: 'Enter Team B Name'),
                ),
                TextField(
                  controller: TextEditingController(),
                  decoration: InputDecoration(labelText: 'Match Status (Live, Upcoming, Past)'),
                ),
                TextField(
                  controller: TextEditingController(),
                  decoration: InputDecoration(labelText: 'Enter Team A Points'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: TextEditingController(),
                  decoration: InputDecoration(labelText: 'Enter Team A Sets'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: TextEditingController(),
                  decoration: InputDecoration(labelText: 'Enter Team A Games'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: TextEditingController(),
                  decoration: InputDecoration(labelText: 'Enter Team B Points'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: TextEditingController(),
                  decoration: InputDecoration(labelText: 'Enter Team B Sets'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: TextEditingController(),
                  decoration: InputDecoration(labelText: 'Enter Team B Games'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Map<String, dynamic> matchData = {
                  'teamAName': 'Team A', // Replace with controller text
                  'teamBName': 'Team B', // Replace with controller text
                  'matchStatus': 'upcoming', // Replace with controller text
                  'teamAPoints': 0,
                  'teamASets': 0,
                  'teamAGames': 0,
                  'teamBPoints': 0,
                  'teamBSets': 0,
                  'teamBGames': 0,
                };

                // Save or update data in Firestore
                _firebaseService.saveMatchData('matchId1', matchData);

                // Close dialog
                Navigator.of(context).pop();
              },
              child: Text('Save Match Info'),
            ),
          ],
        );
      },
    );
  }
}
