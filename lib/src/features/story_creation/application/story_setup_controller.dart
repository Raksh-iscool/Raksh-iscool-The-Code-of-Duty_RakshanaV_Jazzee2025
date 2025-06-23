import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/character.dart';
import '../domain/story_state.dart';

final storySetupControllerProvider =
    StateNotifierProvider<StorySetupController, StorySetupState>((ref) {
      return StorySetupController();
    });

class StorySetupController extends StateNotifier<StorySetupState> {
  StorySetupController() : super(const StorySetupState());

  void toggleCharacter(Character character) {
    final currentCharacters = List<Character>.from(state.selectedCharacters);

    if (currentCharacters.contains(character)) {
      currentCharacters.remove(character);
    } else {
      if (currentCharacters.length < 3) {
        // Max 3 characters
        currentCharacters.add(character);
      }
    }

    state = state.copyWith(selectedCharacters: currentCharacters);
  }

  void selectImage(String imagePath) {
    state = state.copyWith(selectedImagePath: imagePath);
  }

  void removeImage() {
    state = state.copyWith(selectedImagePath: null);
  }

  void updatePrompt(String prompt) {
    state = state.copyWith(initialPrompt: prompt);
  }

  void reset() {
    state = const StorySetupState();
  }
}
