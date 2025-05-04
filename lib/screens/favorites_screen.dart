import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/recipe_service.dart';
import '../widgets/recipe_card.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recettes favorites'),
      ),
      body: Consumer<RecipeService>(
        builder: (context, recipeService, child) {
          final favoriteRecipes = recipeService.getFavoriteRecipes();

          if (favoriteRecipes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 60,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aucune recette favorite',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ajoutez des recettes à vos favoris pour les retrouver ici',
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
            itemCount: favoriteRecipes.length,
            itemBuilder: (context, index) {
              return RecipeCard(recipe: favoriteRecipes[index]);
            },
          );
        },
      ),
    );
  }
}
