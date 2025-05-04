import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/main_screen.dart';
import 'services/recipe_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipeService()),
      ],
      child: MaterialApp(
        title: 'Recettes de Cuisine',
        theme: ThemeData(
          // Couleurs primaires
          primarySwatch: Colors.orange,
          primaryColor: Colors.orange,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.orange,
            accentColor: Colors.deepOrange,
          ),

          // Appbar
          appBarTheme: AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.white),
          ),

          // Boutons
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            ),
          ),

          // Cartes
          cardTheme: CardTheme(
            elevation: 2.0,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),

          // Typographie
          textTheme: TextTheme(
            headlineMedium: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            headlineSmall: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            titleLarge: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            titleMedium: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            bodyLarge: TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
            ),
            bodyMedium: TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
            bodySmall: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),

          // Fond d'écran
          scaffoldBackgroundColor: Colors.grey[100],

          // Entrées de formulaire
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.orange, width: 2.0),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
          ),
        ),
        home: MainScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
