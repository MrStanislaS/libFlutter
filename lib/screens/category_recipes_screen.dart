import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/categori.dart';
import '../services/recipe_service.dart';
import '../widgets/recipe_card.dart';

class CategoryRecipesScreen extends StatelessWidget {
  final Categori category;

  const CategoryRecipesScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: Color(category.color),
      ),
      body: Consumer<RecipeService>(
        builder: (context, recipeService, child) {
          final categoryRecipes = recipeService.getRecipesByCategory(category.id);

          if (categoryRecipes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    size: 60,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aucune recette dans cette catégorie',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ajoutez des recettes à cette catégorie pour les retrouver ici',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: categoryRecipes.length,
            itemBuilder: (context, index) {
              return RecipeCard(recipe: categoryRecipes[index]);
            },
          );
        },
      ),
    );
  }
}
