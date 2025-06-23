import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/providers/theme_provider.dart';
import '../../story_library/domain/story.dart' as story_domain;
import '../../story_library/providers/story_provider.dart';
import '../../story_creation/domain/character.dart';

class ModelChatScreen extends ConsumerStatefulWidget {
  final story_domain.Story story;
  final Character? character;

  const ModelChatScreen({super.key, required this.story, this.character});

  @override
  ConsumerState<ModelChatScreen> createState() => _ModelChatScreenState();
}

class _ModelChatScreenState extends ConsumerState<ModelChatScreen>
    with TickerProviderStateMixin {
  late AnimationController _speakingAnimationController;
  late AnimationController _idleAnimationController;
  late Animation<double> _speakingAnimation;
  late Animation<double> _idleAnimation;

  final TextEditingController _messageController = TextEditingController();
  List<story_domain.ChatMessage> _messages = [];
  bool _isListening = false;
  bool _isSpeaking = false;
  bool _isVoiceChatMode = false;
  final Uuid _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadChatHistory();
    if (_messages.isEmpty) {
      _addWelcomeMessage();
    }
  }

  void _loadChatHistory() {
    _messages = List.from(widget.story.chatHistory);
  }

  void _initializeAnimations() {
    _speakingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _idleAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _speakingAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _speakingAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _idleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _idleAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _idleAnimationController.repeat(reverse: true);
  }

  void _addWelcomeMessage() {
    final welcomeMessage = story_domain.ChatMessage(
      id: _uuid.v4(),
      content:
          "Hello! I'm ${widget.character?.name ?? 'your AI assistant'}. I'm here to help you explore the story \"${widget.story.title}\". What would you like to talk about?",
      isFromUser: false,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(welcomeMessage);
    });

    // Save to story
    ref
        .read(storyProvider.notifier)
        .addChatMessage(widget.story.id, welcomeMessage);
  }

  @override
  void dispose() {
    _speakingAnimationController.dispose();
    _idleAnimationController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final character = widget.character;
    final isDark = ref.watch(themeProvider).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.story.title),
            if (character != null)
              Text(
                'with ${character.name}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? character.darkTheme.primaryColor
                      : character.lightTheme.primaryColor,
                ),
              ),
          ],
        ),
        centerTitle: true,
        backgroundColor: character != null
            ? (isDark
                  ? character.darkTheme.primaryColor.withOpacity(0.1)
                  : character.lightTheme.primaryColor.withOpacity(0.1))
            : null,
        actions: [
          if (_isVoiceChatMode)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => _exitVoiceChat(),
            ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        child: _isVoiceChatMode
            ? _buildVoiceChatMode()
            : _buildNormalChatMode(),
      ),
    );
  }

  Widget _buildVoiceChatMode() {
    final theme = Theme.of(context);
    final character = widget.character;
    final isDark = ref.watch(themeProvider).isDarkMode;

    return Container(
      key: const ValueKey('voice_chat'),
      decoration: character != null
          ? BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  (isDark
                          ? character.darkTheme.primaryColor
                          : character.lightTheme.primaryColor)
                      .withOpacity(0.1),
                  (isDark
                          ? character.darkTheme.secondaryColor
                          : character.lightTheme.secondaryColor)
                      .withOpacity(0.05),
                ],
              ),
            )
          : null,
      child: Column(
        children: [
          // Expanded area for centered character
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Large animated character avatar
                  AnimatedBuilder(
                    animation: _isSpeaking
                        ? _speakingAnimation
                        : _idleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _isSpeaking
                            ? _speakingAnimation.value
                            : _idleAnimation.value,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: character != null
                                ? LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      isDark
                                          ? character.darkTheme.primaryColor
                                          : character.lightTheme.primaryColor,
                                      isDark
                                          ? character.darkTheme.secondaryColor
                                          : character.lightTheme.secondaryColor,
                                    ],
                                  )
                                : LinearGradient(
                                    colors: [
                                      theme.colorScheme.primary,
                                      theme.colorScheme.secondary,
                                    ],
                                  ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (character != null
                                            ? (isDark
                                                  ? character
                                                        .darkTheme
                                                        .primaryColor
                                                  : character
                                                        .lightTheme
                                                        .primaryColor)
                                            : theme.colorScheme.primary)
                                        .withOpacity(0.3),
                                blurRadius: _isSpeaking ? 40 : 20,
                                spreadRadius: _isSpeaking ? 10 : 5,
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Character image or icon
                              if (character?.imagePath != null)
                                ClipOval(
                                  child: Image.asset(
                                    character!.imagePath!,
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        character.icon,
                                        size: 80,
                                        color: Colors.white,
                                      );
                                    },
                                  ),
                                )
                              else
                                Icon(
                                  character?.icon ?? Icons.smart_toy,
                                  size: 80,
                                  color: Colors.white,
                                ),

                              // Speaking indicator rings
                              if (_isSpeaking)
                                ...List.generate(
                                  3,
                                  (index) => Positioned.fill(
                                    child: Container(
                                      margin: EdgeInsets.all(
                                        10.0 * (index + 1),
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withOpacity(
                                            0.3 - (index * 0.1),
                                          ),
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Status Text
                  Text(
                    _isSpeaking
                        ? '${character?.name ?? 'AI'} is speaking...'
                        : _isListening
                        ? 'Listening...'
                        : 'Voice chat mode',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: character != null
                          ? (isDark
                                ? character.darkTheme.primaryColor
                                : character.lightTheme.primaryColor)
                          : theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // Voice control buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Mic button
                      FloatingActionButton.extended(
                        onPressed: _isListening
                            ? _stopListening
                            : _startListening,
                        backgroundColor: _isListening
                            ? Colors.red
                            : (character != null
                                  ? (isDark
                                        ? character.darkTheme.primaryColor
                                        : character.lightTheme.primaryColor)
                                  : theme.colorScheme.primary),
                        icon: Icon(
                          _isListening ? Icons.stop : Icons.mic,
                          color: Colors.white,
                        ),
                        label: Text(
                          _isListening ? 'Stop' : 'Speak',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),

                      // Exit voice chat button
                      FloatingActionButton.extended(
                        onPressed: _exitVoiceChat,
                        backgroundColor: theme.colorScheme.outline,
                        icon: const Icon(Icons.chat, color: Colors.white),
                        label: const Text(
                          'Text Chat',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Minimized chat preview
          if (_messages.isNotEmpty)
            Container(
              margin: const EdgeInsets.all(16),
              height: 60,
              decoration: BoxDecoration(
                color: theme.cardColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: _exitVoiceChat,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _messages.isNotEmpty
                              ? _messages.last.content
                              : 'No messages yet',
                          style: theme.textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_up,
                        color: theme.colorScheme.outline,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNormalChatMode() {
    final theme = Theme.of(context);
    final character = widget.character;
    final isDark = ref.watch(themeProvider).isDarkMode;

    return Column(
      key: const ValueKey('normal_chat'),
      children: [
        // Character Avatar with Animation
        Container(
          height: 180,
          padding: const EdgeInsets.all(20),
          decoration: character != null
              ? BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      (isDark
                              ? character.darkTheme.primaryColor
                              : character.lightTheme.primaryColor)
                          .withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                )
              : null,
          child: Center(
            child: AnimatedBuilder(
              animation: _isSpeaking ? _speakingAnimation : _idleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isSpeaking
                      ? _speakingAnimation.value
                      : _idleAnimation.value,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: character != null
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                isDark
                                    ? character.darkTheme.primaryColor
                                    : character.lightTheme.primaryColor,
                                isDark
                                    ? character.darkTheme.secondaryColor
                                    : character.lightTheme.secondaryColor,
                              ],
                            )
                          : LinearGradient(
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.secondary,
                              ],
                            ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              (character != null
                                      ? (isDark
                                            ? character.darkTheme.primaryColor
                                            : character.lightTheme.primaryColor)
                                      : theme.colorScheme.primary)
                                  .withOpacity(0.3),
                          blurRadius: _isSpeaking ? 20 : 10,
                          spreadRadius: _isSpeaking ? 5 : 2,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Character image or icon
                        if (character?.imagePath != null)
                          ClipOval(
                            child: Image.asset(
                              character!.imagePath!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  character.icon,
                                  size: 40,
                                  color: Colors.white,
                                );
                              },
                            ),
                          )
                        else
                          Icon(
                            character?.icon ?? Icons.smart_toy,
                            size: 40,
                            color: Colors.white,
                          ),

                        // Speaking indicator
                        if (_isSpeaking)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.7),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),

                        // Speaking dots
                        if (_isSpeaking)
                          Positioned(
                            bottom: 10,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildSpeakingDot(0),
                                const SizedBox(width: 3),
                                _buildSpeakingDot(1),
                                const SizedBox(width: 3),
                                _buildSpeakingDot(2),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Status Text
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            _isSpeaking
                ? '${character?.name ?? 'AI'} is speaking...'
                : _isListening
                ? 'Listening...'
                : 'Ready to chat',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: character != null
                  ? (isDark
                        ? character.darkTheme.primaryColor
                        : character.lightTheme.primaryColor)
                  : theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 20),

        // Chat Messages
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: _messages.isEmpty
                      ? Center(
                          child: Text(
                            'Start a conversation!',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            return _buildMessageBubble(_messages[index]);
                          },
                        ),
                ),

                // Input Area
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: theme.colorScheme.surface.withOpacity(
                              0.5,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          onSubmitted: _sendMessage,
                        ),
                      ),
                      const SizedBox(width: 12),
                      FloatingActionButton.small(
                        onPressed: _enterVoiceChat,
                        backgroundColor: character != null
                            ? (isDark
                                  ? character.darkTheme.primaryColor
                                  : character.lightTheme.primaryColor)
                            : theme.colorScheme.primary,
                        child: const Icon(Icons.mic, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      FloatingActionButton.small(
                        onPressed: () => _sendMessage(_messageController.text),
                        backgroundColor: character != null
                            ? (isDark
                                  ? character.darkTheme.primaryColor
                                  : character.lightTheme.primaryColor)
                            : theme.colorScheme.primary,
                        child: const Icon(Icons.send, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeakingDot(int index) {
    return AnimatedBuilder(
      animation: _speakingAnimationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0,
            -5 * _speakingAnimation.value * (index * 0.5 + 0.5),
          ),
          child: Container(
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageBubble(story_domain.ChatMessage message) {
    final theme = Theme.of(context);
    final character = widget.character;
    final isDark = ref.watch(themeProvider).isDarkMode;

    return Align(
      alignment: message.isFromUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isFromUser
              ? (character != null
                    ? (isDark
                          ? character.darkTheme.primaryColor
                          : character.lightTheme.primaryColor)
                    : theme.colorScheme.primary)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20).copyWith(
            bottomLeft: message.isFromUser ? null : const Radius.circular(4),
            bottomRight: message.isFromUser ? const Radius.circular(4) : null,
          ),
        ),
        child: Text(
          message.content,
          style: TextStyle(
            color: message.isFromUser
                ? Colors.white
                : theme.textTheme.bodyMedium?.color,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final userMessage = story_domain.ChatMessage(
      id: _uuid.v4(),
      content: text.trim(),
      isFromUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
    });

    _messageController.clear();

    // Save message to story
    ref
        .read(storyProvider.notifier)
        .addChatMessage(widget.story.id, userMessage);

    _simulateModelResponse(text.trim());
  }

  void _simulateModelResponse(String userMessage) {
    setState(() {
      _isSpeaking = true;
    });

    _speakingAnimationController.repeat(reverse: true);

    // Simulate thinking time
    Future.delayed(const Duration(seconds: 2), () {
      final responses = _getCharacterResponses(
        widget.character?.id,
        userMessage,
      );
      final response = responses[DateTime.now().millisecond % responses.length];

      final aiMessage = story_domain.ChatMessage(
        id: _uuid.v4(),
        content: response,
        isFromUser: false,
        timestamp: DateTime.now(),
      );

      setState(() {
        _messages.add(aiMessage);
        _isSpeaking = false;
      });

      // Save message to story
      ref
          .read(storyProvider.notifier)
          .addChatMessage(widget.story.id, aiMessage);

      _speakingAnimationController.stop();
      _speakingAnimationController.reset();
    });
  }

  List<String> _getCharacterResponses(String? characterId, String userMessage) {
    switch (characterId) {
      case 'sherlock_holmes':
        return [
          "Fascinating! Let me apply my deductive reasoning to this mystery. What other clues can you provide?",
          "Elementary, my dear friend! This case has all the makings of an intriguing adventure.",
          "The evidence suggests we're on the right track. What would you like to investigate next?",
        ];
      case 'peppa_pig':
        return [
          "Ooh, that sounds like so much fun! Can we invite Suzy Sheep and Pedro Pony too?",
          "I love playing games! Should we jump in muddy puddles while we talk about this?",
          "That's brilliant! Daddy Pig would be so proud of this idea!",
        ];
      case 'dora_explorer':
        return [
          "¡Excelente! That's an amazing adventure idea! Where should we explore first?",
          "Boots and I think that's fantastic! Can you help us figure out what to do next?",
          "¡Vámonos! Let's go on this exciting journey together!",
        ];
      case 'iron_man':
        return [
          "FRIDAY, analyze this concept. Looks like we've got a winner here!",
          "That's genius-level thinking! My arc reactor is practically humming with excitement.",
          "I like your style. Let's suit up and make this idea reality!",
        ];
      case 'elsa_frozen':
        return [
          "That's beautiful! Like ice crystals forming a perfect pattern in winter.",
          "Your idea sparkles like fresh snow! I can feel the magic in it.",
          "Let it go, let it grow! This story idea has real potential.",
        ];
      case 'spider_man':
        return [
          "With great power comes great storytelling! I love where this is going.",
          "My spider-senses are tingling with excitement about this idea!",
          "That's web-slinging fantastic! What amazing twist should we add next?",
        ];
      case 'winnie_pooh':
        return [
          "Oh bother, that's a lovely idea! It's almost as sweet as honey.",
          "Piglet would love this story! It's gentle and kind, just like a warm hug.",
          "Think, think, think... Yes, this is a very good idea indeed!",
        ];
      case 'mickey_mouse':
        return [
          "Ha-ha! That's a hot dog of an idea! Minnie and I think it's wonderful!",
          "Oh boy, oh boy! This is going to be such a magical adventure!",
          "That's what I call mouse-tastic thinking! What should we do next?",
        ];
      default:
        return [
          "That's a wonderful idea! I'm excited to explore this story with you.",
          "Great thinking! How would you like to develop this concept further?",
          "I love your creativity! What aspect should we focus on next?",
        ];
    }
  }

  void _startListening() {
    setState(() {
      _isListening = true;
    });

    // Simulate voice recognition
    Future.delayed(const Duration(seconds: 3), () {
      if (_isListening) {
        setState(() {
          _isListening = false;
        });

        // Simulate recognized text
        _messageController.text = "Tell me more about this story!";
      }
    });
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
  }

  void _enterVoiceChat() {
    setState(() {
      _isVoiceChatMode = true;
    });
  }

  void _exitVoiceChat() {
    setState(() {
      _isVoiceChatMode = false;
    });
  }
}
