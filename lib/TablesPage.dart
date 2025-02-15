import 'package:flutter/material.dart';

class TablesPage extends StatefulWidget {
  @override
  _SportsTablePageState createState() => _SportsTablePageState();
}

class _SportsTablePageState extends State<TablesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Methods to build each tab's content
  Widget _buildBasketballTab() {
    return Center(child: Text('Basketball Scoreboard'));
  }

  Widget _buildCricketTab() {
    return Center(child: Text('Cricket Scoreboard'));
  }

  Widget _buildVolleyballTab() {
    return Center(child: Text('Volleyball Scoreboard'));
  }

  Widget _buildKhoKhoTab() {
    return Center(child: Text('Kho-Kho Scoreboard'));
  }

  Widget _buildKabaddiTab() {
    return Center(child: Text('Kabaddi Scoreboard'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tables'),  // Change the title to "Tables"
        backgroundColor: Colors.blue, // Set the AppBar background color to blue
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true, // Enable horizontal scrolling for tabs
          tabs: [
            Tab(text: 'Basketball'),
            Tab(text: 'Cricket'),
            Tab(text: 'Volleyball'),
            Tab(text: 'Kho-Kho'),
            Tab(text: 'Kabaddi'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBasketballTab(),
          _buildCricketTab(),
          _buildVolleyballTab(),
          _buildKhoKhoTab(),
          _buildKabaddiTab(),
        ],
      ),
    );
  }
}
