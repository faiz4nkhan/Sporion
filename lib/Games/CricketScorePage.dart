import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(CricketScoreApp());
}

class CricketScoreApp extends StatelessWidget {
  const CricketScoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cricket Score App',
      theme: ThemeData(
        primaryColor: Colors.green,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.amber),
      ),
      home: CricketScorePage(isAdmin: true), // Set this to 'true' for admin, 'false' for user
    );
  }
}

class Match {
  String teamAName;
  String teamBName;
  int teamARuns;
  int teamAWickets;
  double teamAOvers;
  int teamBRuns;
  int teamBWickets;
  double teamBOvers;
  String status; // "upcoming", "live", "past"
  String docId; // To store the document ID for deletion

  Match({
    required this.teamAName,
    required this.teamBName,
    this.teamARuns = 0,
    this.teamAWickets = 0,
    this.teamAOvers = 0.0,
    this.teamBRuns = 0,
    this.teamBWickets = 0,
    this.teamBOvers = 0.0,
    required this.status,
    required this.docId, // Add docId to the constructor
  });
}

class CricketScorePage extends StatefulWidget {
  final bool isAdmin;

  CricketScorePage({super.key, required this.isAdmin});

  @override
  _CricketScorePageState createState() => _CricketScorePageState();
}

class _CricketScorePageState extends State<CricketScorePage> {
  List<Match> pastMatches = [];
  List<Match> upcomingMatches = [];
  List<Match> liveMatches = [];

  @override
  void initState() {
    super.initState();
    fetchMatches();

    // Set up periodic polling every 30 seconds (or adjust as needed)
    Timer.periodic(const Duration(seconds: 30), (Timer t) => fetchMatches());
  }

  Future<void> fetchMatches() async {
    // Listen to Firestore collection for real-time updates
    FirebaseFirestore.instance
        .collection('matches')
        .snapshots()  // Real-time updates
        .listen((snapshot) {
      if (!mounted) return; // Check if the widget is still mounted

      setState(() {
        pastMatches.clear();
        upcomingMatches.clear();
        liveMatches.clear();

        for (var matchData in snapshot.docs) {
          Match match = Match(
            teamAName: matchData['teamAName'],
            teamBName: matchData['teamBName'],
            teamARuns: matchData['teamARuns'] ?? 0,
            teamAWickets: matchData['teamAWickets'] ?? 0,
            teamAOvers: matchData['teamAOvers']?.toDouble() ?? 0.0,
            teamBRuns: matchData['teamBRuns'] ?? 0,
            teamBWickets: matchData['teamBWickets'] ?? 0,
            teamBOvers: matchData['teamBOvers']?.toDouble() ?? 0.0,
            status: matchData['status'] ?? 'upcoming',
            docId: matchData.id, // Store the document ID
          );

          if (match.status == 'past') {
            pastMatches.add(match);
          } else if (match.status == 'upcoming') {
            upcomingMatches.add(match);
          } else if (match.status == 'live') {
            liveMatches.add(match);
          }
        }
      });
    });
  }
  // Your async operation or stream subscription

  // Before calling setState, check if the widget is still mounted


