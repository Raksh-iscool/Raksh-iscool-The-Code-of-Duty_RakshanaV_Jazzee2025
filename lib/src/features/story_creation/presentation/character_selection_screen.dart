import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/theme_provider.dart';
import '../domain/character.dart' as app_characters;

class CharacterSelectionScreen extends ConsumerWidget {
  const CharacterSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCharacter = ref.watch(selectedCharacterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Character'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (selectedCharacter != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: selectedCharacter.imagePath == null
                              ? Theme.of(context).primaryColor.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: selectedCharacter.imagePath != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.asset(
                                  selectedCharacter.imagePath!,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.person,
                                      size: 30,
                                      color: Theme.of(context).primaryColor,
                                    );
                                  },
                                ),
                              )
                            : Icon(
                                Icons.person,
                                size: 30,
                                color: Theme.of(context).primaryColor,
                              ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selected: ${selectedCharacter.name}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              selectedCharacter.description,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: app_characters.Characters.all.length,
                itemBuilder: (context, index) {
                  final character = app_characters.Characters.all[index];
                  final isSelected = selectedCharacter?.id == character.id;

                  return GestureDetector(
                    onTap: () {
                      ref
                          .read(selectedCharacterProvider.notifier)
                          .selectCharacter(character);
                      ref
                          .read(themeProvider.notifier)
                          .setCharacterTheme(character.id);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Selected ${character.name}!'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: Card(
                        elevation: isSelected ? 12 : 6,
                        shadowColor: isSelected
                            ? Theme.of(context).primaryColor.withOpacity(0.3)
                            : Theme.of(context).shadowColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: isSelected
                              ? BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                )
                              : BorderSide.none,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: isSelected
                                ? LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Theme.of(
                                        context,
                                      ).primaryColor.withOpacity(0.05),
                                      Theme.of(
                                        context,
                                      ).primaryColor.withOpacity(0.02),
                                    ],
                                  )
                                : null,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Theme.of(
                                            context,
                                          ).primaryColor.withOpacity(0.15),
                                          Theme.of(
                                            context,
                                          ).primaryColor.withOpacity(0.08),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Theme.of(
                                          context,
                                        ).primaryColor.withOpacity(0.1),
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: AnimatedScale(
                                        scale: isSelected ? 1.1 : 1.0,
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        child: character.imagePath != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Image.asset(
                                                  character.imagePath!,
                                                  width: 80,
                                                  height: 80,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return Icon(
                                                          _getCharacterIcon(
                                                            character.id,
                                                          ),
                                                          size: 50,
                                                          color: Theme.of(
                                                            context,
                                                          ).primaryColor,
                                                        );
                                                      },
                                                ),
                                              )
                                            : Icon(
                                                _getCharacterIcon(character.id),
                                                size: 50,
                                                color: Theme.of(
                                                  context,
                                                ).primaryColor,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  character.name,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  character.personality,
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCharacterIcon(String characterId) {
    switch (characterId) {
      case 'sherlock_holmes':
        return Icons.search;
      case 'peppa_pig':
        return Icons.pets;
      case 'dora_explorer':
        return Icons.explore;
      case 'iron_man':
        return Icons.engineering;
      case 'elsa_frozen':
        return Icons.ac_unit;
      case 'spider_man':
        return Icons.bug_report;
      case 'winnie_pooh':
        return Icons.favorite;
      case 'mickey_mouse':
        return Icons.sentiment_very_satisfied;
      default:
        return Icons.person;
    }
  }
}
