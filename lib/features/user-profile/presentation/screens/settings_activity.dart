import 'package:flutter/material.dart';

class SettingsActivity extends StatelessWidget {
  const SettingsActivity({super.key});

  // change this single value to control horizontal padding for the entire page
  static const double _hp = 6.0;

  Widget _leadingIcon(IconData icon, {required bool isDarkMode}) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Center(
        child: Icon(
          icon,
          size: 22,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _sectionHeader(String text, {required bool isDarkMode}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(_hp, 18, _hp, 10),
      child: Text(
        text,
        style: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.black54,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _settingsRow({
    required Widget leading,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    required bool isDarkMode,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 0,
          ),
          leading: leading,
          title: Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          subtitle:
              subtitle != null
                  ? Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  )
                  : null,
          trailing:
              trailing ??
              Icon(
                Icons.chevron_right,
                color: isDarkMode ? Colors.white38 : Colors.black38,
              ),
          onTap: onTap ?? () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 28),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: Text(
            'Settings and activity',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          toolbarHeight: 78,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: _hp, vertical: 8),
          children: [
            // Search field
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(
                  Icons.search,
                  size: 20,
                  color: isDarkMode ? Colors.white54 : Colors.black45,
                ),
                filled: true,
                fillColor:
                    isDarkMode ? Colors.white10 : Color.fromRGBO(0, 0, 0, 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),

            const SizedBox(height: 18),
            Text(
              'Your account',
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black54,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),

            // Accounts center
            Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: _hp,
                    vertical: 8,
                  ),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // ✨ MODIFIED: Dynamic background and icon colors
                      color:
                          isDarkMode
                              ? Colors.white10
                              : Color.fromRGBO(0, 0, 0, 0.05),
                    ),
                    child: Icon(
                      Icons.person_outline,
                      size: 26,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  title: Text(
                    'Accounts Center',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    'Password, security, personal details, ad preferences',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chevron_right,
                        color: isDarkMode ? Colors.white38 : Colors.black38,
                      ),
                    ],
                  ),
                  onTap: () {},
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(_hp, 6, _hp, 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Manage your connected experiences and account settings across Meta technologies. ',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white60 : Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Learn more',
                          // This blue link color works well on both themes
                          style: TextStyle(
                            color: Color(0xFF6EA0FF),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Divider(
              color: isDarkMode ? Colors.white12 : Colors.black12,
              thickness: 10,
            ),

            // All the settings rows...
            _sectionHeader('How you use Instagram', isDarkMode: isDarkMode),
            _settingsRow(
              leading: _leadingIcon(
                Icons.bookmark_border,
                isDarkMode: isDarkMode,
              ),
              title: 'Saved',
              isDarkMode: isDarkMode,
            ),
            _settingsRow(
              leading: _leadingIcon(
                Icons.archive_outlined,
                isDarkMode: isDarkMode,
              ),
              title: 'Archive',
              isDarkMode: isDarkMode,
            ),
            _settingsRow(
              leading: _leadingIcon(
                Icons.query_stats_outlined,
                isDarkMode: isDarkMode,
              ),
              title: 'Your activity',
              isDarkMode: isDarkMode,
            ),
            _settingsRow(
              leading: _leadingIcon(
                Icons.notifications_none,
                isDarkMode: isDarkMode,
              ),
              title: 'Notifications',
              isDarkMode: isDarkMode,
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.access_time, isDarkMode: isDarkMode),
              title: 'Time management',
              isDarkMode: isDarkMode,
            ),

            const SizedBox(height: 18),
            Divider(
              color: isDarkMode ? Colors.white12 : Colors.black12,
              thickness: 10,
            ),
            _sectionHeader('Who can see your content', isDarkMode: isDarkMode),
            _settingsRow(
              leading: _leadingIcon(Icons.lock_outline, isDarkMode: isDarkMode),
              title: 'Account privacy',
              isDarkMode: isDarkMode,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Public',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: isDarkMode ? Colors.white38 : Colors.black38,
                  ),
                ],
              ),
            ),

            // ... (and so on for all other _settingsRow and _sectionHeader calls)
            _settingsRow(
              leading: _leadingIcon(Icons.star_border, isDarkMode: isDarkMode),
              title: 'Close Friends',
              isDarkMode: isDarkMode,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '0',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: isDarkMode ? Colors.white38 : Colors.black38,
                  ),
                ],
              ),
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.access_time, isDarkMode: isDarkMode),
              title: 'Cross posting',
              isDarkMode: isDarkMode,
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.block, isDarkMode: isDarkMode),
              title: 'Blocked',
              isDarkMode: isDarkMode,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '0',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: isDarkMode ? Colors.white38 : Colors.black38,
                  ),
                ],
              ),
            ),
            _settingsRow(
              leading: _leadingIcon(
                Icons.highlight_remove_rounded,
                isDarkMode: isDarkMode,
              ),
              title: 'Hide Stories',
              isDarkMode: isDarkMode,
            ),
            _settingsRow(
              leading: _leadingIcon(
                Icons.people_outline,
                isDarkMode: isDarkMode,
              ),
              title: 'Activity in friends tab',
              isDarkMode: isDarkMode,
            ),

            const SizedBox(height: 18),
            Divider(
              color: isDarkMode ? Colors.white12 : Colors.black12,
              thickness: 10,
            ),
            _sectionHeader(
              'How other can interact with you',
              isDarkMode: isDarkMode,
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.message, isDarkMode: isDarkMode),
              title: 'Messages and story replies',
              isDarkMode: isDarkMode,
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.tag, isDarkMode: isDarkMode),
              title: 'Tags and mentions',
              isDarkMode: isDarkMode,
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.comment, isDarkMode: isDarkMode),
              title: 'Comments',
              isDarkMode: isDarkMode,
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.share, isDarkMode: isDarkMode),
              title: 'Sharing and reuse',
              isDarkMode: isDarkMode,
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.block, isDarkMode: isDarkMode),
              title: 'Restricted',
              isDarkMode: isDarkMode,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '0',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: isDarkMode ? Colors.white38 : Colors.black38,
                  ),
                ],
              ),
            ),
            _settingsRow(
              leading: _leadingIcon(
                Icons.dangerous_rounded,
                isDarkMode: isDarkMode,
              ),
              title: 'Limit interaction',
              isDarkMode: isDarkMode,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Off',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: isDarkMode ? Colors.white38 : Colors.black38,
                  ),
                ],
              ),
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.abc_sharp, isDarkMode: isDarkMode),
              title: 'Hidden words',
              isDarkMode: isDarkMode,
            ),
            _settingsRow(
              leading: _leadingIcon(
                Icons.people_outline_sharp,
                isDarkMode: isDarkMode,
              ),
              title: 'Follow and invite friends',
              isDarkMode: isDarkMode,
            ),

            const SizedBox(height: 18),
            Divider(
              color: isDarkMode ? Colors.white12 : Colors.black12,
              thickness: 10,
            ),
            _sectionHeader('What you see', isDarkMode: isDarkMode),
            _settingsRow(
              leading: _leadingIcon(Icons.star_border, isDarkMode: isDarkMode),
              title: 'Favorites',
              isDarkMode: isDarkMode,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '0',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: isDarkMode ? Colors.white38 : Colors.black38,
                  ),
                ],
              ),
            ),
            _settingsRow(
              leading: _leadingIcon(
                Icons.notifications_off_outlined,
                isDarkMode: isDarkMode,
              ),
              title: 'Muted accounts',
              isDarkMode: isDarkMode,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '0',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: isDarkMode ? Colors.white38 : Colors.black38,
                  ),
                ],
              ),
            ),
            _settingsRow(
              leading: _leadingIcon(
                Icons.video_camera_back_outlined,
                isDarkMode: isDarkMode,
              ),
              title: 'Content preferences',
              isDarkMode: isDarkMode,
            ),
            _settingsRow(
              leading: _leadingIcon(
                Icons.favorite_outlined,
                isDarkMode: isDarkMode,
              ),
              title: 'Like and share counts',
              isDarkMode: isDarkMode,
            ),
            _settingsRow(
              leading: _leadingIcon(
                Icons.subscriptions,
                isDarkMode: isDarkMode,
              ),
              title: 'Subscriptions',
              isDarkMode: isDarkMode,
            ),

            const SizedBox(height: 18),
            Divider(
              color: isDarkMode ? Colors.white12 : Colors.black12,
              thickness: 10,
            ),
            _sectionHeader('Your app and media', isDarkMode: isDarkMode),
            _settingsRow(
              leading: _leadingIcon(
                Icons.phone_android,
                isDarkMode: isDarkMode,
              ),
              title: 'Device permissions',
              isDarkMode: isDarkMode,
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.download, isDarkMode: isDarkMode),
              title: 'Archiving and downloading',
              isDarkMode: isDarkMode,
            ),
            _settingsRow(
              leading: _leadingIcon(
                Icons.accessibility,
                isDarkMode: isDarkMode,
              ),
              title: 'Accessibility',
              isDarkMode: isDarkMode,
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.language, isDarkMode: isDarkMode),
              title: 'Language and translations',
              isDarkMode: isDarkMode,
            ),
            _settingsRow(
              leading: _leadingIcon(
                Icons.signal_cellular_4_bar_outlined,
                isDarkMode: isDarkMode,
              ),
              title: 'Data usage and media quality',
              isDarkMode: isDarkMode,
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.computer, isDarkMode: isDarkMode),
              title: 'App website permissions',
              isDarkMode: isDarkMode,
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.earbuds, isDarkMode: isDarkMode),
              title: 'Eearly access to features',
              isDarkMode: isDarkMode,
            ),

            const SizedBox(height: 18),
            Divider(
              color: isDarkMode ? Colors.white12 : Colors.black12,
              thickness: 10,
            ),
            _sectionHeader('For Families', isDarkMode: isDarkMode),
            _settingsRow(
              leading: _leadingIcon(
                Icons.house_outlined,
                isDarkMode: isDarkMode,
              ),
              title: 'Family center',
              isDarkMode: isDarkMode,
            ),

            const SizedBox(height: 18),
            Divider(
              color: isDarkMode ? Colors.white12 : Colors.black12,
              thickness: 10,
            ),
            _sectionHeader('For professionals', isDarkMode: isDarkMode),
            _settingsRow(
              leading: _leadingIcon(Icons.people_alt, isDarkMode: isDarkMode),
              title: 'Creater tools and insights',
              isDarkMode: isDarkMode,
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.analytics, isDarkMode: isDarkMode),
              title: 'Account type and tools',
              isDarkMode: isDarkMode,
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.verified, isDarkMode: isDarkMode),
              title: 'Show your profile is verified',
              isDarkMode: isDarkMode,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Not subscribed',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: isDarkMode ? Colors.white38 : Colors.black38,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),
            Divider(
              color: isDarkMode ? Colors.white12 : Colors.black12,
              thickness: 10,
            ),
            _sectionHeader(
              'Your orders and fundraisers',
              isDarkMode: isDarkMode,
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.history, isDarkMode: isDarkMode),
              title: 'Orders and payments',
              isDarkMode: isDarkMode,
            ),

            const SizedBox(height: 18),
            Divider(
              color: isDarkMode ? Colors.white12 : Colors.black12,
              thickness: 10,
            ),
            _sectionHeader('More info and support', isDarkMode: isDarkMode),
            _settingsRow(
              leading: _leadingIcon(Icons.help, isDarkMode: isDarkMode),
              title: 'Help',
              isDarkMode: isDarkMode,
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.privacy_tip, isDarkMode: isDarkMode),
              title: 'Privacy Center',
              isDarkMode: isDarkMode,
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.people, isDarkMode: isDarkMode),
              title: 'Account Status',
              isDarkMode: isDarkMode,
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.info, isDarkMode: isDarkMode),
              title: 'About',
              isDarkMode: isDarkMode,
            ),

            const SizedBox(height: 18),
            Divider(
              color: isDarkMode ? Colors.white12 : Colors.black12,
              thickness: 10,
            ),
            _sectionHeader('Login', isDarkMode: isDarkMode),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: _hp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Add account",
                    // Accent colors like this often work well in both themes
                    style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Log out",
                    // Destructive action colors also work well in both themes
                    style: TextStyle(color: Colors.redAccent, fontSize: 17),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Log out all accounts",
                    style: TextStyle(color: Colors.redAccent, fontSize: 17),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
