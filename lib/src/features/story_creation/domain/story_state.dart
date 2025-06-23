import 'package:rakshu/src/features/story_creation/domain/character.dart';

class StorySetupState {
  final List<Character> selectedCharacters;
  final String? selectedImagePath;
  final String initialPrompt;
  final bool isLoading;
  final String? error;

  const StorySetupState({
    this.selectedCharacters = const [],
    this.selectedImagePath,
    this.initialPrompt = '',
    this.isLoading = false,
    this.error,
  });

  StorySetupState copyWith({
    List<Character>? selectedCharacters,
    String? selectedImagePath,
    String? initialPrompt,
    bool? isLoading,
    String? error,
  }) {
    return StorySetupState(
      selectedCharacters: selectedCharacters ?? this.selectedCharacters,
      selectedImagePath: selectedImagePath ?? this.selectedImagePath,
      initialPrompt: initialPrompt ?? this.initialPrompt,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  bool get canProceed =>
      selectedCharacters.isNotEmpty && initialPrompt.trim().isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StorySetupState &&
        other.selectedCharacters == selectedCharacters &&
        other.selectedImagePath == selectedImagePath &&
        other.initialPrompt == initialPrompt &&
        other.isLoading == isLoading &&
        other.error == error;
  }

  @override
  int get hashCode {
    return Object.hash(
      selectedCharacters,
      selectedImagePath,
      initialPrompt,
      isLoading,
      error,
    );
  }
}

class StorytellingState {
  final String transcript;
  final bool isRecording;
  final bool isAiSpeaking;
  final bool isLoading;
  final String? error;
  final bool isConnectedToLiveKit;
  final String? currentAudioUrl;
  final List<StoryMessage> messages;

  const StorytellingState({
    this.transcript = '',
    this.isRecording = false,
    this.isAiSpeaking = false,
    this.isLoading = false,
    this.error,
    this.isConnectedToLiveKit = false,
    this.currentAudioUrl,
    this.messages = const [],
  });

  StorytellingState copyWith({
    String? transcript,
    bool? isRecording,
    bool? isAiSpeaking,
    bool? isLoading,
    String? error,
    bool? isConnectedToLiveKit,
    String? currentAudioUrl,
    List<StoryMessage>? messages,
  }) {
    return StorytellingState(
      transcript: transcript ?? this.transcript,
      isRecording: isRecording ?? this.isRecording,
      isAiSpeaking: isAiSpeaking ?? this.isAiSpeaking,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isConnectedToLiveKit: isConnectedToLiveKit ?? this.isConnectedToLiveKit,
      currentAudioUrl: currentAudioUrl ?? this.currentAudioUrl,
      messages: messages ?? this.messages,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StorytellingState &&
        other.transcript == transcript &&
        other.isRecording == isRecording &&
        other.isAiSpeaking == isAiSpeaking &&
        other.isLoading == isLoading &&
        other.error == error &&
        other.isConnectedToLiveKit == isConnectedToLiveKit &&
        other.currentAudioUrl == currentAudioUrl &&
        other.messages == messages;
  }

  @override
  int get hashCode {
    return Object.hash(
      transcript,
      isRecording,
      isAiSpeaking,
      isLoading,
      error,
      isConnectedToLiveKit,
      currentAudioUrl,
      messages,
    );
  }
}

class StoryMessage {
  final String id;
  final String content;
  final MessageType type;
  final DateTime timestamp;

  const StoryMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
  });

  StoryMessage copyWith({
    String? id,
    String? content,
    MessageType? type,
    DateTime? timestamp,
  }) {
    return StoryMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StoryMessage &&
        other.id == id &&
        other.content == content &&
        other.type == type &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return Object.hash(id, content, type, timestamp);
  }
}

enum MessageType { user, ai, system }
