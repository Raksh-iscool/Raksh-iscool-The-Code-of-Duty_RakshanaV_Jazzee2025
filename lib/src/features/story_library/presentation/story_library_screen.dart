import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../routing/app_router.dart';
import '../domain/story.dart';

class StoryLibraryScreen extends ConsumerWidget {
  const StoryLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Story Library'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goToHome(),
        ),
      ),
      body: ValueListenableBuilder<Box<Story>>(
        valueListenable: Hive.box<Story>(
          AppConstants.storiesBoxKey,
        ).listenable(),
        builder: (context, box, child) {
          final stories = box.values.toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          if (stories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.auto_stories_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const Gap(AppConstants.defaultPadding),
                  Text(
                    'No stories yet!',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const Gap(AppConstants.smallPadding),
                  Text(
                    'Create your first story adventure',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const Gap(AppConstants.largePadding),
                  ElevatedButton.icon(
                    onPressed: () => context.goToSetup(),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Story'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];
              return StoryCard(
                story: story,
                onTap: () => _showStoryDetails(context, story),
                onFavorite: () => _toggleFavorite(story),
                onDelete: () => _deleteStory(context, story),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goToSetup(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showStoryDetails(BuildContext context, Story story) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StoryDetailsSheet(story: story),
    );
  }

  void _toggleFavorite(Story story) {
    final tags = List<String>.from(story.tags);
    if (story.isFavorite) {
      tags.remove('favorite');
    } else {
      tags.add('favorite');
    }

    final updatedStory = story.copyWith(tags: tags);
    // Save to Hive
    final box = Hive.box<Story>(AppConstants.storiesBoxKey);
    box.put(story.id, updatedStory);
  }

  void _deleteStory(BuildContext context, Story story) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Story'),
        content: Text('Are you sure you want to delete "${story.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              story.delete();
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class StoryCard extends StatelessWidget {
  final Story story;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final VoidCallback onDelete;

  const StoryCard({
    super.key,
    required this.story,
    required this.onTap,
    required this.onFavorite,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      story.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      story.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: story.isFavorite ? Colors.red : null,
                    ),
                    onPressed: onFavorite,
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            Gap(8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'delete') onDelete();
                    },
                  ),
                ],
              ),
              if (story.content.isNotEmpty) ...[
                const Gap(AppConstants.smallPadding),
                Text(
                  story.content,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const Gap(AppConstants.defaultPadding),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const Gap(4),
                  Text(
                    _formatDate(story.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const Spacer(),
                  if (story.duration > 0) ...[
                    Icon(Icons.timer, size: 16, color: Colors.grey.shade600),
                    const Gap(4),
                    Text(
                      _formatDuration(story.duration),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

class StoryDetailsSheet extends StatelessWidget {
  final Story story;

  const StoryDetailsSheet({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Gap(AppConstants.defaultPadding),
              Text(
                story.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(AppConstants.smallPadding),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const Gap(4),
                  Text(
                    'Created ${_formatDate(story.createdAt)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  if (story.duration > 0) ...[
                    const Gap(AppConstants.defaultPadding),
                    Icon(Icons.timer, size: 16, color: Colors.grey.shade600),
                    const Gap(4),
                    Text(
                      _formatDuration(story.duration),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
              const Gap(AppConstants.largePadding),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Text(
                    story.content,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(height: 1.6),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
