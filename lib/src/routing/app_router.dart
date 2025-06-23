import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/home/presentation/home_screen.dart';
import '../features/story_creation/presentation/story_setup_screen.dart';
import '../features/story_creation/presentation/storytelling_screen.dart';
import '../features/story_library/presentation/story_library_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/setup',
        name: 'setup',
        builder: (context, state) => const StorySetupScreen(),
      ),
      GoRoute(
        path: '/story',
        name: 'story',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return StorytellingScreen(
            selectedCharacters: extra?['characters'] ?? [],
            initialPrompt: extra?['prompt'] ?? '',
            imagePath: extra?['imagePath'],
          );
        },
      ),
      GoRoute(
        path: '/library',
        name: 'library',
        builder: (context, state) => const StoryLibraryScreen(),
      ),
    ],
  );
});

// Navigation helper methods
extension AppNavigation on BuildContext {
  void goToHome() => go('/');
  void goToSetup() => go('/setup');
  void goToStory({
    required List<dynamic> characters,
    required String prompt,
    String? imagePath,
  }) {
    go(
      '/story',
      extra: {
        'characters': characters,
        'prompt': prompt,
        'imagePath': imagePath,
      },
    );
  }

  void goToLibrary() => go('/library');
}
