class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://localhost:3000';
  static const String livelKitServerUrl = 'wss://your-livekit-server.com';

  // Asset Paths
  static const String imagesPath = 'assets/images/';
  static const String animationsPath = 'assets/animations/';
  static const String audioPath = 'assets/audio/';

  // Character Images
  static const String characterImagesPath = '${imagesPath}characters/';

  // Animation Files
  static const String talkingAnimation = '${animationsPath}talking_orb.json';
  static const String listeningAnimation =
      '${animationsPath}listening_orb.json';
  static const String idleAnimation = '${animationsPath}idle_orb.json';

  // Audio Files
  static const String recordingStartSound = '${audioPath}recording_start.mp3';
  static const String recordingStopSound = '${audioPath}recording_stop.mp3';

  // Dimensions
  static const double defaultPadding = 16.0;
  static const double largePadding = 24.0;
  static const double smallPadding = 8.0;

  static const double defaultBorderRadius = 16.0;
  static const double largeBorderRadius = 24.0;
  static const double smallBorderRadius = 8.0;

  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);

  // Audio Configuration
  static const Duration maxRecordingDuration = Duration(minutes: 2);
  static const Duration minRecordingDuration = Duration(seconds: 1);

  // AI Configuration
  static const int maxStoryLength = 1000; // words
  static const int maxCharacters = 3;

  // Local Storage Keys
  static const String storiesBoxKey = 'stories';
  static const String settingsBoxKey = 'settings';
  static const String userPreferencesKey = 'user_preferences';

  // Settings Keys
  static const String isDarkModeKey = 'is_dark_mode';
  static const String isFirstLaunchKey = 'is_first_launch';
  static const String selectedVoiceKey = 'selected_voice';
  static const String volumeLevelKey = 'volume_level';

  // Error Messages
  static const String networkErrorMessage =
      'Please check your internet connection and try again.';
  static const String recordingErrorMessage =
      'Unable to record audio. Please check microphone permissions.';
  static const String playbackErrorMessage =
      'Unable to play audio. Please try again.';
  static const String imagePickerErrorMessage =
      'Unable to select image. Please try again.';
  static const String genericErrorMessage =
      'Something went wrong. Please try again.';

  // Success Messages
  static const String storySavedMessage = 'Story saved successfully!';
  static const String recordingCompleteMessage = 'Recording complete!';

  // LiveKit Configuration
  static const String livelKitApiKey = 'your-livekit-api-key';
  static const String livelKitApiSecret = 'your-livekit-api-secret';

  // Child Safety
  static const List<String> bannedWords = [
    // Add any inappropriate words that should be filtered
  ];

  // Story Templates
  static const List<String> storyPrompts = [
    'Once upon a time in a magical forest...',
    'In a far-away kingdom where dragons were friendly...',
    'On a sunny day, our adventure begins when...',
    'Deep in the ocean, where mermaids swim...',
    'High up in the clouds, where fairies live...',
  ];
}

// Enum for different app states
enum AppState { initial, loading, success, error }

// Enum for recording states
enum RecordingState { idle, recording, processing, complete, error }

// Enum for playback states
enum PlaybackState { idle, playing, paused, stopped, error }
