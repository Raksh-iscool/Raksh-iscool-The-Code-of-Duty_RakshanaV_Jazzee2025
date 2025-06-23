// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoryAdapter extends TypeAdapter<Story> {
  @override
  final int typeId = 0;

  @override
  Story read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Story(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      pdfPath: fields[3] as String?,
      characterId: fields[4] as String,
      createdAt: fields[5] as DateTime,
      lastAccessedAt: fields[6] as DateTime,
      tags: (fields[7] as List).cast<String>(),
      coverImagePath: fields[8] as String?,
      ageRange: fields[9] as int?,
      genre: fields[10] as String?,
      chatHistory: (fields[11] as List).cast<ChatMessage>(),
      content: fields[12] as String,
      duration: fields[13] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Story obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.pdfPath)
      ..writeByte(4)
      ..write(obj.characterId)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.lastAccessedAt)
      ..writeByte(7)
      ..write(obj.tags)
      ..writeByte(8)
      ..write(obj.coverImagePath)
      ..writeByte(9)
      ..write(obj.ageRange)
      ..writeByte(10)
      ..write(obj.genre)
      ..writeByte(11)
      ..write(obj.chatHistory)
      ..writeByte(12)
      ..write(obj.content)
      ..writeByte(13)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChatMessageAdapter extends TypeAdapter<ChatMessage> {
  @override
  final int typeId = 1;

  @override
  ChatMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatMessage(
      id: fields[0] as String,
      content: fields[1] as String,
      isFromUser: fields[2] as bool,
      timestamp: fields[3] as DateTime,
      type: fields[4] as MessageType,
      audioPath: fields[5] as String?,
      isPlaying: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessage obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.isFromUser)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.audioPath)
      ..writeByte(6)
      ..write(obj.isPlaying);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MessageTypeAdapter extends TypeAdapter<MessageType> {
  @override
  final int typeId = 2;

  @override
  MessageType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MessageType.text;
      case 1:
        return MessageType.audio;
      case 2:
        return MessageType.system;
      default:
        return MessageType.text;
    }
  }

  @override
  void write(BinaryWriter writer, MessageType obj) {
    switch (obj) {
      case MessageType.text:
        writer.writeByte(0);
        break;
      case MessageType.audio:
        writer.writeByte(1);
        break;
      case MessageType.system:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
