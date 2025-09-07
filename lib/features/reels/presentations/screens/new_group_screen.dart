import 'package:flutter/material.dart';

class NewGroupScreen extends StatefulWidget {
  const NewGroupScreen({super.key});

  @override
  State<NewGroupScreen> createState() => _NewGroupScreenState();
}

class _NewGroupScreenState extends State<NewGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  // (Dummy contacts list and other logic remains the same)
  final List<Map<String, String>> _allContacts = [
    {
      "id": "1",
      "name": "✨mxhi✨",
      "username": "_.mxhi._75",
      "avatar": "https://i.pravatar.cc/150?img=31",
    },
    {
      "id": "2",
      "name": "Subba jully",
      "username": "subbajully._.17",
      "avatar": "https://i.pravatar.cc/150?img=32",
    },
    {
      "id": "3",
      "name": "toxic_davis",
      "username": "toxic_davis",
      "avatar": "https://i.pravatar.cc/150?img=33",
    },
    {
      "id": "4",
      "name": "Anu",
      "username": "a.n.u.r.a.d.h.a.8",
      "avatar": "https://i.pravatar.cc/150?img=34",
    },
    {
      "id": "5",
      "name": "Aphrodite Weiman",
      "username": "nah_love_im_good",
      "avatar": "https://i.pravatar.cc/150?img=35",
    },
    {
      "id": "6",
      "name": "Lindane",
      "username": "lindane_",
      "avatar": "https://i.pravatar.cc/150?img=36",
    },
    {
      "id": "7",
      "name": "Harish J",
      "username": "harish_j",
      "avatar": "https://i.pravatar.cc/150?img=37",
    },
    {
      "id": "8",
      "name": "Nisha",
      "username": "nisha_",
      "avatar": "https://i.pravatar.cc/150?img=38",
    },
  ];
  final List<String> _selectedIds = [];
  List<Map<String, String>> get _filteredContacts {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return _allContacts;
    return _allContacts.where((c) {
      final name = c['name']!.toLowerCase();
      final username = c['username']!.toLowerCase();
      return name.contains(q) || username.contains(q);
    }).toList();
  }

  bool _isSelected(String id) => _selectedIds.contains(id);
  void _toggleSelect(String id) {
    setState(() {
      if (_isSelected(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _removeSelected(String id) {
    setState(() {
      _selectedIds.remove(id);
    });
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✨ MODIFIED: The key to making the whole screen theme-aware
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // ✨ MODIFIED: Use the theme's scaffold color
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        // ✨ MODIFIED: Use the theme's AppBar color and let the theme handle icon colors
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        // The Icon color is now handled by the AppBar's iconTheme in your AppTheme
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // The Text style is handled by the AppBar's titleTextStyle in your AppTheme
        title: Text(
          'New Group',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus!.unfocus();
          },
          child: Column(
            children: [
              // optional group name label + textfield
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name group (optional)',
                      // ✨ MODIFIED: Dynamic text color
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _groupNameController,
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        hintText: 'Group name',
                        hintStyle: TextStyle(
                          color: isDarkMode ? Colors.white38 : Colors.black38,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: isDarkMode ? Colors.white38 : Colors.black38,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: isDarkMode ? Colors.white : Colors.black,
                            width: 2, // make it thicker when focused
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 12,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor:
                        isDarkMode ? const Color(0xFF262626) : Colors.grey[200],
                    isDense: true, // makes it more compact
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8, // adjust this to shrink height
                      horizontal: 12,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                    hintText: 'Search',
                    hintStyle: TextStyle(
                      color: isDarkMode ? Colors.white38 : Colors.black38,
                    ),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color:
                                    isDarkMode
                                        ? Colors.white70
                                        : Colors.black54,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Selected avatars row
              if (_selectedIds.isNotEmpty)
                Container(
                  padding: const EdgeInsets.only(
                    left: 18,
                    right: 6,
                    top: 6,
                    bottom: 8,
                  ),
                  child: SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedIds.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, idx) {
                        final id = _selectedIds[idx];
                        final contact = _allContacts.firstWhere(
                          (c) => c['id'] == id,
                        );
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  radius: 34,
                                  backgroundImage: NetworkImage(
                                    contact['avatar']!,
                                  ),
                                  // ✨ MODIFIED: Dynamic fallback background
                                  backgroundColor:
                                      isDarkMode
                                          ? Colors.grey[800]
                                          : Colors.grey[200],
                                ),
                                const SizedBox(height: 6),
                                SizedBox(
                                  width: 72,
                                  child: Text(
                                    contact['name']!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      // ✨ MODIFIED: Dynamic text color
                                      color:
                                          isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            // "X" button
                            Positioned(
                              right: -3,
                              top: 0,
                              child: GestureDetector(
                                onTap: () => _removeSelected(id),
                                child: Container(
                                  height: 28,
                                  width: 28,
                                  decoration: BoxDecoration(
                                    // ✨ MODIFIED: Dynamic background color
                                    color:
                                        isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 18,
                                    // ✨ MODIFIED: Dynamic icon color
                                    color:
                                        isDarkMode
                                            ? Colors.black
                                            : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

              // "Suggested" title
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 6,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Suggested',
                    style: TextStyle(
                      // Dynamic text color
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              // The list of contacts
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  itemCount: _filteredContacts.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 6),
                  itemBuilder: (context, index) {
                    final c = _filteredContacts[index];
                    final id = c['id']!;
                    final selected = _isSelected(id);

                    return InkWell(
                      onTap: () => _toggleSelect(id),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundImage: NetworkImage(c['avatar']!),
                              // ✨ MODIFIED: Dynamic fallback background
                              backgroundColor:
                                  isDarkMode
                                      ? Colors.grey[800]
                                      : Colors.grey[200],
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c['name']!,
                                    style: TextStyle(
                                      // ✨ MODIFIED: Dynamic text color
                                      color:
                                          isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    c['username']!,
                                    style: TextStyle(
                                      // ✨ MODIFIED: Dynamic text color
                                      color:
                                          isDarkMode
                                              ? Colors.white.withOpacity(0.6)
                                              : Colors.black.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Custom checkbox
                            GestureDetector(
                              onTap: () => _toggleSelect(id),
                              child: Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                  // ✨ MODIFIED: Fully dynamic checkbox style
                                  color:
                                      selected
                                          ? (isDarkMode
                                              ? Colors.white
                                              : Colors.black)
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color:
                                        selected
                                            ? (isDarkMode
                                                ? Colors.white
                                                : Colors.black)
                                            : (isDarkMode
                                                ? Colors.white54
                                                : Colors.black54),
                                    width: selected ? 0 : 1.5,
                                  ),
                                ),
                                child:
                                    selected
                                        ? Icon(
                                          Icons.check,
                                          color:
                                              isDarkMode
                                                  ? Colors.black
                                                  : Colors.white,
                                          size: 20,
                                        )
                                        : const SizedBox.shrink(),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom action button
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 12,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed:
                          _selectedIds.isNotEmpty
                              ? () {
                                /* ... */
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF5B6BFF,
                        ), // Brand color, same for both themes
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        // ✨ MODIFIED: Dynamic disabled color
                        disabledBackgroundColor:
                            isDarkMode ? Colors.white24 : Colors.black12,
                      ),
                      child: Text(
                        'Send to Group',
                        style: TextStyle(
                          // Text color is white on blue, and a lighter white on grey, works for both themes
                          color:
                              _selectedIds.isNotEmpty
                                  ? Colors.white
                                  : Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
