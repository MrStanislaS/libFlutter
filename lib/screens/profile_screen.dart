import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/recipe_service.dart';
import '../models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<RecipeService>(context).user;
    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipeService = Provider.of<RecipeService>(context);
    final user = recipeService.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mon profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Nom
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nom'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nom requis' : null,
              ),
              SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value == null || !value.contains('@') ? 'Email invalide' : null,
              ),
              SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newUser = UserProfile(
                      id: user?.id ?? 0,
                      name: _nameController.text,
                      email: _emailController.text,
                    );
                    recipeService.updateUser(newUser);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Profil mis à jour')),
                    );
                  }
                },
                child: Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}