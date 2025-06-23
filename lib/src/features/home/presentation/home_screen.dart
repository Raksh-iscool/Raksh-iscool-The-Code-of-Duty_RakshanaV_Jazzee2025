import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../routing/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.primaryLight, AppTheme.primaryColor],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.largePadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo and Title
                Column(
                  children: [
                    SizedBox(
                      height: 120,
                      width: 120,
                      child: Lottie.asset(
                        AppConstants.idleAnimation,
                        fit: BoxFit.contain,
                      ),
                    ).animate().scale(
                      duration: AppConstants.slowAnimationDuration,
                      curve: Curves.elasticOut,
                    ),
                    const Gap(AppConstants.largePadding),
                    Text(
                      'Tellie',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().slideY(
                      begin: 0.5,
                      duration: AppConstants.defaultAnimationDuration,
                      delay: 200.ms,
                    ),
                    const Gap(AppConstants.defaultPadding),
                    Text(
                      'Create magical stories together with AI',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(
                      duration: AppConstants.defaultAnimationDuration,
                      delay: 400.ms,
                    ),
                  ],
                ),
                const Gap(60),

                // Action Buttons
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => context.goToSetup(),
                        icon: const Icon(Icons.auto_stories),
                        label: const Text('Create New Story'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.defaultBorderRadius,
                            ),
                          ),
                        ),
                      ),
                    ).animate().slideX(
                      begin: -0.5,
                      duration: AppConstants.defaultAnimationDuration,
                      delay: 600.ms,
                    ),
                    const Gap(AppConstants.defaultPadding),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => context.goToLibrary(),
                        icon: const Icon(Icons.library_books),
                        label: const Text('My Story Library'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white, width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.defaultBorderRadius,
                            ),
                          ),
                        ),
                      ),
                    ).animate().slideX(
                      begin: 0.5,
                      duration: AppConstants.defaultAnimationDuration,
                      delay: 800.ms,
                    ),
                  ],
                ),

                const Gap(40),

                // Fun Stats or Tips
                Container(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(
                      AppConstants.defaultBorderRadius,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lightbulb_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                      const Gap(AppConstants.smallPadding),
                      Expanded(
                        child: Text(
                          'Tip: Speak clearly and let your imagination run wild!',
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(
                  duration: AppConstants.defaultAnimationDuration,
                  delay: 1000.ms,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
