import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/recipe_service.dart';
import '../models/categori.dart';
import '../widgets/recipe_card.dart';
import 'add_recipe_screen.dart';
import 'category_recipes_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final recipeService = Provider.of<RecipeService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Recettes de Cuisine'),
      ),
      body: ListView(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher une recette...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                // Tu peux ajouter la logique de recherche ici
              },
            ),
          ),

          // Section Recettes populaires
          if (recipeService.recipes.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Recettes populaires',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(16.0),
                itemCount: recipeService.recipes.length > 5
                    ? 5
                    : recipeService.recipes.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 200,
                    margin: EdgeInsets.only(right: 16),
                    child: RecipeCard(recipe: recipeService.recipes[index]),
                  );
                },
              ),
            ),
          ],

          // Section Catégories
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Catégories',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(16.0),
              itemCount: recipeService.categories.length,
              itemBuilder: (context, index) {
                Categori category = recipeService.categories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CategoryRecipesScreen(category: category),
                      ),
                    );
                  },
                  child: Container(
                    width: 100,
                    margin: EdgeInsets.only(right: 16.0),
                    decoration: BoxDecoration(
                      color: Color(category.color),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        category.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddRecipeScreen()),
          );
        },
      ),
    );
  }
}
