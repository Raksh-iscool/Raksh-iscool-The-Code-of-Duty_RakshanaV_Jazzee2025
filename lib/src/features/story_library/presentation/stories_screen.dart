import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/theme_provider.dart';
import '../../story_creation/domain/character.dart';
import '../../model_chat/presentation/model_chat_screen.dart';
import '../domain/story.dart';
import '../providers/story_provider.dart';
import '../../story_creation/presentation/story_creation_screen.dart';

class StoriesScreen extends ConsumerStatefulWidget {
  const StoriesScreen({super.key});

  @override
  ConsumerState<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends ConsumerState<StoriesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stories = ref.watch(storyProvider);
    final recentStories = ref.watch(recentStoriesProvider);
    final favoriteStories = ref.watch(favoriteStoriesProvider);

    final filteredStories = _searchQuery.isEmpty
        ? stories
        : ref.read(storyProvider.notifier).searchStories(_searchQuery);

    final filteredRecent = _searchQuery.isEmpty
        ? recentStories
        : recentStories
              .where(
                (story) =>
                    story.title.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    story.description.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
              )
              .toList();

    final filteredFavorites = _searchQuery.isEmpty
        ? favoriteStories
        : favoriteStories
              .where(
                (story) =>
                    story.title.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    story.description.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ),
              )
              .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stories'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search stories...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              // Tab bar
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'All Stories'),
                  Tab(text: 'Recent'),
                  Tab(text: 'Favorites'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStoriesList(filteredStories, 'No stories yet'),
          _buildStoriesList(filteredRecent, 'No recent stories'),
          _buildStoriesList(filteredFavorites, 'No favorite stories'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const StoryCreationScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Story'),
      ),
    );
  }

  Widget _buildStoriesList(List<Story> stories, String emptyMessage) {
    if (stories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_stories_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first story to get started!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return _buildStoryCard(story);
      },
    );
  }

  Widget _buildStoryCard(Story story) {
    final theme = Theme.of(context);
    final character = Character.getCharacterById(story.characterId);
    final isDark = ref.watch(themeProvider).isDarkMode;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          // Update last accessed time
          ref.read(storyProvider.notifier).updateLastAccessedAt(story.id);

          // Navigate to chat screen
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  ModelChatScreen(story: story, character: character),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: character != null
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
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
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Character avatar
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: character != null
                            ? LinearGradient(
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
                      ),
                      child: character?.imagePath != null
                          ? ClipOval(
                              child: Image.asset(
                                character!.imagePath!,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    character.icon,
                                    color: Colors.white,
                                    size: 24,
                                  );
                                },
                              ),
                            )
                          : Icon(
                              character?.icon ?? Icons.auto_stories,
                              color: Colors.white,
                              size: 24,
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            story.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            character?.name ?? 'Unknown Character',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: character != null
                                  ? (isDark
                                        ? character.darkTheme.primaryColor
                                        : character.lightTheme.primaryColor)
                                  : theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // More options menu
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'delete':
                            _showDeleteConfirmation(story);
                            break;
                          case 'favorite':
                            _toggleFavorite(story);
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'favorite',
                          child: Row(
                            children: [
                              Icon(
                                story.tags.contains('favorite')
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                story.tags.contains('favorite')
                                    ? 'Remove from Favorites'
                                    : 'Add to Favorites',
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  story.description,
                  style: theme.textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: theme.colorScheme.outline,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Last played ${_formatDate(story.lastAccessedAt)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                    const Spacer(),
                    if (story.chatHistory.isNotEmpty) ...[
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 16,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${story.chatHistory.length} messages',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ],
                ),
                if (story.tags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    children: story.tags.take(3).map((tag) {
                      return Chip(
                        label: Text(tag),
                        labelStyle: theme.textTheme.bodySmall,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Story story) {
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
              ref.read(storyProvider.notifier).deleteStory(story.id);
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(Story story) {
    final tags = List<String>.from(story.tags);
    if (tags.contains('favorite')) {
      tags.remove('favorite');
    } else {
      tags.add('favorite');
    }

    final updatedStory = story.copyWith(tags: tags);
    ref.read(storyProvider.notifier).updateStory(updatedStory);
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}
