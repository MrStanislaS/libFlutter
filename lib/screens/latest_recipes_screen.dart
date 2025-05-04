import 'package:flutter/material.dart';

class LatestRecipesScreen extends StatelessWidget {
  final List<Map<String, String>> latestRecipes = [
    {
      'title': 'Spaghetti Carbonara',
      'image': 'assets/images/recipe1.jpg',
    },
    {
      'title': 'Poulet au curry',
      'image': 'assets/images/recipe2.jpg',
    },
    {
      'title': 'Tarte aux pommes',
      'image': 'assets/images/recipe3.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        title: Text('Dernières Recettes'),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: latestRecipes.length,
        itemBuilder: (context, index) {
          final recipe = latestRecipes[index];
          return Container(
            margin: EdgeInsets.only(bottom: 16),
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(recipe['image']!),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(16),
            child: Text(
              recipe['title']!,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
              ),
            ),
          );
        },
      ),
    );
  }
}