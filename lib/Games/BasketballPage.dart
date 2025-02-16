import 'package:flutter/material.dart';

class BasketballPage extends StatefulWidget {
  final bool isLoggedIn;
  final bool isAdmin; // Added isAdmin flag

  BasketballPage({required this.isLoggedIn, required this.isAdmin});

  @override
  _BasketballPageState createState() => _BasketballPageState();
}

class _BasketballPageState extends State<BasketballPage> {
  int teamAScore = 0;
  int teamBScore = 0;
  int period = 1;

  int _selectedIndex = 0; // Track the selected tab for the bottom navigation

  // Update the score based on the team
  void _updateScore(String team, int points) {
    if (widget.isAdmin) {
      setState(() {
        if (team == 'A') {
          teamAScore += points;
        } else if (team == 'B') {
          teamBScore += points;
        }
      });
    } else {
      _showUnauthorizedMessage();
    }
  }

  void _resetScores() {
    if (widget.isAdmin) {
      setState(() {
        teamAScore = 0;
        teamBScore = 0;
        period = 1;
      });
    } else {
      _showUnauthorizedMessage();
    }
  }

  void _nextPeriod() {
    if (widget.isAdmin) {
      setState(() {
        if (period < 4) {
          period++;
        }
      });
    } else {
      _showUnauthorizedMessage();
    }
  }

  // Delete all scores (reset scores and period)
  void _deleteScores() {
    if (widget.isAdmin) {
      setState(() {
        teamAScore = 0;
        teamBScore = 0;
        period = 1; // Reset period as well
      });
    } else {
      _showUnauthorizedMessage();
    }
  }

  void _showUnauthorizedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You must be an admin to perform this action!')),
    );
  }

  // Change the selected tab in the bottom navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
      ),
    );
  }

  // Display content based on selected tab
  Widget _getSelectedPage(int index) {
    switch (index) {
      case 0:
        return _buildLivePage();
      case 1:
        return _buildCompletedPage();
      case 2:
        return _buildUpcomingPage();
      default:
        return _buildLivePage();
    }
  }

  // LIVE page content
  Widget _buildLivePage() {
    final double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Period: $period',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                      'Team A',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$teamAScore',
                      style: TextStyle(fontSize: 48, color: Colors.green),
                    ),
                    SizedBox(height: 10),
                    // Update Score Buttons (Only visible if admin)
                    if (widget.isAdmin)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () => _updateScore('A', 1),
                              child: Text('+1'),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            ElevatedButton(
                              onPressed: () => _updateScore('A', 2),
                              child: Text('+2'),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            ElevatedButton(
                              onPressed: () => _updateScore('A', 3),
                              child: Text('+3'),
                            ),
                          ],
                        ),
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
                      'Team B',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '$teamBScore',
                      style: TextStyle(fontSize: 48, color: Colors.red),
                    ),
                    SizedBox(height: 10),
                    // Update Score Buttons (Only visible if admin)
                    if (widget.isAdmin)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () => _updateScore('B', 1),
                              child: Text('+1'),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            ElevatedButton(
                              onPressed: () => _updateScore('B', 2),
                              child: Text('+2'),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            ElevatedButton(
                              onPressed: () => _updateScore('B', 3),
                              child: Text('+3'),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          // Control Buttons (Only visible if admin)
          if (widget.isAdmin)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _resetScores,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[800]),
                  child: Text('Reset', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: screenWidth * 0.04),
                ElevatedButton(
                  onPressed: _nextPeriod,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text('Next Period'),
                ),
                SizedBox(width: screenWidth * 0.04),
                ElevatedButton(
                  onPressed: _deleteScores,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('Delete Scores'),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // COMPLETED page content (Placeholder)
  Widget _buildCompletedPage() {
    return Center(
      child: Text(
        'Completed Games will be displayed here.',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // UPCOMING page content (Placeholder)
  Widget _buildUpcomingPage() {
    return Center(
      child: Text(
        'Upcoming Games will be displayed here.',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