  // Method to delete a match
  void deleteMatch(Match match) {
    setState(() {
      if (match.status == "past") {
        pastMatches.remove(match);
      } else if (match.status == "upcoming") {
        upcomingMatches.remove(match);
      } else {
        liveMatches.remove(match);
      }
    });

    // Delete the match document from Firestore
    FirebaseFirestore.instance.collection('matches').doc(match.docId).delete().then((_) {
      print("Match deleted successfully");
    }).catchError((error) {
      print("Failed to delete match: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent,
          title: const Text('Cricket Score'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'PAST MATCHES'),
              Tab(text: 'UPCOMING'),
              Tab(text: 'LIVE'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // PAST MATCHES Tab
            ListView.builder(
              itemCount: pastMatches.length,
              itemBuilder: (context, index) {
                Match match = pastMatches[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text("${match.teamAName} vs ${match.teamBName}"),
                    subtitle: Text("Score: ${match.teamARuns}/${match.teamAWickets} (${match.teamAOvers} overs) vs ${match.teamBRuns}/${match.teamBWickets} (${match.teamBOvers} overs)"),
                    trailing: widget.isAdmin
                        ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditDialog(match);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deleteMatch(match); // Call delete method
                          },
                        ),
                      ],
                    )
                        : null,
                  ),
                );
              },
            ),
            // UPCOMING Tab
            ListView.builder(
              itemCount: upcomingMatches.length,
              itemBuilder: (context, index) {
                Match match = upcomingMatches[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text("${match.teamAName} vs ${match.teamBName}"),
                    subtitle: Text("Status: ${match.status}"),
                    trailing: widget.isAdmin
                        ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditDialog(match);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deleteMatch(match); // Call delete method
                          },
                        ),
                      ],
                    )
                        : null,
                  ),
                );
              },
            ),
            // LIVE Tab
            ListView.builder(
              itemCount: liveMatches.length,
              itemBuilder: (context, index) {
                Match match = liveMatches[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text("${match.teamAName} vs ${match.teamBName}"),
                    subtitle: Text("Score: ${match.teamARuns}/${match.teamAWickets} (${match.teamAOvers} overs) vs ${match.teamBRuns}/${match.teamBWickets} (${match.teamBOvers} overs)"),
                    trailing: widget.isAdmin
                        ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditDialog(match);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deleteMatch(match); // Call delete method
                          },
                        ),
                      ],
                    )
                        : null,
                  ),
                );
              },
            ),
          ],
        ),
        floatingActionButton: widget.isAdmin
            ? FloatingActionButton(
          onPressed: () {
            _showAddMatchDialog();
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.green[700],
        )
            : null,
      ),
    );
  }

  // Function to show the dialog for adding a new match
  void _showAddMatchDialog() {
    TextEditingController teamAController = TextEditingController();
    TextEditingController teamBController = TextEditingController();
    String selectedStatus = "upcoming";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Match'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: teamAController,
                decoration: const InputDecoration(labelText: 'Team A Name'),
              ),
              TextField(
                controller: teamBController,
                decoration: const InputDecoration(labelText: 'Team B Name'),
              ),
              DropdownButton<String>(
                value: selectedStatus,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedStatus = newValue!;
                  });
                },
                items: <String>['upcoming', 'live', 'past']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (teamAController.text.isNotEmpty && teamBController.text.isNotEmpty) {
                  addNewMatch(teamAController.text, teamBController.text, selectedStatus);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add Match'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Function to show the dialog for editing match scores
  void _showEditDialog(Match match) {
    TextEditingController teamARunController = TextEditingController(text: match.teamARuns.toString());
    TextEditingController teamAWicketController = TextEditingController(text: match.teamAWickets.toString());
    TextEditingController teamAOverController = TextEditingController(text: match.teamAOvers.toString());
    TextEditingController teamBRunController = TextEditingController(text: match.teamBRuns.toString());
    TextEditingController teamBWicketController = TextEditingController(text: match.teamBWickets.toString());
    TextEditingController teamBOverController = TextEditingController(text: match.teamBOvers.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Match: ${match.teamAName} vs ${match.teamBName}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: teamARunController,
                decoration: const InputDecoration(labelText: 'Team A Runs'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: teamAWicketController,
                decoration: const InputDecoration(labelText: 'Team A Wickets'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: teamAOverController,
                decoration: const InputDecoration(labelText: 'Team A Overs'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: teamBRunController,
                decoration: const InputDecoration(labelText: 'Team B Runs'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: teamBWicketController,
                decoration: const InputDecoration(labelText: 'Team B Wickets'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: teamBOverController,
                decoration: const InputDecoration(labelText: 'Team B Overs'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                updateMatch(match, teamARunController.text, teamAWicketController.text, teamAOverController.text,
                    teamBRunController.text, teamBWicketController.text, teamBOverController.text);
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Update the match details
  void updateMatch(Match match, String teamARuns, String teamAWickets, String teamAOvers, String teamBRuns, String teamBWickets, String teamBOvers) {
    FirebaseFirestore.instance.collection('matches').doc(match.docId).update({
      'teamARuns': int.tryParse(teamARuns) ?? 0,
      'teamAWickets': int.tryParse(teamAWickets) ?? 0,
      'teamAOvers': double.tryParse(teamAOvers) ?? 0.0,
      'teamBRuns': int.tryParse(teamBRuns) ?? 0,
      'teamBWickets': int.tryParse(teamBWickets) ?? 0,
      'teamBOvers': double.tryParse(teamBOvers) ?? 0.0,
    }).then((_) {
      print("Match updated successfully");
    }).catchError((error) {
      print("Failed to update match: $error");
    });
  }

  // Function to add a new match
  void addNewMatch(String teamA, String teamB, String status) {
    FirebaseFirestore.instance.collection('matches').add({
      'teamAName': teamA,
      'teamBName': teamB,
      'status': status,
      'teamARuns': 0,
      'teamAWickets': 0,
      'teamAOvers': 0.0,
      'teamBRuns': 0,
      'teamBWickets': 0,
      'teamBOvers': 0.0,
    }).then((docRef) {
      print("New match added with ID: ${docRef.id}");
    }).catchError((error) {
      print("Failed to add match: $error");
    });
  }
}
