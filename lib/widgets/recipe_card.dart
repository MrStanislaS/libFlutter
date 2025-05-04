import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../screens/recipe_detail_screen.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipeService = Provider.of<RecipeService>(context);
    final category = recipeService.getCategoryById(recipe.categoryId);

    return Card(
      margin: EdgeInsets.only(bottom: 16.0),
      clipBehavior: Clip.antiAlias,
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RecipeDetailScreen(recipe: recipe),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: recipe.imageUrl.isNotEmpty
                      ? Image.network(
                    recipe.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[300],
                      child: Icon(
                        Icons.restaurant,
                        size: 60,
                        color: Colors.grey[500],
                      ),
                    ),
                  )
                      : Container(
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.restaurant,
                      size: 60,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                // Catégorie
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(category.color),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      category.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                // Favoris
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      recipeService.toggleFavorite(recipe.id);
                    },
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        recipe.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: recipe.isFavorite ? Colors.red : Colors.grey,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Contenu
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre
                  Text(
                    recipe.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),

                  // Description
                  Text(
                    recipe.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),

                  // Informations
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoItem(
                        Icons.access_time,
                        '${recipe.preparationTime + recipe.cookingTime} min',
                      ),
                      _buildInfoItem(
                        Icons.people,
                        '${recipe.servings} pers.',
                      ),
                      _buildDifficultyIndicator(recipe.difficulty),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultyIndicator(int difficulty) {
    String text;
    Color color;

    switch (difficulty) {
      case 1:
        text = 'Facile';
        color = Colors.green;
        break;
      case 2:
        text = 'Moyen';
        color = Colors.orange;
        break;
      case 3:
        text = 'Difficile';
        color = Colors.red;
        break;
      default:
        text = 'Inconnu';
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
