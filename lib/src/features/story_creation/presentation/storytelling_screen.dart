import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../routing/app_router.dart';
import '../application/storytelling_controller.dart';
import '../domain/character.dart' as story_characters;
import '../domain/story_state.dart';

class StorytellingScreen extends ConsumerWidget {
  final List<story_characters.Character> selectedCharacters;
  final String initialPrompt;
  final String? imagePath;

  const StorytellingScreen({
    super.key,
    required this.selectedCharacters,
    required this.initialPrompt,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(storytellingControllerProvider);
    final controller = ref.read(storytellingControllerProvider.notifier);

    // Initialize the storytelling session
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!state.isConnectedToLiveKit) {
        controller.initializeSession(
          characters: selectedCharacters,
          prompt: initialPrompt,
          imagePath: imagePath,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Time'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _showExitDialog(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: state.messages.isNotEmpty
                ? () => controller.saveStory()
                : null,
          ),
        ],
      ),
      body: Column(
        children: [
          // Connection Status
          if (!state.isConnectedToLiveKit)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              color: Colors.orange.shade100,
              child: Row(
                children: [
                  if (state.isLoading)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    Icon(Icons.warning, color: Colors.orange.shade700),
                  const Gap(AppConstants.smallPadding),
                  Text(
                    state.isLoading
                        ? 'Connecting to storytelling session...'
                        : 'Connection lost. Tap to retry.',
                    style: TextStyle(color: Colors.orange.shade700),
                  ),
                  if (!state.isLoading) ...[
                    const Spacer(),
                    TextButton(
                      onPressed: () => controller.initializeSession(
                        characters: selectedCharacters,
                        prompt: initialPrompt,
                        imagePath: imagePath,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ],
              ),
            ),

          // Main Content Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                children: [
                  // Character Display
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedCharacters.length,
                      itemBuilder: (context, index) {
                        final character = selectedCharacters[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: AppTheme.primaryLight
                                    .withOpacity(0.3),
                                backgroundImage: character.imagePath != null
                                    ? AssetImage(character.imagePath!)
                                    : null,
                                child: character.imagePath == null
                                    ? Icon(
                                        _getCharacterIcon(character.id),
                                        size: 30,
                                        color: AppTheme.primaryColor,
                                      )
                                    : null,
                                onBackgroundImageError:
                                    character.imagePath != null
                                    ? (exception, stackTrace) {}
                                    : null,
                              ),
                              const Gap(4),
                              Text(
                                character.name,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const Gap(AppConstants.defaultPadding),

                  // AI Talking Animation
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: Lottie.asset(
                      state.isAiSpeaking
                          ? AppConstants.talkingAnimation
                          : state.isRecording
                          ? AppConstants.listeningAnimation
                          : AppConstants.idleAnimation,
                      fit: BoxFit.contain,
                      repeat: state.isAiSpeaking || state.isRecording,
                    ),
                  ),

                  const Gap(AppConstants.defaultPadding),

                  // Story Transcript
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(
                        AppConstants.defaultPadding,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(
                          AppConstants.defaultBorderRadius,
                        ),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: state.messages.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.record_voice_over,
                                    size: 48,
                                    color: Colors.grey.shade400,
                                  ),
                                  const Gap(AppConstants.defaultPadding),
                                  Text(
                                    'Press and hold the microphone\nto start your story adventure!',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(color: Colors.grey.shade600),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: state.messages.length,
                              itemBuilder: (context, index) {
                                final message = state.messages[index];
                                return MessageBubble(message: message);
                              },
                            ),
                    ),
                  ),

                  const Gap(AppConstants.defaultPadding),

                  // Recording Status
                  if (state.isRecording || state.transcript.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(
                        AppConstants.defaultPadding,
                      ),
                      decoration: BoxDecoration(
                        color: state.isRecording
                            ? Colors.red.shade50
                            : Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(
                          AppConstants.smallBorderRadius,
                        ),
                      ),
                      child: Text(
                        state.isRecording
                            ? 'Recording... Speak clearly!'
                            : 'Processing: "${state.transcript}"',
                        style: TextStyle(
                          color: state.isRecording
                              ? Colors.red.shade700
                              : Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  const Gap(AppConstants.defaultPadding),

                  // Recording Button
                  GestureDetector(
                    onTapDown: (_) => controller.startRecording(),
                    onTapUp: (_) => controller.stopRecordingAndProcessStory(),
                    onTapCancel: () =>
                        controller.stopRecordingAndProcessStory(),
                    child: AnimatedContainer(
                      duration: AppConstants.fastAnimationDuration,
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: state.isRecording
                            ? Colors.red
                            : AppTheme.primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color:
                                (state.isRecording
                                        ? Colors.red
                                        : AppTheme.primaryColor)
                                    .withOpacity(0.3),
                            blurRadius: state.isRecording ? 20 : 10,
                            spreadRadius: state.isRecording ? 2 : 0,
                          ),
                        ],
                      ),
                      child: Icon(
                        state.isRecording ? Icons.mic : Icons.mic_none,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),

                  const Gap(AppConstants.smallPadding),

                  Text(
                    state.isRecording
                        ? 'Release to send'
                        : 'Press and hold to speak',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCharacterIcon(String characterId) {
    switch (characterId) {
      case 'brave_knight':
        return Icons.shield;
      case 'magical_fairy':
        return Icons.auto_fix_high;
      case 'clever_fox':
        return Icons.pets;
      case 'friendly_dragon':
        return Icons.favorite;
      case 'curious_cat':
        return Icons.celebration;
      default:
        return Icons.person;
    }
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Story?'),
        content: const Text(
          'Are you sure you want to leave? Your progress will be lost unless you save the story.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.goToHome();
            },
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final StoryMessage message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.type == MessageType.user;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primaryColor,
              child: Icon(Icons.auto_stories, size: 16, color: Colors.white),
            ),
            const Gap(AppConstants.smallPadding),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              decoration: BoxDecoration(
                color: isUser ? AppTheme.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(
                  AppConstants.defaultBorderRadius,
                ),
                border: isUser ? null : Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                message.content,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isUser ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const Gap(AppConstants.smallPadding),
            const CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.secondaryColor,
              child: Icon(Icons.person, size: 16, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }
}
