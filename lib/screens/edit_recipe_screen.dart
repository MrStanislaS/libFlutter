import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/recipe.dart';
import '../models/ingredient.dart';
import '../models/step.dart';
import '../services/recipe_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';


class EditRecipeScreen extends StatefulWidget {
  final Recipe recipe;
  

  const EditRecipeScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  _EditRecipeScreenState createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _prepTimeController;
  late TextEditingController _cookTimeController;
  late TextEditingController _servingsController;

  late int _selectedDifficulty;
  late int _selectedCategoryId;
  late String _imageUrl;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  late List<Map<String, dynamic>> _ingredients;
  late List<Map<String, dynamic>> _steps;

  final _ingredientNameController = TextEditingController();
  final _ingredientQuantityController = TextEditingController();
  final _ingredientUnitController = TextEditingController();
  final _stepDescriptionController = TextEditingController();

  Future<String> _saveImageLocally(File image) async {
  final directory = await getApplicationDocumentsDirectory();
  final imageName = basename(image.path);
  final localPath = join(directory.path, imageName);
  final savedImage = await image.copy(localPath);
  return savedImage.path;
}
  @override
  void initState() {
    super.initState();

    // Initialiser les contrôleurs avec les valeurs de la recette
    _titleController = TextEditingController(text: widget.recipe.title);
    _descriptionController = TextEditingController(text: widget.recipe.description);
    _prepTimeController = TextEditingController(text: widget.recipe.preparationTime.toString());
    _cookTimeController = TextEditingController(text: widget.recipe.cookingTime.toString());
    _servingsController = TextEditingController(text: widget.recipe.servings.toString());

    _selectedDifficulty = widget.recipe.difficulty;
    _selectedCategoryId = widget.recipe.categoryId;
    _imageUrl = widget.recipe.imageUrl;

    // Convertir les ingrédients et les étapes en maps
    _ingredients = widget.recipe.ingredients.map((ingredient) => {
      'name': ingredient.name,
      'quantity': ingredient.quantity,
      'unit': ingredient.unit,
    }).toList();

    _steps = widget.recipe.steps.map((step) => {
      'stepNumber': step.stepNumber,
      'description': step.description,
    }).toList();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _prepTimeController.dispose();
    _cookTimeController.dispose();
    _servingsController.dispose();
    _ingredientNameController.dispose();
    _ingredientQuantityController.dispose();
    _ingredientUnitController.dispose();
    _stepDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recipeService = Provider.of<RecipeService>(context);

    return Scaffold(
        appBar: AppBar(
        title: Text('Modifier la recette'),
    ),
    body: Form(
    key: _formKey,
    child: SingleChildScrollView(
    padding: EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // Section d'image
    _buildImageSection(),
    SizedBox(height: 16.0),

    // Section des informations générales
    Text(
    'Informations générales',
    style: Theme.of(context).textTheme.titleLarge,
    ),
    SizedBox(height: 8.0),
    TextFormField(
    controller: _titleController,
    decoration: InputDecoration(
    labelText: 'Titre de la recette',
    border: OutlineInputBorder(),
    ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer un titre';
        }
        return null;
      },
    ),
      SizedBox(height: 8.0),
      TextFormField(
        controller: _descriptionController,
        decoration: InputDecoration(
          labelText: 'Description',
          border: OutlineInputBorder(),
        ),
        maxLines: 3,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez entrer une description';
          }
          return null;
        },
      ),
      SizedBox(height: 16.0),

      // Ligne 1: Temps de préparation et Temps de cuisson
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _prepTimeController,
              decoration: InputDecoration(
                labelText: 'Temps de préparation (min)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Requis';
                }
                if (int.tryParse(value) == null) {
                  return 'Nombre requis';
                }
                return null;
              },
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: TextFormField(
              controller: _cookTimeController,
              decoration: InputDecoration(
                labelText: 'Temps de cuisson (min)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Requis';
                }
                if (int.tryParse(value) == null) {
                  return 'Nombre requis';
                }
                return null;
              },
            ),
          ),
        ],
      ),
      SizedBox(height: 16.0),

      // Ligne 2: Portions et Difficulté
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _servingsController,
              decoration: InputDecoration(
                labelText: 'Nombre de portions',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Requis';
                }
                if (int.tryParse(value) == null) {
                  return 'Nombre requis';
                }
                return null;
              },
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: DropdownButtonFormField<int>(
              value: _selectedDifficulty,
              decoration: InputDecoration(
                labelText: 'Difficulté',
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(value: 1, child: Text('Facile')),
                DropdownMenuItem(value: 2, child: Text('Moyen')),
                DropdownMenuItem(value: 3, child: Text('Difficile')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedDifficulty = value!;
                });
              },
            ),
          ),
        ],
      ),
      SizedBox(height: 16.0),

      // Catégorie
      DropdownButtonFormField<int>(
        value: _selectedCategoryId,
        decoration: InputDecoration(
          labelText: 'Catégorie',
          border: OutlineInputBorder(),
        ),
        items: recipeService.categories.map((category) {
          return DropdownMenuItem(
            value: category.id,
            child: Text(category.name),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedCategoryId = value!;
          });
        },
      ),
      SizedBox(height: 24.0),

      // Section des ingrédients
      _buildIngredientSection(),
      SizedBox(height: 24.0),

      // Section des étapes
      _buildStepSection(),
      SizedBox(height: 32.0),

      // Bouton de sauvegarde
      Center(
        child: ElevatedButton(
          onPressed: _updateRecipe,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
            child: Text('Mettre à jour la recette'),
          ),
        ),
      ),
    ],
    ),
    ),
    ),
    );
  }

  Widget _buildImageSection() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: _imageFile != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.file(
                  _imageFile!,
                  fit: BoxFit.cover,
                ),
              )
                  : _imageUrl.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  _imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.image,
                    size: 60,
                    color: Colors.grey[600],
                  ),
                ),
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate,
                    size: 60,
                    color: Colors.grey[600],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ajouter une image',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: Icon(Icons.photo_library),
                label: Text('Galerie'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _takePicture,
                icon: Icon(Icons.camera_alt),
                label: Text('Caméra'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ingrédients',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton.icon(
              onPressed: _showAddIngredientDialog,
              icon: Icon(Icons.add),
              label: Text('Ajouter'),
            ),
          ],
        ),
        if (_ingredients.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Aucun ingrédient ajouté',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _ingredients.length,
            itemBuilder: (context, index) {
              final ingredient = _ingredients[index];
              return Card(
                margin: EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  title: Text(ingredient['name']),
                  subtitle: Text('${ingredient['quantity']} ${ingredient['unit']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _ingredients.removeAt(index);
                      });
                    },
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildStepSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Étapes de préparation',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton.icon(
              onPressed: _showAddStepDialog,
              icon: Icon(Icons.add),
              label: Text('Ajouter'),
            ),
          ],
        ),
        if (_steps.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Aucune étape ajoutée',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          )
        else
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _steps.length,
            itemBuilder: (context, index) {
              final step = _steps[index];
              return Card(
                key: Key('step_$index'),
                margin: EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Text('${index + 1}'),
                  ),
                  title: Text(step['description']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editStep(index),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _steps.removeAt(index);
                            // Mettre à jour les numéros d'étapes
                            for (int i = 0; i < _steps.length; i++) {
                              _steps[i]['stepNumber'] = i + 1;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item = _steps.removeAt(oldIndex);
                _steps.insert(newIndex, item);

                // Mettre à jour les numéros d'étapes
                for (int i = 0; i < _steps.length; i++) {
                  _steps[i]['stepNumber'] = i + 1;
                }
              });
            },
          ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        final savedPath = await _saveImageLocally(File(image.path));
setState(() {
  _imageFile = File(savedPath);
  _imageUrl = savedPath;
}); // Dans une vraie application, vous devriez téléverser l'image sur un serveur
      });
    }
  }

  Future<void> _takePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        final savedPath = await _saveImageLocally(File(image.path));
