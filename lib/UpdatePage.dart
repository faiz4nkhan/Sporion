import 'package:flutter/material.dart';

class UpdatePage extends StatefulWidget {
  final bool isLoggedIn;

  UpdatePage({required this.isLoggedIn});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Basketball Variables
  int teamAScore = 0;
  int teamBScore = 0;
  int period = 1;

  // Cricket Variables
  int teamARuns = 0;
  int teamBRuns = 0;
  int wicketsA = 0;
  int wicketsB = 0;
  int oversA = 0;
  int oversB = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showUnauthorizedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You must log in to perform this action!')),
    );
  }

  // Basketball Score Update
  void _updateBasketballScore(String team, int points) {
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

  void _resetBasketballScores() {
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

  // Cricket Score Update
  void _updateCricketScore(String team, int runs, bool wicket) {
    if (widget.isLoggedIn) {
      setState(() {
        if (team == 'A') {
          teamARuns += runs;
          if (wicket) wicketsA++;
        } else if (team == 'B') {
          teamBRuns += runs;
          if (wicket) wicketsB++;
        }
      });
    } else {
      _showUnauthorizedMessage();
    }
  }

  void _nextOver(String team) {
    if (widget.isLoggedIn) {
      setState(() {
        if (team == 'A') {
          oversA++;
        } else if (team == 'B') {
          oversB++;
        }
      });
    } else {
      _showUnauthorizedMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Score Update'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Basketball'),
            Tab(text: 'Cricket'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Basketball Scoreboard
          _buildBasketballTab(),
          // Cricket Scoreboard
          _buildCricketTab(),
        ],
      ),
    );
  }

  Widget _buildBasketballTab() {
    return Column(
      children: [
        Text('Period: $period', style: TextStyle(fontSize: 24)),
        _buildTeamScore('A', teamAScore, Colors.green),
        _buildTeamScore('B', teamBScore, Colors.red),
        ElevatedButton(onPressed: _resetBasketballScores, child: Text('Reset')),
        ElevatedButton(onPressed: _nextPeriod, child: Text('Next Period')),
      ],
    );
  }

  Widget _buildCricketTab() {
    return Column(
      children: [
        _buildCricketTeamScore('A', teamARuns, wicketsA, oversA),
        _buildCricketTeamScore('B', teamBRuns, wicketsB, oversB),
      ],
    );
  }

  Widget _buildTeamScore(String team, int score, Color color) {
    return Column(
      children: [
        Text('Team $team', style: TextStyle(fontSize: 18)),
        Text('$score', style: TextStyle(fontSize: 48, color: color)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _updateBasketballScore(team, 1),
              child: Text('+1'),
            ),
            ElevatedButton(
              onPressed: () => _updateBasketballScore(team, 2),
              child: Text('+2'),
            ),
            ElevatedButton(
              onPressed: () => _updateBasketballScore(team, 3),
              child: Text('+3'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCricketTeamScore(String team, int runs, int wickets, int overs) {
    return Column(
      children: [
        Text('Team $team', style: TextStyle(fontSize: 18)),
        Text('Runs: $runs / Wickets: $wickets / Overs: $overs',
            style: TextStyle(fontSize: 24)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _updateCricketScore(team, 1, false),
              child: Text('1 Run'),
            ),
            ElevatedButton(
              onPressed: () => _updateCricketScore(team, 4, false),
              child: Text('4 Runs'),
            ),
            ElevatedButton(
              onPressed: () => _updateCricketScore(team, 6, false),
              child: Text('6 Runs'),
            ),
            ElevatedButton(
              onPressed: () => _updateCricketScore(team, 0, true),
              child: Text('Wicket'),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () => _nextOver(team),
          child: Text('Next Over'),
        ),
      ],
    );
  }
}
