import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../domain/story.dart';

class StoryNotifier extends StateNotifier<List<Story>> {
  static const String _storiesBoxName = 'stories';
  late Box<Story> _storiesBox;
  final Uuid _uuid = const Uuid();

  StoryNotifier() : super([]) {
    _initializeBox();
  }

  Future<void> _initializeBox() async {
    try {
      _storiesBox = await Hive.openBox<Story>(_storiesBoxName);
      state = _storiesBox.values.toList();
    } catch (e) {
      print('Error initializing stories box: $e');
    }
  }

  Future<void> createStory({
    required String title,
    required String description,
    required String characterId,
    String? pdfPath,
    List<String> tags = const [],
    String? coverImagePath,
    int? ageRange,
    String? genre,
  }) async {
    final story = Story(
      id: _uuid.v4(),
      title: title,
      description: description,
      characterId: characterId,
      pdfPath: pdfPath,
      createdAt: DateTime.now(),
      lastAccessedAt: DateTime.now(),
      tags: tags,
      coverImagePath: coverImagePath,
      ageRange: ageRange,
      genre: genre,
      chatHistory: [],
    );

    await _storiesBox.put(story.id, story);
    state = [...state, story];
  }

  Future<void> updateStory(Story updatedStory) async {
    await _storiesBox.put(updatedStory.id, updatedStory);
    state = [
      for (final story in state)
        if (story.id == updatedStory.id) updatedStory else story,
    ];
  }

  Future<void> deleteStory(String storyId) async {
    await _storiesBox.delete(storyId);
    state = state.where((story) => story.id != storyId).toList();
  }

  Future<void> addChatMessage(String storyId, ChatMessage message) async {
    final storyIndex = state.indexWhere((s) => s.id == storyId);
    if (storyIndex != -1) {
      final story = state[storyIndex];
      final updatedChatHistory = [...story.chatHistory, message];
      final updatedStory = story.copyWith(
        chatHistory: updatedChatHistory,
        lastAccessedAt: DateTime.now(),
      );
      await updateStory(updatedStory);
    }
  }

  Future<void> updateLastAccessedAt(String storyId) async {
    final storyIndex = state.indexWhere((s) => s.id == storyId);
    if (storyIndex != -1) {
      final story = state[storyIndex];
      final updatedStory = story.copyWith(lastAccessedAt: DateTime.now());
      await updateStory(updatedStory);
    }
  }

  List<Story> getStoriesByCharacter(String characterId) {
    return state.where((story) => story.characterId == characterId).toList();
  }

  List<Story> getRecentStories({int limit = 5}) {
    final sortedStories = [...state];
    sortedStories.sort((a, b) => b.lastAccessedAt.compareTo(a.lastAccessedAt));
    return sortedStories.take(limit).toList();
  }

  List<Story> searchStories(String query) {
    final lowercaseQuery = query.toLowerCase();
    return state.where((story) {
      return story.title.toLowerCase().contains(lowercaseQuery) ||
          story.description.toLowerCase().contains(lowercaseQuery) ||
          story.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  Story? getStoryById(String storyId) {
    try {
      return state.firstWhere((story) => story.id == storyId);
    } catch (e) {
      return null;
    }
  }
}

final storyProvider = StateNotifierProvider<StoryNotifier, List<Story>>((ref) {
  return StoryNotifier();
});

// Computed providers for filtering
final recentStoriesProvider = Provider<List<Story>>((ref) {
  final stories = ref.watch(storyProvider);
  final sortedStories = [...stories];
  sortedStories.sort((a, b) => b.lastAccessedAt.compareTo(a.lastAccessedAt));
  return sortedStories.take(5).toList();
});

final favoriteStoriesProvider = Provider<List<Story>>((ref) {
  final stories = ref.watch(storyProvider);
  return stories.where((story) => story.tags.contains('favorite')).toList();
});

// Provider for getting stories by character
final storiesByCharacterProvider = Provider.family<List<Story>, String>((
  ref,
  characterId,
) {
  final stories = ref.watch(storyProvider);
  return stories.where((story) => story.characterId == characterId).toList();
});
