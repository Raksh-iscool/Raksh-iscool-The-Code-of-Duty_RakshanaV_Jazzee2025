import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../services/api_service.dart';
import '../../story_library/domain/story.dart';
import '../domain/character.dart' as story_characters;
import '../domain/story_state.dart' as story_creation;

final storytellingControllerProvider =
    StateNotifierProvider<
      StorytellingController,
      story_creation.StorytellingState
    >((ref) {
      return StorytellingController(ref);
    });

// Services providers
final _audioRecorderProvider = Provider<AudioRecorder>(
  (ref) => AudioRecorder(),
);
final _audioPlayerProvider = Provider<AudioPlayer>((ref) => AudioPlayer());
final _apiServiceProvider = Provider<ApiService>((ref) => ApiService());

class StorytellingController
    extends StateNotifier<story_creation.StorytellingState> {
  final Ref _ref;
  Room? _room;
  Timer? _recordingTimer;
  String? _currentRecordingPath;

  StorytellingController(this._ref)
    : super(const story_creation.StorytellingState());

  AudioRecorder get _recorder => _ref.read(_audioRecorderProvider);
  AudioPlayer get _player => _ref.read(_audioPlayerProvider);
  ApiService get _apiService => _ref.read(_apiServiceProvider);

  Future<void> initializeSession({
    required List<story_characters.Character> characters,
    required String prompt,
    String? imagePath,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Initialize LiveKit connection
      await _connectToLiveKit();

      // Send initial story setup to backend
      await _sendInitialStorySetup(
        characters: characters,
        prompt: prompt,
        imagePath: imagePath,
      );

      state = state.copyWith(isLoading: false, isConnectedToLiveKit: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to initialize story session: ${e.toString()}',
      );
    }
  }

  Future<void> _connectToLiveKit() async {
    try {
      // Get LiveKit token from backend
      final response = await _apiService.dio.post('/generate-livekit-token');
      final token = response.data['token'] as String;

      // Create and connect to room
      _room = Room(
        roomOptions: const RoomOptions(adaptiveStream: true, dynacast: true),
      );

      // Set up event listeners
      _room!.addListener(_onRoomEvent);

      await _room!.connect(AppConstants.livelKitServerUrl, token);
    } catch (e) {
      throw Exception('LiveKit connection failed: $e');
    }
  }

  void _onRoomEvent() {
    // Handle LiveKit room events
    if (_room?.connectionState == ConnectionState.connected) {
      state = state.copyWith(isConnectedToLiveKit: true);
    } else if (_room?.connectionState == ConnectionState.disconnected) {
      state = state.copyWith(isConnectedToLiveKit: false);
    }
  }

  Future<void> _sendInitialStorySetup({
    required List<story_characters.Character> characters,
    required String prompt,
    String? imagePath,
  }) async {
    final setupData = {
      'characters': characters.map((c) => c.toJson()).toList(),
      'prompt': prompt,
      'imagePath': imagePath,
    };

    await _apiService.dio.post('/story-setup', data: setupData);
  }

  Future<void> startRecording() async {
    if (state.isRecording || state.isLoading) return;

    try {
      // Check and request permissions
      if (!await _recorder.hasPermission()) {
        state = state.copyWith(error: AppConstants.recordingErrorMessage);
        return;
      }

      // Get temporary directory for recording
      final tempDir = await getTemporaryDirectory();
      _currentRecordingPath =
          '${tempDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

      // Start recording
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: _currentRecordingPath!,
      );

      state = state.copyWith(isRecording: true, transcript: '', error: null);

      // Set up recording timer (max duration)
      _recordingTimer = Timer(AppConstants.maxRecordingDuration, () {
        stopRecordingAndProcessStory();
      });
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to start recording: ${e.toString()}',
      );
    }
  }

  Future<void> stopRecordingAndProcessStory() async {
    if (!state.isRecording) return;

    try {
      // Stop recording
      _recordingTimer?.cancel();
      final recordingPath = await _recorder.stop();

      state = state.copyWith(isRecording: false, isLoading: true);

      if (recordingPath != null && File(recordingPath).existsSync()) {
        // Process the audio file
        await _processAudioFile(recordingPath);
      } else {
        throw Exception('Recording file not found');
      }
    } catch (e) {
      state = state.copyWith(
        isRecording: false,
        isLoading: false,
        error: 'Failed to process recording: ${e.toString()}',
      );
    }
  }

  Future<void> _processAudioFile(String audioPath) async {
    try {
      // Create multipart file for upload
      final formData = FormData.fromMap({
        'audio': await MultipartFile.fromFile(audioPath),
        'session_id': 'story_session_${DateTime.now().millisecondsSinceEpoch}',
      });

      // Send to backend for processing
      final response = await _apiService.dio.post(
        '/process-story-audio',
        data: formData,
      );

      final transcription = response.data['transcription'] as String;
      final aiResponse = response.data['ai_response'] as String;
      final audioUrl = response.data['audio_url'] as String?;

      // Add user message
      final userMessage = story_creation.StoryMessage(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        content: transcription,
        type: story_creation.MessageType.user,
        timestamp: DateTime.now(),
      );

      // Add AI message
      final aiMessage = story_creation.StoryMessage(
        id: 'ai_${DateTime.now().millisecondsSinceEpoch}',
        content: aiResponse,
        type: story_creation.MessageType.ai,
        timestamp: DateTime.now(),
      );

      final updatedMessages = [...state.messages, userMessage, aiMessage];

      state = state.copyWith(
        transcript: transcription,
        messages: updatedMessages,
        isLoading: false,
        currentAudioUrl: audioUrl,
      );

      // Play AI audio response
      if (audioUrl != null) {
        await _playAiAudio(audioUrl);
      }

      // Clean up recording file
      if (File(audioPath).existsSync()) {
        await File(audioPath).delete();
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to process story: ${e.toString()}',
      );
    }
  }

  Future<void> _playAiAudio(String audioUrl) async {
    try {
      state = state.copyWith(isAiSpeaking: true);

      await _player.setUrl(audioUrl);
      await _player.play();

      // Listen for playback completion
      _player.playerStateStream.listen((playerState) {
        if (playerState.processingState == ProcessingState.completed) {
          state = state.copyWith(isAiSpeaking: false);
        }
      });
    } catch (e) {
      state = state.copyWith(
        isAiSpeaking: false,
        error: 'Failed to play audio: ${e.toString()}',
      );
    }
  }

  Future<void> saveStory() async {
    if (state.messages.isEmpty) return;

    try {
      // Create story content from messages
      final storyContent = state.messages
          .where((m) => m.type == story_creation.MessageType.ai)
          .map((m) => m.content)
          .join('\n\n');

      if (storyContent.isEmpty) return;

      // Create story object
      final story = Story(
        id: 'story_${DateTime.now().millisecondsSinceEpoch}',
        title: _generateStoryTitle(storyContent),
        description: 'An interactive story created with AI characters',
        content: storyContent,
        characterId: 'mixed', // Default for multi-character stories
        createdAt: DateTime.now(),
        lastAccessedAt: DateTime.now(),
        duration: _calculateStoryDuration(),
        tags: [], // Empty tags initially
      );

      // Save to Hive
      final box = Hive.box<Story>(AppConstants.storiesBoxKey);
      await box.put(story.id, story);

      // Show success feedback
      state = state.copyWith(
        error: null, // Clear any previous errors
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to save story: ${e.toString()}');
    }
  }

  String _generateStoryTitle(String content) {
    // Simple title generation - take first few words
    final words = content.split(' ').take(5).join(' ');
    return words.length > 30 ? '${words.substring(0, 30)}...' : words;
  }

  int _calculateStoryDuration() {
    // Estimate duration based on message timestamps
    if (state.messages.length < 2) return 0;

    final firstMessage = state.messages.first;
    final lastMessage = state.messages.last;

    return lastMessage.timestamp.difference(firstMessage.timestamp).inSeconds;
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _recorder.dispose();
    _player.dispose();
    _room?.disconnect();
    _room?.dispose();
    super.dispose();
  }
}
