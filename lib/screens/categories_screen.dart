import 'package:flutter/material.dart';
import '../models/categori.dart';
import 'package:provider/provider.dart';
import '../services/recipe_service.dart';
import 'category_recipes_screen.dart';

class CategoriesScreen extends StatelessWidget {
  @override
Widget build(BuildContext context) {
  final recipeService = Provider.of<RecipeService>(context);
  final categories = recipeService.categories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        title: Text('Catégories'),
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 160,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final cat = categories[index];
          return GestureDetector(
            onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CategoryRecipesScreen(category: cat),
    ),
  );
},// Naviguer vers les recettes de la catégorie
            },
            child: Container(
              decoration: BoxDecoration(
                color: cat['color'].withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(cat['image']),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    cat['color'].withOpacity(0.4),
                    BlendMode.darken,
                  ),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                cat['name'],
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}