setState(() {
  _imageFile = File(savedPath);
  _imageUrl = savedPath;
}); // Dans une vraie application, vous devriez téléverser l'image sur un serveur
      });
    }
  }

  void _showAddIngredientDialog() {
    _ingredientNameController.clear();
    _ingredientQuantityController.clear();
    _ingredientUnitController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ajouter un ingrédient'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _ingredientNameController,
              decoration: InputDecoration(
                labelText: 'Nom de l\'ingrédient',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _ingredientQuantityController,
                    decoration: InputDecoration(
                      labelText: 'Quantité',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: _ingredientUnitController,
                    decoration: InputDecoration(
                      labelText: 'Unité',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_ingredientNameController.text.isNotEmpty &&
                  _ingredientQuantityController.text.isNotEmpty) {
                setState(() {
                  _ingredients.add({
                    'name': _ingredientNameController.text,
                    'quantity': double.tryParse(_ingredientQuantityController.text) ?? 0,
                    'unit': _ingredientUnitController.text,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _showAddStepDialog() {
    _stepDescriptionController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ajouter une étape'),
        content: TextFormField(
          controller: _stepDescriptionController,
          decoration: InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_stepDescriptionController.text.isNotEmpty) {
                setState(() {
                  _steps.add({
                    'stepNumber': _steps.length + 1,
                    'description': _stepDescriptionController.text,
                  });
                });
                Navigator.pop(context);
              }
            },
            child: Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _editStep(int index) {
    _stepDescriptionController.text = _steps[index]['description'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier l\'étape ${index + 1}'),
        content: TextFormField(
          controller: _stepDescriptionController,
          decoration: InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_stepDescriptionController.text.isNotEmpty) {
                setState(() {
                  _steps[index]['description'] = _stepDescriptionController.text;
                });
                Navigator.pop(context);
              }
            },
            child: Text('Modifier'),
          ),
        ],
      ),
    );
  }

  void _updateRecipe() {
    if (_formKey.currentState!.validate()) {
      if (_ingredients.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ajoutez au moins un ingrédient')),
        );
        return;
      }

      if (_steps.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ajoutez au moins une étape')),
        );
        return;
      }

      // Créer la liste d'ingrédients
      final ingredients = _ingredients.map((ingr) => Ingredient(
        name: ingr['name'],
        quantity: ingr['quantity'],
        unit: ingr['unit'],
      )).toList();

      // Créer la liste d'étapes
      final steps = _steps.map((step) => RecipeStep(
        stepNumber: step['stepNumber'],
        description: step['description'],
      )).toList();

      // Créer la recette mise à jour
      final updatedRecipe = Recipe(
        id: widget.recipe.id,
        title: _titleController.text,
        description: _descriptionController.text,
        preparationTime: int.parse(_prepTimeController.text),
        cookingTime: int.parse(_cookTimeController.text),
        servings: int.parse(_servingsController.text),
        difficulty: _selectedDifficulty,
        imageUrl: _imageUrl,
        isFavorite: widget.recipe.isFavorite,
        categoryId: _selectedCategoryId,
        ingredients: ingredients,
        steps: steps,
      );

      // Mettre à jour la recette
      Provider.of<RecipeService>(context, listen: false).updateRecipe(updatedRecipe);

      // Afficher un message de confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Recette mise à jour avec succès')),
      );

      // Retourner à l'écran précédent
      Navigator.pop(context);
    }
  }
}
