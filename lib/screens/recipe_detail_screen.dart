import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import 'edit_recipe_screen.dart';
import 'package:share_plus/share_plus.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        actions: [
          IconButton(
            icon: Icon(
              recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: recipe.isFavorite ? Colors.red : null,
            ),
            onPressed: () {
              Provider.of<RecipeService>(context, listen: false)
                  .toggleFavorite(recipe.id);
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              _shareRecipe(context);
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditRecipeScreen(recipe: recipe),
                  ),
                );
              } else if (value == 'delete') {
                _showDeleteConfirmation(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'edit',
                  child: Text('Modifier'),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Supprimer'),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image de la recette
            _buildRecipeImage(),

            // Informations générales
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    recipe.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: 16.0),

                  // Statistiques de la recette
                  _buildRecipeStats(context),

                  Divider(height: 32.0),

                  // Ingrédients
                  Text(
                    'Ingrédients',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8.0),
                  _buildIngredientsList(),

                  Divider(height: 32.0),

                  // Étapes de préparation
                  Text(
                    'Préparation',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 8.0),
                  _buildStepsList(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeImage() {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
      ),
      child: recipe.imageUrl.isNotEmpty
          ? Image.network(
        recipe.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Icon(
          Icons.restaurant,
          size: 80,
          color: Colors.grey[500],
        ),
      )
          : Icon(
        Icons.restaurant,
        size: 80,
        color: Colors.grey[500],
      ),
    );
  }

  Widget _buildRecipeStats(BuildContext context) {
    final category = Provider.of<RecipeService>(context, listen: false)
        .getCategoryById(recipe.categoryId);

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
        _buildStatItem(
        context,
        'Préparation',
        '${recipe.preparationTime} min'
    ),
    _buildStatItem(
    context,
    'Cuisson',
    '${recipe.cookingTime} min'
    ),
          _buildStatItem(
              context,
              'Portions',
              '${recipe.servings}'
          ),
          _buildStatItem(
              context,
              'Difficulté',
              _getDifficultyText(recipe.difficulty)
          ),
          _buildStatItem(
              context,
              'Catégorie',
              category.name,
              Color(category.color)
          ),
        ],
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, [Color? color]) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color ?? Colors.orange[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color != null ? Colors.white : Colors.orange[800],
            ),
          ),
        ),
      ],
    );
  }

  String _getDifficultyText(int difficulty) {
    switch (difficulty) {
      case 1:
        return 'Facile';
      case 2:
        return 'Moyen';
      case 3:
        return 'Difficile';
      default:
        return 'Inconnu';
    }
  }

  Widget _buildIngredientsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: recipe.ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = recipe.ingredients[index];
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Icon(Icons.circle, size: 8, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                '${ingredient.quantity} ${ingredient.unit} ${ingredient.name}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepsList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: recipe.steps.length,
      itemBuilder: (context, index) {
        final step = recipe.steps[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.orange,
                child: Text(
                  '${step.stepNumber}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  step.description,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _shareRecipe(BuildContext context) {
    // Préparer le texte à partager
    final ingredients = recipe.ingredients
        .map((i) => '• ${i.quantity} ${i.unit} ${i.name}')
        .join('\n');

    final steps = recipe.steps
        .map((s) => '${s.stepNumber}. ${s.description}')
        .join('\n');

    final text = '''
📱 Recette partagée depuis l'application Recettes de Cuisine 📱

🍽️ ${recipe.title.toUpperCase()} 🍽️

📝 ${recipe.description}

⏱️ Préparation: ${recipe.preparationTime} min
⏱️ Cuisson: ${recipe.cookingTime} min
👥 Portions: ${recipe.servings}
⭐ Difficulté: ${_getDifficultyText(recipe.difficulty)}

🛒 INGRÉDIENTS:
$ingredients

👨‍🍳 PRÉPARATION:
$steps

Bon appétit! 😋
''';

    Share.share(text);
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer la recette'),
        content: Text('Êtes-vous sûr de vouloir supprimer "${recipe.title}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<RecipeService>(context, listen: false)
                  .deleteRecipe(recipe.id);
              Navigator.pop(context); // Fermer la boîte de dialogue
              Navigator.pop(context); // Revenir à l'écran précédent
            },
            child: Text('Supprimer'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}