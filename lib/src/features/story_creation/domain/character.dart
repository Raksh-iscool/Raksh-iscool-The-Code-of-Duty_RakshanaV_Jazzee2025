import 'package:flutter/material.dart';

class CharacterTheme {
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color surfaceColor;

  const CharacterTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.surfaceColor,
  });
}

class Character {
  final String id;
  final String name;
  final String description;
  final String? imagePath;
  final IconData icon;
  final CharacterTheme lightTheme;
  final CharacterTheme darkTheme;
  final String personality;

  const Character({
    required this.id,
    required this.name,
    required this.description,
    this.imagePath,
    required this.icon,
    required this.lightTheme,
    required this.darkTheme,
    required this.personality,
  });

  Character copyWith({
    String? id,
    String? name,
    String? description,
    String? imagePath,
    IconData? icon,
    CharacterTheme? lightTheme,
    CharacterTheme? darkTheme,
    String? personality,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      icon: icon ?? this.icon,
      lightTheme: lightTheme ?? this.lightTheme,
      darkTheme: darkTheme ?? this.darkTheme,
      personality: personality ?? this.personality,
    );
  }

  static Character? getCharacterById(String id) {
    try {
      return Characters.all.firstWhere((char) => char.id == id);
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'personality': personality,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Character && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Pre-defined characters for the app
class Characters {
  static const List<Character> all = [
    Character(
      id: 'sherlock_holmes',
      name: 'Sherlock Holmes',
      description:
          'The world\'s greatest detective who solves mysteries with logic',
      imagePath: 'assets/images/characters/sherlock.png',
      icon: Icons.search,
      personality: 'analytical, observant, brilliant, deductive',
      lightTheme: CharacterTheme(
        primaryColor: Color(0xFF2E7D32),
        secondaryColor: Color(0xFF4CAF50),
        backgroundColor: Color(0xFFE8F5E8),
        surfaceColor: Color(0xFFF1F8E9),
      ),
      darkTheme: CharacterTheme(
        primaryColor: Color(0xFF66BB6A),
        secondaryColor: Color(0xFF81C784),
        backgroundColor: Color(0xFF1B5E20),
        surfaceColor: Color(0xFF2E7D32),
      ),
    ),
    Character(
      id: 'peppa_pig',
      name: 'Peppa Pig',
      description: 'A cheerful little pig who loves jumping in muddy puddles',
      imagePath: 'assets/images/characters/peppa.png',
      icon: Icons.pets,
      personality: 'playful, cheerful, adventurous, family-loving',
      lightTheme: CharacterTheme(
        primaryColor: Color(0xFFE91E63),
        secondaryColor: Color(0xFFF48FB1),
        backgroundColor: Color(0xFFFCE4EC),
        surfaceColor: Color(0xFFF8BBD9),
      ),
      darkTheme: CharacterTheme(
        primaryColor: Color(0xFFF48FB1),
        secondaryColor: Color(0xFFF8BBD9),
        backgroundColor: Color(0xFF880E4F),
        surfaceColor: Color(0xFFC2185B),
      ),
    ),
    Character(
      id: 'dora_explorer',
      name: 'Dora the Explorer',
      description: 'A brave young explorer who goes on exciting adventures',
      imagePath: 'assets/images/characters/dora.png',
      icon: Icons.explore,
      personality: 'brave, curious, helpful, bilingual',
      lightTheme: CharacterTheme(
        primaryColor: Color(0xFFFF5722),
        secondaryColor: Color(0xFFFF8A65),
        backgroundColor: Color(0xFFFFF3E0),
        surfaceColor: Color(0xFFFFCCBC),
      ),
      darkTheme: CharacterTheme(
        primaryColor: Color(0xFFFF8A65),
        secondaryColor: Color(0xFFFFAB91),
        backgroundColor: Color(0xFFBF360C),
        surfaceColor: Color(0xFFD84315),
      ),
    ),
    Character(
      id: 'iron_man',
      name: 'Iron Man',
      description: 'A genius inventor and superhero in a high-tech suit',
      imagePath: 'assets/images/characters/ironman.png',
      icon: Icons.flash_on,
      personality: 'genius, heroic, witty, innovative',
      lightTheme: CharacterTheme(
        primaryColor: Color(0xFFD32F2F),
        secondaryColor: Color(0xFFFFC107),
        backgroundColor: Color(0xFFFFEBEE),
        surfaceColor: Color(0xFFFFCDD2),
      ),
      darkTheme: CharacterTheme(
        primaryColor: Color(0xFFEF5350),
        secondaryColor: Color(0xFFFFD54F),
        backgroundColor: Color(0xFFB71C1C),
        surfaceColor: Color(0xFFC62828),
      ),
    ),
    Character(
      id: 'elsa_frozen',
      name: 'Elsa',
      description: 'The Snow Queen with magical ice powers and a kind heart',
      imagePath: 'assets/images/characters/elsa.png',
      icon: Icons.ac_unit,
      personality: 'powerful, caring, independent, magical',
      lightTheme: CharacterTheme(
        primaryColor: Color(0xFF2196F3),
        secondaryColor: Color(0xFF64B5F6),
        backgroundColor: Color(0xFFE3F2FD),
        surfaceColor: Color(0xFFBBDEFB),
      ),
      darkTheme: CharacterTheme(
        primaryColor: Color(0xFF64B5F6),
        secondaryColor: Color(0xFF90CAF9),
        backgroundColor: Color(0xFF0D47A1),
        surfaceColor: Color(0xFF1565C0),
      ),
    ),
    Character(
      id: 'spider_man',
      name: 'Spider-Man',
      description: 'Your friendly neighborhood superhero with spider powers',
      imagePath: 'assets/images/characters/spiderman.png',
      icon: Icons.bug_report,
      personality: 'friendly, responsible, brave, witty',
      lightTheme: CharacterTheme(
        primaryColor: Color(0xFFD32F2F),
        secondaryColor: Color(0xFF2196F3),
        backgroundColor: Color(0xFFFFEBEE),
        surfaceColor: Color(0xFFFFCDD2),
      ),
      darkTheme: CharacterTheme(
        primaryColor: Color(0xFFEF5350),
        secondaryColor: Color(0xFF64B5F6),
        backgroundColor: Color(0xFFB71C1C),
        surfaceColor: Color(0xFFC62828),
      ),
    ),
    Character(
      id: 'winnie_pooh',
      name: 'Winnie the Pooh',
      description: 'A lovable bear who enjoys honey and friendship',
      imagePath: 'assets/images/characters/winnie.png',
      icon: Icons.favorite,
      personality: 'kind, gentle, thoughtful, honey-loving',
      lightTheme: CharacterTheme(
        primaryColor: Color(0xFFFF9800),
        secondaryColor: Color(0xFFFFB74D),
        backgroundColor: Color(0xFFFFF8E1),
        surfaceColor: Color(0xFFFFE0B2),
      ),
      darkTheme: CharacterTheme(
        primaryColor: Color(0xFFFFB74D),
        secondaryColor: Color(0xFFFFCC02),
        backgroundColor: Color(0xFFE65100),
        surfaceColor: Color(0xFFF57C00),
      ),
    ),
    Character(
      id: 'mickey_mouse',
      name: 'Mickey Mouse',
      description: 'The cheerful mouse who brings joy and laughter everywhere',
      imagePath: 'assets/images/characters/mickey.png',
      icon: Icons.sentiment_very_satisfied,
      personality: 'cheerful, optimistic, fun-loving, magical',
      lightTheme: CharacterTheme(
        primaryColor: Color(0xFF212121),
        secondaryColor: Color(0xFFF44336),
        backgroundColor: Color(0xFFF5F5F5),
        surfaceColor: Color(0xFFE0E0E0),
      ),
      darkTheme: CharacterTheme(
        primaryColor: Color(0xFF616161),
        secondaryColor: Color(0xFFEF5350),
        backgroundColor: Color(0xFF000000),
        surfaceColor: Color(0xFF212121),
      ),
    ),
  ];
}
