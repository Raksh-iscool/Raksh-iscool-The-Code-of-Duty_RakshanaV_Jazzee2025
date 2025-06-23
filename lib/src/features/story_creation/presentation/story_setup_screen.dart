import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../routing/app_router.dart';
import '../application/story_setup_controller.dart';
import '../domain/character.dart' as story_characters;
import '../domain/story_state.dart';

class StorySetupScreen extends ConsumerWidget {
  const StorySetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(storySetupControllerProvider);
    final controller = ref.read(storySetupControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Story'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goToHome(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: _calculateProgress(state),
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppTheme.primaryColor,
              ),
            ),
            const Gap(AppConstants.largePadding),

            // Character Selection Section
            Text(
              'Choose Your Characters',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(AppConstants.smallPadding),
            Text(
              'Select up to ${AppConstants.maxCharacters} characters for your story',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const Gap(AppConstants.defaultPadding),

            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: story_characters.Characters.all.length,
                itemBuilder: (context, index) {
                  final character = story_characters.Characters.all[index];
                  final isSelected = state.selectedCharacters.contains(
                    character,
                  );

                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < story_characters.Characters.all.length - 1
                          ? AppConstants.defaultPadding
                          : 0,
                    ),
                    child: CharacterCard(
                      character: character,
                      isSelected: isSelected,
                      onTap: () => controller.toggleCharacter(character),
                      canSelect:
                          !isSelected ||
                          state.selectedCharacters.length <
                              AppConstants.maxCharacters,
                    ),
                  );
                },
              ),
            ),

            const Gap(AppConstants.largePadding),

            // Image Upload Section
            Text(
              'Add Inspiration Image (Optional)',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(AppConstants.smallPadding),
            Text(
              'Upload an image to inspire your story setting',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const Gap(AppConstants.defaultPadding),

            ImageUploadWidget(
              imagePath: state.selectedImagePath,
              onImageSelected: controller.selectImage,
              onImageRemoved: controller.removeImage,
            ),

            const Gap(AppConstants.largePadding),

            // Initial Prompt Section
            Text(
              'Story Starter',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(AppConstants.smallPadding),
            Text(
              'Give us a starting point for your story adventure',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const Gap(AppConstants.defaultPadding),

            TextField(
              onChanged: controller.updatePrompt,
              maxLines: 4,
              decoration: InputDecoration(
                hintText:
                    'Once upon a time...\n\nOr choose from suggestions below!',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.defaultBorderRadius,
                  ),
                ),
              ),
            ),

            const Gap(AppConstants.defaultPadding),

            // Prompt Suggestions
            Wrap(
              spacing: AppConstants.smallPadding,
              runSpacing: AppConstants.smallPadding,
              children: AppConstants.storyPrompts.map((prompt) {
                return ActionChip(
                  label: Text(prompt),
                  onPressed: () => controller.updatePrompt(prompt),
                  backgroundColor: AppTheme.primaryLight.withOpacity(0.2),
                );
              }).toList(),
            ),

            const Gap(AppConstants.largePadding * 2),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: ElevatedButton(
          onPressed: state.canProceed
              ? () => _startStory(context, state)
              : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: state.isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Start Storytelling Adventure!'),
        ),
      ),
    );
  }

  double _calculateProgress(StorySetupState state) {
    double progress = 0.0;
    if (state.selectedCharacters.isNotEmpty) progress += 0.4;
    if (state.initialPrompt.trim().isNotEmpty) progress += 0.6;
    return progress;
  }

  void _startStory(BuildContext context, StorySetupState state) {
    context.goToStory(
      characters: state.selectedCharacters,
      prompt: state.initialPrompt,
      imagePath: state.selectedImagePath,
    );
  }
}

class CharacterCard extends StatelessWidget {
  final story_characters.Character character;
  final bool isSelected;
  final VoidCallback onTap;
  final bool canSelect;

  const CharacterCard({
    super.key,
    required this.character,
    required this.isSelected,
    required this.onTap,
    required this.canSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: canSelect ? onTap : null,
      child: AnimatedContainer(
        duration: AppConstants.fastAnimationDuration,
        width: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
            width: isSelected ? 3 : 1,
          ),
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.1)
              : Colors.white,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade100,
              ),
              child: character.imagePath != null
                  ? ClipOval(
                      child: Image.asset(
                        character.imagePath!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            _getCharacterIcon(character.id),
                            size: 30,
                            color: isSelected
                                ? AppTheme.primaryColor
                                : Colors.grey.shade600,
                          );
                        },
                      ),
                    )
                  : Icon(
                      _getCharacterIcon(character.id),
                      size: 30,
                      color: isSelected
                          ? AppTheme.primaryColor
                          : Colors.grey.shade600,
                    ),
            ),
            const Gap(AppConstants.smallPadding),
            Text(
              character.name,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppTheme.primaryColor : null,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
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
}

class ImageUploadWidget extends StatelessWidget {
  final String? imagePath;
  final Function(String) onImageSelected;
  final VoidCallback onImageRemoved;

  const ImageUploadWidget({
    super.key,
    this.imagePath,
    required this.onImageSelected,
    required this.onImageRemoved,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade50,
      ),
      child: imagePath != null
          ? Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppConstants.defaultBorderRadius,
                  ),
                  child: Image.file(
                    File(imagePath!),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onImageRemoved,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : InkWell(
              onTap: () => _pickImage(context),
              borderRadius: BorderRadius.circular(
                AppConstants.defaultBorderRadius,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                  const Gap(AppConstants.smallPadding),
                  Text(
                    'Tap to add an image',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        onImageSelected(image.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppConstants.imagePickerErrorMessage)),
        );
      }
    }
  }
}
