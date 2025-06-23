import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/theme_provider.dart';
import '../../story_library/providers/story_provider.dart';
import '../../model_chat/presentation/model_chat_screen.dart';
import '../domain/character.dart';

class StoryCreationScreen extends ConsumerStatefulWidget {
  const StoryCreationScreen({super.key});

  @override
  ConsumerState<StoryCreationScreen> createState() =>
      _StoryCreationScreenState();
}

class _StoryCreationScreenState extends ConsumerState<StoryCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedPdfPath;
  String? _selectedPdfName;
  List<String> _selectedTags = [];
  int? _selectedAgeRange;
  String? _selectedGenre;
  bool _isCreating = false;

  final List<String> _availableTags = [
    'Adventure',
    'Fantasy',
    'Comedy',
    'Educational',
    'Mystery',
    'Friendship',
    'Family',
    'Animals',
    'Magic',
    'Science',
  ];

  final List<int> _ageRanges = [3, 5, 8, 12, 16];

  final List<String> _genres = [
    'Adventure',
    'Fantasy',
    'Comedy',
    'Mystery',
    'Educational',
    'Fairy Tale',
    'Science Fiction',
    'Friendship',
    'Family',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCharacter = ref.watch(selectedCharacterProvider);
    final theme = Theme.of(context);
    final isDark = ref.watch(themeProvider).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Story'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: selectedCharacter == null
          ? _buildSelectCharacterMessage()
          : _buildStoryCreationForm(selectedCharacter, theme, isDark),
      floatingActionButton: selectedCharacter != null
          ? FloatingActionButton.extended(
              onPressed: _isCreating ? null : _createStory,
              icon: _isCreating
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : const Icon(Icons.create),
              label: Text(_isCreating ? 'Creating...' : 'Create Story'),
              backgroundColor: isDark
                  ? selectedCharacter.darkTheme.primaryColor
                  : selectedCharacter.lightTheme.primaryColor,
            )
          : null,
    );
  }

  Widget _buildSelectCharacterMessage() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Please select a character first',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Go to the Characters tab to choose your storytelling companion',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCreationForm(
    Character character,
    ThemeData theme,
    bool isDark,
  ) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Character Info Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
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
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            isDark
                                ? character.darkTheme.primaryColor
                                : character.lightTheme.primaryColor,
                            isDark
                                ? character.darkTheme.secondaryColor
                                : character.lightTheme.secondaryColor,
                          ],
                        ),
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
                                    character.icon,
                                    color: Colors.white,
                                    size: 30,
                                  );
                                },
                              ),
                            )
                          : Icon(character.icon, color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Creating with ${character.name}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            character.personality,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? character.darkTheme.primaryColor
                                  : character.lightTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Story Title
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: 'Story Title',
              hintText: 'Enter a captivating title for your story',
              prefixIcon: const Icon(Icons.title),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a story title';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // Story Description
          TextFormField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Story Description',
              hintText: 'Describe what your story is about',
              prefixIcon: const Icon(Icons.description),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a story description';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          // PDF Upload Section
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.picture_as_pdf, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        'Upload Story PDF (Optional)',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload a PDF file to base your story on existing content',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _pickPDF,
                    icon: const Icon(Icons.upload_file),
                    label: Text(_selectedPdfName ?? 'Choose PDF File'),
                  ),
                  if (_selectedPdfName != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Selected: $_selectedPdfName',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.green,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          onPressed: _clearPDF,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Age Range Selection
          DropdownButtonFormField<int>(
            value: _selectedAgeRange,
            decoration: InputDecoration(
              labelText: 'Age Range',
              prefixIcon: const Icon(Icons.child_care),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: _ageRanges.map((age) {
              return DropdownMenuItem(value: age, child: Text('$age+ years'));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedAgeRange = value;
              });
            },
          ),

          const SizedBox(height: 16),

          // Genre Selection
          DropdownButtonFormField<String>(
            value: _selectedGenre,
            decoration: InputDecoration(
              labelText: 'Genre',
              prefixIcon: const Icon(Icons.category),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: _genres.map((genre) {
              return DropdownMenuItem(value: genre, child: Text(genre));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedGenre = value;
              });
            },
          ),

          const SizedBox(height: 16),

          // Tags Selection
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.label),
                      const SizedBox(width: 8),
                      Text(
                        'Story Tags',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _availableTags.map((tag) {
                      final isSelected = _selectedTags.contains(tag);
                      return FilterChip(
                        label: Text(tag),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedTags.add(tag);
                            } else {
                              _selectedTags.remove(tag);
                            }
                          });
                        },
                        selectedColor:
                            (isDark
                                    ? character.darkTheme.primaryColor
                                    : character.lightTheme.primaryColor)
                                .withOpacity(0.3),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 100), // Space for FAB
        ],
      ),
    );
  }

  Future<void> _pickPDF() async {
    // TODO: Implement file picker functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PDF upload will be available soon!')),
    );
  }

  void _clearPDF() {
    setState(() {
      _selectedPdfPath = null;
      _selectedPdfName = null;
    });
  }

  Future<void> _createStory() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final selectedCharacter = ref.read(selectedCharacterProvider);
    if (selectedCharacter == null) return;

    setState(() {
      _isCreating = true;
    });

    try {
      await ref
          .read(storyProvider.notifier)
          .createStory(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            characterId: selectedCharacter.id,
            pdfPath: _selectedPdfPath,
            tags: _selectedTags,
            ageRange: _selectedAgeRange,
            genre: _selectedGenre,
          );

      if (mounted) {
        // Navigate to chat screen with the new story
        final stories = ref.read(storyProvider);
        final newStory = stories.last; // The most recently created story

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                ModelChatScreen(story: newStory, character: selectedCharacter),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error creating story: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }
}
