# Architecture améliorée pour l'application de recettes

## 1. Structure des dossiers

```
lib/
├── core/
│   ├── errors/
│   │   ├── app_exception.dart
│   │   └── db_exception.dart
│   ├── utils/
│   │   ├── logger.dart
│   │   └── validators.dart
│   └── constants/
│       └── app_constants.dart
├── data/
│   ├── datasources/
│   │   ├── local/
│   │   │   └── database_helper.dart
│   │   └── remote/
│   │       └── api_service.dart (pour les futures extensions)
│   ├── repositories/
│   │   ├── recipe_repository_impl.dart
│   │   └── category_repository_impl.dart
│   └── models/
│       ├── recipe.dart
│       ├── category.dart  (renommé de categori.dart)
│       ├── ingredient.dart
│       ├── step.dart
│       ├── tag.dart (nouvelle entité)
│       └── meal_plan.dart (nouvelle entité)
├── domain/
│   ├── repositories/
│   │   ├── recipe_repository.dart
│   │   └── category_repository.dart
│   └── usecases/
│       ├── recipe/
│       │   ├── get_recipes.dart
│       │   ├── add_recipe.dart
│       │   └── update_recipe.dart
│       └── category/
│           └── get_categories.dart
├── presentation/
│   ├── blocs/ (ou providers/)
│   │   ├── recipe/
│   │   │   ├── recipe_bloc.dart
│   │   │   ├── recipe_event.dart
│   │   │   └── recipe_state.dart
│   │   └── category/
│   │       └── category_bloc.dart
│   ├── pages/
│   │   ├── recipe_list_page.dart
│   │   ├── recipe_detail_page.dart
│   │   └── recipe_form_page.dart
│   └── widgets/
│       ├── recipe_card.dart
│       └── category_chip.dart
└── main.dart
```

## 2. Principes d'architecture

Cette nouvelle structure suit les principes de Clean Architecture et SOLID:

1. **Séparation des responsabilités** : Chaque couche a une responsabilité unique
2. **Inversion de dépendance** : Les couches de haut niveau ne dépendent pas des détails d'implémentation
3. **Interfaces** : Communication entre les couches via des interfaces abstraites
4. **Testabilité** : Structure facilitant les tests unitaires et d'intégration

## 3. Gestion d'état

Cette architecture est compatible avec différentes approches de gestion d'état :

- **BLoC** : Pour une gestion d'état réactive basée sur les streams
- **Provider** : Pour une gestion d'état plus simple avec une approche InheritedWidget
- **Riverpod** : Une évolution de Provider avec plus de fonctionnalités

L'implémentation proposée utilisera BLoC pour la réactivité et la testabilité.

## 4. Gestion d'erreurs

Un système complet de gestion d'erreurs est mis en place :

- Hiérarchie d'exceptions personnalisées
- Gestion des erreurs à chaque niveau (repository, usecase, bloc)
- Affichage contextuel des erreurs à l'utilisateur

## 5. Performances

Les améliorations de performance incluent :

- Requêtes SQL optimisées avec JOIN
- Chargement paresseux (lazy loading) pour les listes
- Mise en cache des données fréquemment utilisées

## 6. Nouvelles fonctionnalités

La nouvelle architecture prend en charge les fonctionnalités supplémentaires :

- Système de tags
- Planification de repas
- Liste de courses
- Recherche avancée
- Notation des recettes