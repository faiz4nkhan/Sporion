import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
      ),
      body: ArticlePage(),
    );
  }
}

class ArticlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Container
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.black,
            child: Text(
              'The match is over, but the spirit of the game lives on! 🎉🤝',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 16),

          // Image Container
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Image.asset(
              'assets/images/news1.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 16),

          // Content Text
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              "After a tough battle between Team A and Team B, both teams showed true sportsmanship. No matter the result, players came together, shook hands, and celebrated the effort they put in.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),

          // Additional Articles
          _buildArticle(
            title: '"Unity Over Victory: A Moment of True Sportsmanship".',
            imagePath: 'assets/images/news2.jpg',
            content:
            "Before the match, Team A and Team B were lined up on the field, exchanging handshakes with smiles and mutual respect. The players, in their team jerseys, stood side by side, celebrating the unity and camaraderie that sports bring.",
          ),
          _buildArticle(
            title: '"Boy Shows True Dedication to Basketball 🏀"',
            imagePath: 'assets/images/news3.jpg',
            content:
            "In a heartwarming moment on the court, a player gave it his all while playing basketball 🏀. With the ball in hand and focus in his eyes, he showed his passion for the game. Despite being one of the newer players, his energy and effort were clear as he dribbled and made strong plays."
                "It’s not just about winning or losing—it’s about giving your best and loving the game."

              "#Basketball 🏀 #Dedication #Passion #LiveBuzz",

          ),
          _buildArticle(
            title: '"Team Unity on Display in Tug of War Challenge 💪"',
            imagePath: 'assets/images/news4.jpg',
            content:
            "In an intense tug of war game, both teams held the rope tightly, giving their all to secure victory. The players pulled with all their strength, showing teamwork and determination as they worked together."

              "The match was full of energy and excitement, with every player giving their best to help their team win. The competition was fierce, but in the end, both teams proved that sports are all about effort and unity."

          "#TugOfWar 💪 #Teamwork #Unity #LiveBuzz",
          ),
        ],
      ),
    );
  }

  Widget _buildArticle({required String title, required String imagePath, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          color: Colors.black,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
