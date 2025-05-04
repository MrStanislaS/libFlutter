import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final Color? color;

  const CategoryCard({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: color ?? Colors.orange[100], // Couleur par défaut si non spécifiée
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}