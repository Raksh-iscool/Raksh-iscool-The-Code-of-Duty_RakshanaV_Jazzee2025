import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../../features/story_creation/domain/character.dart';

class ThemeState {
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final bool isDarkMode;
  final String? selectedCharacterId;

  ThemeState({
    required this.lightTheme,
    required this.darkTheme,
    required this.isDarkMode,
    this.selectedCharacterId,
  });

  ThemeData get currentTheme => isDarkMode ? darkTheme : lightTheme;

  ThemeState copyWith({
    ThemeData? lightTheme,
    ThemeData? darkTheme,
    bool? isDarkMode,
    String? selectedCharacterId,
  }) {
    return ThemeState(
      lightTheme: lightTheme ?? this.lightTheme,
      darkTheme: darkTheme ?? this.darkTheme,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      selectedCharacterId: selectedCharacterId ?? this.selectedCharacterId,
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier()
    : super(
        ThemeState(
          lightTheme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          isDarkMode: false,
        ),
      );

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void setDarkMode(bool isDark) {
    state = state.copyWith(isDarkMode: isDark);
  }

  void setCharacterTheme(String characterId) {
    state = state.copyWith(
      selectedCharacterId: characterId,
      lightTheme: AppTheme.getThemeForCharacter(characterId, false),
      darkTheme: AppTheme.getThemeForCharacter(characterId, true),
    );
  }

  void setDefaultTheme() {
    state = state.copyWith(
      selectedCharacterId: null,
      lightTheme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
    );
  }
}

class SelectedCharacterNotifier extends StateNotifier<Character?> {
  SelectedCharacterNotifier() : super(null);

  void selectCharacter(Character character) {
    state = character;
  }

  void clearSelection() {
    state = null;
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});

final selectedCharacterProvider =
    StateNotifierProvider<SelectedCharacterNotifier, Character?>((ref) {
      return SelectedCharacterNotifier();
    });
