import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final onboardingServiceProvider = Provider<OnboardingService>((ref) {
  return OnboardingService();
});

final hasCompletedOnboardingProvider = FutureProvider<bool>((ref) {
  final service = ref.read(onboardingServiceProvider);
  return service.hasCompletedOnboarding();
});

class OnboardingService {
  static const String _onboardingKey = 'has_completed_onboarding';
  static const String _settingsBoxKey = 'settings';

  Future<bool> hasCompletedOnboarding() async {
    try {
      final box = Hive.box(_settingsBoxKey);
      return box.get(_onboardingKey, defaultValue: false);
    } catch (e) {
      return false;
    }
  }

  Future<void> markOnboardingCompleted() async {
    try {
      final box = Hive.box(_settingsBoxKey);
      await box.put(_onboardingKey, true);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> resetOnboarding() async {
    try {
      final box = Hive.box(_settingsBoxKey);
      await box.delete(_onboardingKey);
    } catch (e) {
      // Handle error silently
    }
  }
}
