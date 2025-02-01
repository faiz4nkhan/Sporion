import 'package:flutter/material.dart';

class BasketballPage extends StatefulWidget {
  final bool isLoggedIn;

  BasketballPage({required this.isLoggedIn});

  @override
  _BasketballPageState createState() => _BasketballPageState();
}

class _BasketballPageState extends State<BasketballPage> {
  int teamAScore = 0;
  int teamBScore = 0;
  int period = 1;

  void _updateScore(String team, int points) {
    if (widget.isLoggedIn) {
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
    if (widget.isLoggedIn) {
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
    if (widget.isLoggedIn) {
      setState(() {
        if (period < 4) {
          period++;
        }
      });
    } else {
      _showUnauthorizedMessage();
    }
  }

  void _showUnauthorizedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You must log in to perform this action!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Basketball Scoreboard'),
        backgroundColor: Colors.blueAccent,
      ),
      body: widget.isLoggedIn
          ? SingleChildScrollView(
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
                      CircleAvatar(
                        backgroundImage:
                        AssetImage('assets/images/teamA.jpg'),
                        radius: 50,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Team A',
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '$teamAScore',
                        style: TextStyle(fontSize: 48, color: Colors.green),
                      ),
                      SizedBox(height: 10),
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
                      CircleAvatar(
                        backgroundImage:
                        AssetImage('assets/images/teamB.jpg'),
                        radius: 50,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Team B',
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '$teamBScore',
                        style: TextStyle(fontSize: 48, color: Colors.red),
                      ),
                      SizedBox(height: 10),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _resetScores,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800]),
                  child: Text('Reset', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: screenWidth * 0.04),
                ElevatedButton(
                  onPressed: _nextPeriod,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text('Next Period'),
                ),
              ],
            ),
          ],
        ),
      )
          : Center(
        child: Text(
          'You must log in to view this page!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
