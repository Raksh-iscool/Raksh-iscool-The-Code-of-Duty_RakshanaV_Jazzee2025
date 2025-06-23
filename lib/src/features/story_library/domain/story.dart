import 'package:hive/hive.dart';

part 'story.g.dart';

@HiveType(typeId: 0)
class Story extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String? pdfPath;

  @HiveField(4)
  final String characterId;

  @HiveField(5)
  final DateTime createdAt;

  @HiveField(6)
  final DateTime lastAccessedAt;

  @HiveField(7)
  final List<String> tags;

  @HiveField(8)
  final String? coverImagePath;

  @HiveField(9)
  final int? ageRange;

  @HiveField(10)
  final String? genre;

  @HiveField(11)
  final List<ChatMessage> chatHistory;

  @HiveField(12)
  final String content;

  @HiveField(13)
  final int duration; // in seconds

  Story({
    required this.id,
    required this.title,
    required this.description,
    this.pdfPath,
    required this.characterId,
    required this.createdAt,
    required this.lastAccessedAt,
    this.tags = const [],
    this.coverImagePath,
    this.ageRange,
    this.genre,
    this.chatHistory = const [],
    this.content = '',
    this.duration = 0,
  });

  Story copyWith({
    String? id,
    String? title,
    String? description,
    String? pdfPath,
    String? characterId,
    DateTime? createdAt,
    DateTime? lastAccessedAt,
    List<String>? tags,
    String? coverImagePath,
    int? ageRange,
    String? genre,
    List<ChatMessage>? chatHistory,
    String? content,
    int? duration,
  }) {
    return Story(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      pdfPath: pdfPath ?? this.pdfPath,
      characterId: characterId ?? this.characterId,
      createdAt: createdAt ?? this.createdAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      tags: tags ?? this.tags,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      ageRange: ageRange ?? this.ageRange,
      genre: genre ?? this.genre,
      chatHistory: chatHistory ?? this.chatHistory,
      content: content ?? this.content,
      duration: duration ?? this.duration,
    );
  }

  // Helper getter for favorite status
  bool get isFavorite => tags.contains('favorite');
}

@HiveType(typeId: 1)
class ChatMessage extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final bool isFromUser;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final MessageType type;

  @HiveField(5)
  final String? audioPath;

  @HiveField(6)
  final bool isPlaying;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isFromUser,
    required this.timestamp,
    this.type = MessageType.text,
    this.audioPath,
    this.isPlaying = false,
  });

  ChatMessage copyWith({
    String? id,
    String? content,
    bool? isFromUser,
    DateTime? timestamp,
    MessageType? type,
    String? audioPath,
    bool? isPlaying,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isFromUser: isFromUser ?? this.isFromUser,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      audioPath: audioPath ?? this.audioPath,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}

@HiveType(typeId: 2)
enum MessageType {
  @HiveField(0)
  text,
  @HiveField(1)
  audio,
  @HiveField(2)
  system,
}
