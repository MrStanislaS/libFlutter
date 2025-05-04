import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/recipe.dart';
import '../models/categori.dart';
import '../models/ingredient.dart';
import '../models/step.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'recipes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    // Table des catégories
    await db.execute('''
      CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        color INTEGER NOT NULL
      )
    ''');
    await db.execute('PRAGMA foreign_keys = ON');

    // Table des utilisateurs 
    await db.execute('''
  CREATE TABLE user_profile(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT NOT NULL
  )
''');
    // Table des recettes
    await db.execute('''
      CREATE TABLE recipes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        preparationTime INTEGER NOT NULL,
        cookingTime INTEGER NOT NULL,
        servings INTEGER NOT NULL,
        difficulty INTEGER NOT NULL,
        imageUrl TEXT,
        isFavorite INTEGER DEFAULT 0,
        categoryId INTEGER,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL,
        FOREIGN KEY (categoryId) REFERENCES categories (id)
      )
    ''');
    await db.execute('PRAGMA foreign_keys = ON');

    // Table des ingrédients
    await db.execute('''
      CREATE TABLE ingredients(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recipeId INTEGER NOT NULL,
        name TEXT NOT NULL,
        quantity REAL NOT NULL,
        unit TEXT,
        FOREIGN KEY (recipeId) REFERENCES recipes (id) ON DELETE CASCADE
      )
    ''');
    await db.execute('PRAGMA foreign_keys = ON');

    // Table des étapes de préparation
    await db.execute('''
      CREATE TABLE steps(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        recipeId INTEGER NOT NULL,
        stepNumber INTEGER NOT NULL,
        description TEXT NOT NULL,
        FOREIGN KEY (recipeId) REFERENCES recipes (id) ON DELETE CASCADE
      )
    ''');
    await db.execute('PRAGMA foreign_keys = ON');

    // quelques index
    await db.execute('CREATE INDEX idx_recipes_category ON recipes(categoryId)');
    await db.execute('CREATE INDEX idx_recipes_favorite ON recipes(isFavorite)');
    await db.execute('CREATE INDEX idx_ingredients_recipe ON ingredients(recipeId)');
    await db.execute('CREATE INDEX idx_steps_recipe ON steps(recipeId)');
    await db.execute('CREATE INDEX idx_steps_number ON steps(recipeId, stepNumber)');

    // Insertion de quelques catégories par défaut
    await db.insert('categories', {'name': 'Entrées', 'color': 0xFF66BB6A});
    await db.insert('categories', {'name': 'Plats principaux', 'color': 0xFFF44336});
    await db.insert('categories', {'name': 'Desserts', 'color': 0xFFFFEB3B});
    await db.insert('categories', {'name': 'Boissons', 'color': 0xFF2196F3});
  }



  // Méthodes CRUD pour les utilisateurs 
  Future<void> insertOrUpdateUser(UserProfile user) async {
  final db = await database;
  final existing = await db.query('user_profile');
  if (existing.isEmpty) {
    await db.insert('user_profile', user.toMap());
  } else {
    await db.update('user_profile', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }
}

Future<UserProfile?> getUser() async {
  final db = await database;
  final res = await db.query('user_profile');
  if (res.isNotEmpty) return UserProfile.fromMap(res.first);
  return null;
}


  // Méthodes CRUD pour les recettes

  Future<int> insertRecipe(Recipe recipe) async {
    Database db = await database;
    // Horodatage
    final now = DateTime.now().millisecondsSinceEpoch;
    final recipeMap = recipe.toMap();
    recipeMap['createdAt'] = now;
    recipeMap['updatedAt'] = now;

    int id = await db.insert('recipes', recipeMap);

    // Insertion des ingrédients
    for (var ingredient in recipe.ingredients) {
      // Créer une copie avec le recipeId mis à jour
      final updatedIngredient = ingredient.copyWith(recipeId: id);
      await db.insert('ingredients', updatedIngredient.toMap());
    }

    // Insertion des étapes
    for (var step in recipe.steps) {
      // Créer une copie avec le recipeId mis à jour
      final updatedStep = step.copyWith(recipeId: id);
      await db.insert('steps', updatedStep.toMap());
    }

    return id;
  }

  Future<Recipe> getRecipe(int id) async {
    Database db = await database;

    // Récupérer la recette
    List<Map<String, dynamic>> recipes = await db.query(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (recipes.isEmpty) {
      throw Exception('Recette non trouvée');
    }

    // Récupérer les ingrédients
    List<Map<String, dynamic>> ingredients = await db.query(
      'ingredients',
      where: 'recipeId = ?',
      whereArgs: [id],
    );

    // Récupérer les étapes
    List<Map<String, dynamic>> steps = await db.query(
      'steps',
      where: 'recipeId = ?',
      whereArgs: [id],
      orderBy: 'stepNumber ASC',
    );

    return Recipe.fromMap(recipes.first, ingredients, steps);
  }

  Future<List<Recipe>> getAllRecipes() async {
    Database db = await database;
    List<Map<String, dynamic>> recipesMaps = await db.query('recipes');

    List<Recipe> recipes = [];
    for (var recipeMap in recipesMaps) {
      int recipeId = recipeMap['id'];
      
      List<Map<String, dynamic>> ingredients = await db.query(
        'ingredients',
        where: 'recipeId = ?',
        whereArgs: [recipeId],
      );

      List<Map<String, dynamic>> steps = await db.query(
        'steps',
        where: 'recipeId = ?',
        whereArgs: [recipeId],
        orderBy: 'stepNumber ASC',
      );

      recipes.add(Recipe.fromMap(recipeMap, ingredients, steps));
    }

    return recipes;
  }

  Future<List<Recipe>> getRecipesByCategory(int categoryId) async {
    Database db = await database;
    List<Map<String, dynamic>> recipesMaps = await db.query(
      'recipes',
      where: 'categoryId = ?',
      whereArgs: [categoryId],
    );

    List<Recipe> recipes = [];
    for (var recipeMap in recipesMaps) {
      int recipeId = recipeMap['id'];
      
      List<Map<String, dynamic>> ingredients = await db.query(
        'ingredients',
        where: 'recipeId = ?',
        whereArgs: [recipeId],
      );

      List<Map<String, dynamic>> steps = await db.query(
        'steps',
        where: 'recipeId = ?',
        whereArgs: [recipeId],
        orderBy: 'stepNumber ASC',
      );

      recipes.add(Recipe.fromMap(recipeMap, ingredients, steps));
    }

    return recipes;
  }

  Future<int> updateRecipe(Recipe recipe) async {
    Database db = await database;

    final recipeMap = recipe.toMap();
    recipeMap['updatedAt'] = DateTime.now().millisecondsSinceEpoch;

    // Mettre à jour la recette
    await db.update(
      'recipes',
      recipeMap,
      where: 'id = ?',
      whereArgs: [recipe.id],
    );

    // Supprimer les anciens ingrédients et étapes
    await db.delete(
      'ingredients',
      where: 'recipeId = ?',
      whereArgs: [recipe.id],
    );

    await db.delete(
      'steps',
      where: 'recipeId = ?',
      whereArgs: [recipe.id],
    );

    // Insérer les nouveaux ingrédients et étapes
    for (var ingredient in recipe.ingredients) {
      // Créer une copie avec le recipeId mis à jour
      final updatedIngredient = ingredient.copyWith(recipeId: recipe.id);
      await db.insert('ingredients', updatedIngredient.toMap());
    }

    for (var step in recipe.steps) {
      // Créer une copie avec le recipeId mis à jour
      final updatedStep = step.copyWith(recipeId: recipe.id);
      await db.insert('steps', updatedStep.toMap());
    }

    return recipe.id;
  }

  Future<int> deleteRecipe(int id) async {
    Database db = await database;

    // Avec ON DELETE CASCADE, la suppression de la recette
    // entraînera la suppression des ingrédients et des étapes
    return await db.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Méthodes pour les catégories

  Future<List<Categori>> getAllCategories() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('categories');
    return List.generate(maps.length, (i) => Categori.fromMap(maps[i]));
  }

  Future<int> insertCategory(Categori category) async {
    Database db = await database;
    return await db.insert('categories', category.toMap());
  }
}