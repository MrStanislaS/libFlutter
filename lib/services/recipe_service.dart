import 'package:flutter/foundation.dart';
import '../models/recipe.dart';
import '../models/categori.dart';
import '../models/user_profile.dart';
import 'database_helper.dart';

class RecipeService with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Recipe> _recipes = [];
  List<Categori> _categories = [];

  String _searchQuery = '';
  UserProfile? _user;

  List<Recipe> get recipes {
    if (_searchQuery.isEmpty) return List.unmodifiable(_recipes);
    return _recipes
        .where((r) => r.title.toLowerCase().contains(_searchQuery))
        .toList();
  }

  List<Categori> get categories => List.unmodifiable(_categories);
  UserProfile? get user => _user;

  set searchQuery(String value) {
    _searchQuery = value.toLowerCase();
    notifyListeners();
  }

  RecipeService() {
    _loadCategories();
    _loadRecipes();
    loadUser();
  }

  Future<void> refreshAll() async {
    await _loadCategories();
    await _loadRecipes();
    await loadUser();
  }

  Future<void> _loadCategories() async {
    _categories = await _dbHelper.getAllCategories();
    notifyListeners();
  }

  Future<void> _loadRecipes() async {
    _recipes = await _dbHelper.getAllRecipes();
    notifyListeners();
  }

  Future<void> loadUser() async {
    _user = await _dbHelper.getUser();
    notifyListeners();
  }

  Future<void> updateUser(UserProfile user) async {
    await _dbHelper.insertOrUpdateUser(user);
    _user = user;
    notifyListeners();
  }

  Future<void> addRecipe(Recipe recipe) async {
    final id = await _dbHelper.insertRecipe(recipe);
    final newRecipe = recipe.copyWith(id: id);
    _recipes.add(newRecipe);
    notifyListeners();
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await _dbHelper.updateRecipe(recipe);
    final index = _recipes.indexWhere((r) => r.id == recipe.id);
    if (index != -1) {
      _recipes[index] = recipe;
      notifyListeners();
    }
  }

  Future<void> deleteRecipe(int id) async {
    await _dbHelper.deleteRecipe(id);
    _recipes.removeWhere((recipe) => recipe.id == id);
    notifyListeners();
  }

  Future<void> toggleFavorite(int id) async {
    final index = _recipes.indexWhere((recipe) => recipe.id == id);
    if (index != -1) {
      final updatedRecipe = _recipes[index].toggleFavorite();
      await _dbHelper.updateRecipe(updatedRecipe);
      _recipes[index] = updatedRecipe;
      notifyListeners();
    }
  }

  List<Recipe> getRecipesByCategory(int categoryId) {
    return _recipes.where((recipe) => recipe.categoryId == categoryId).toList();
  }

  List<Recipe> getFavoriteRecipes() {
    return _recipes.where((recipe) => recipe.isFavorite).toList();
  }

  Future<void> addCategory(Categori category) async {
    final id = await _dbHelper.insertCategory(category);
    final newCategory = category.copyWith(id: id);
    _categories.add(newCategory);
    notifyListeners();
  }

  Categori getCategoryById(int id) {
    return _categories.firstWhere(
      (category) => category.id == id,
      orElse: () => throw Exception('Catégorie non trouvée'),
    );
  }
}
