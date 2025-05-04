import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  RecipeCard({required this.title, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(12),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            shadows: [Shadow(color: Colors.black54, blurRadius: 5)],
          ),
        ),
      ),
    );
  }
}