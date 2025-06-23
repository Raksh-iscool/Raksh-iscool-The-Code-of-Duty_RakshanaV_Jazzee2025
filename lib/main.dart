import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'src/app.dart';
import 'src/core/constants/app_constants.dart';
import 'src/features/story_library/domain/story.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(StoryAdapter());
  Hive.registerAdapter(ChatMessageAdapter());
  Hive.registerAdapter(MessageTypeAdapter());

  // Open Hive boxes
  await Hive.openBox<Story>(AppConstants.storiesBoxKey);
  await Hive.openBox(AppConstants.settingsBoxKey);

  runApp(const ProviderScope(child: Tellie()));
}
