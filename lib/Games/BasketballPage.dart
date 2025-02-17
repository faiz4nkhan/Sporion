import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  // Real-time reference to Firestore match
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late DocumentReference matchRef;

  // Text editing controllers for team names and scores
  TextEditingController teamAController = TextEditingController();
  TextEditingController teamBController = TextEditingController();
  TextEditingController teamAScoreController = TextEditingController();
  TextEditingController teamBScoreController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Set Firestore reference to match document (could be dynamic)
    matchRef = _firestore.collection('basketballmatches').doc(matchId);

    // Real-time listener for score and team name updates
    matchRef.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        setState(() {
          teamAScore = snapshot['teamAScore'];
          teamBScore = snapshot['teamBScore'];
          period = snapshot['period'];
          teamAName = snapshot['teamAName'];
          teamBName = snapshot['teamBName'];
        });
      }
    });
  }

  // Update team names and scores in Firebase
  void _updateMatchDetails() {
    if (widget.isAdmin) {
      // Update team names and scores in Firestore
      matchRef.update({
        'teamAName': teamAController.text,
        'teamBName': teamBController.text,
        'teamAScore': teamAScore,
        'teamBScore': teamBScore,
        'period': period,
      });
      setState(() {
        teamAName = teamAController.text;
        teamBName = teamBController.text;
      });
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
  void _onPositiveButtonPressed() {
    _showDialogToAddDetails();
  }

  // Show dialog for adding team names and scores
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

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

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

  // Past matches page with real-time updates
  Widget _buildPastMatchesPage() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('basketballmatches')
          .where('matchStatus', isEqualTo: 'completed')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No completed matches'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var match = snapshot.data!.docs[index];
            return ListTile(
              title: Text('${match['teamAName']} vs ${match['teamBName']}'),
              subtitle: Text('Score: ${match['teamAScore']} - ${match['teamBScore']}'),
              trailing: widget.isAdmin
                  ? IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  // Show confirmation dialog before deleting
                  bool? confirmDelete = await _confirmDelete();
                  if (confirmDelete == true) {
                    await FirebaseFirestore.instance
                        .collection('basketballmatches')
                        .doc(match.id)
                        .delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Match Deleted')),
                    );
                  }
                },
              )
                  : null, // Only show delete button if admin
            );
          },
        );
      },
    );
  }

  // Confirm deletion for past match
  Future<bool?> _confirmDelete() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this match?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Upcoming matches page with real-time updates
  Widget _buildUpcomingMatchesPage() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('basketballmatches')
          .where('matchStatus', isEqualTo: 'upcoming')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No upcoming matches'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var match = snapshot.data!.docs[index];
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
