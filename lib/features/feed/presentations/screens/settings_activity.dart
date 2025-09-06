import 'package:flutter/material.dart';

void main() => runApp(const InstaSettingsDemo());

class InstaSettingsDemo extends StatelessWidget {
  const InstaSettingsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instaclone Settings UI',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0D0E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B0D0E),
          elevation: 0,
          centerTitle: false,
        ),
      ),
      home: const SettingsActivity(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SettingsActivity extends StatelessWidget {
  const SettingsActivity({super.key});

  // change this single value to control horizontal padding for the entire page
  static const double _hp = 6.0;

  // helper to create the leading icon container (outlined rounded square)
  Widget _leadingIcon(IconData icon) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Center(child: Icon(icon, size: 22, color: Colors.white)),
    );
  }

  Widget _sectionHeader(String text) {
    return Padding(
      // uses _hp so section headers align with list tiles and search field
      padding: const EdgeInsets.fromLTRB(_hp, 18, _hp, 10),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
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
  }) {
    return Column(
      children: [
        ListTile(
          // unified content padding
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          leading: leading,
          title: Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
          ),
          subtitle:
              subtitle != null
                  ? Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                  )
                  : null,
          trailing:
              trailing ??
              const Icon(Icons.chevron_right, color: Colors.white38),
          onTap: onTap ?? () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 28),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          title: const Text(
            'Settings and activity',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          toolbarHeight: 78,
        ),
        body: ListView(
          // single point of control for page padding
          padding: const EdgeInsets.symmetric(horizontal: _hp, vertical: 8),
          children: [
            // Search field (aligned with page padding)
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(
                  Icons.search,
                  size: 20,
                  color: Colors.white54,
                ),
                filled: true,
                fillColor: Colors.white10,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),

            // Your account section: title + account center block
            const SizedBox(height: 18),
            const Text(
              'Your account',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),

            // Accounts center (kept layout but aligned using _hp)
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
                      color: Colors.white10,
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      size: 26,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text(
                    'Accounts Center',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Password, security, personal details, ad preferences',
                    style: TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.chevron_right, color: Colors.white38),
                    ],
                  ),
                  onTap: () {},
                ),
                Padding(
                  // uses _hp so the 'Manage your connected...' aligns with other rows
                  padding: const EdgeInsets.fromLTRB(_hp, 6, _hp, 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Manage your connected experiences and account settings across Meta technologies. ',
                          style: TextStyle(color: Colors.white60, fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Learn more',
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
            const Divider(color: Colors.white12, thickness: 10),

            // Section: How you use Instagram
            _sectionHeader('How you use Instagram'),
            _settingsRow(
              leading: _leadingIcon(Icons.bookmark_border),
              title: 'Saved',
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.archive_outlined),
              title: 'Archive',
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.query_stats_outlined),
              title: 'Your activity',
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.notifications_none),
              title: 'Notifications',
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.access_time),
              title: 'Time management',
            ),

            const SizedBox(height: 18),
            const Divider(color: Colors.white12, thickness: 10),
            _sectionHeader('Who can see your content'),
            _settingsRow(
              leading: _leadingIcon(Icons.lock_outline),
              title: 'Account privacy',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Public',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.chevron_right, color: Colors.white38),
                ],
              ),
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.star_border),
              title: 'Close Friends',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    '0',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.chevron_right, color: Colors.white38),
                ],
              ),
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.access_time),
              title: 'Cross posting',
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.block),
              title: 'Blocked',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    '0',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.chevron_right, color: Colors.white38),
                ],
              ),
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.highlight_remove_rounded),
              title: 'Hide Stories',
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.people_outline),
              title: 'Activity in friends tab',
            ),
            const SizedBox(height: 18),
            const Divider(color: Colors.white12, thickness: 10),
            _sectionHeader('How other can interact with you'),
            _settingsRow(
              leading: _leadingIcon(Icons.message),
              title: 'Messages and story replies',
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.tag),
              title: 'Tags and mentions',
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.comment),
              title: 'Comments',
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.share),
              title: 'Sharing and reuse',
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.block),
              title: 'Restricted',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    '0',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.chevron_right, color: Colors.white38),
                ],
              ),
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.dangerous_rounded),
              title: 'Limit interaction',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Off',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.chevron_right, color: Colors.white38),
                ],
              ),
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.abc_sharp),
              title: 'Hidden words',
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.people_outline_sharp),
              title: 'Follow and invite friends',
            ),
            const SizedBox(height: 18),
            const Divider(color: Colors.white12, thickness: 10),
            _sectionHeader('What you see'),
            _settingsRow(
              leading: _leadingIcon(Icons.star_border),
              title: 'Favorites',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    '0',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.chevron_right, color: Colors.white38),
                ],
              ),
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.notifications_off_outlined),
              title: 'Muted accounts',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    '0',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.chevron_right, color: Colors.white38),
                ],
              ),
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.video_camera_back_outlined),
              title: 'Content preferences',
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.favorite_outlined),
              title: 'Like and share counts',
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.subscriptions),
              title: 'Subscriptions',
            ),
            const SizedBox(height: 18),
            const Divider(color: Colors.white12, thickness: 10),
            _sectionHeader('Your app and media'),
            _settingsRow(
              leading: _leadingIcon(Icons.phone_android),
              title: 'Device permissions',
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.download),
              title: 'Archiving and downloading',
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.accessibility),
              title: 'Accessibility',
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.language),
              title: 'Language and translations',
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.signal_cellular_4_bar_outlined),
              title: 'Data usage and media quality',
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.computer),
              title: 'App website permissions',
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.earbuds),
              title: 'Eearly access to features',
            ),
            const SizedBox(height: 18),
            const Divider(color: Colors.white12, thickness: 10),
            _sectionHeader('For Families'),
            _settingsRow(
              leading: _leadingIcon(Icons.house_outlined),
              title: 'Family center',
            ),
            const SizedBox(height: 18),
            const Divider(color: Colors.white12, thickness: 10),
            _sectionHeader('For professionals'),
            _settingsRow(
              leading: _leadingIcon(Icons.people_alt),
              title: 'Creater tools and insights',
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.analytics),
              title: 'Account type and tools',
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.verified),
              title: 'Show your profile is verified',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Not subscribed',
                    style: TextStyle(color: Colors.white70, fontSize: 15),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.chevron_right, color: Colors.white38),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Divider(color: Colors.white12, thickness: 10),
            _sectionHeader('Your orders and fundraisers'),
            _settingsRow(
              leading: _leadingIcon(Icons.history),
              title: 'Orders and payments',
            ),
            const SizedBox(height: 18),
            const Divider(color: Colors.white12, thickness: 10),
            _sectionHeader('More info and support'),
            _settingsRow(leading: _leadingIcon(Icons.help), title: 'Help'),
            _settingsRow(
              leading: _leadingIcon(Icons.privacy_tip),
              title: 'Privacy Center',
            ),
            _settingsRow(
              leading: _leadingIcon(Icons.people),
              title: 'Account Status',
            ),
            _settingsRow(leading: _leadingIcon(Icons.info), title: 'About'),
            const SizedBox(height: 18),
            const Divider(color: Colors.white12, thickness: 10),
            _sectionHeader('Login'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: _hp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add account",
                    style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Log out",
                    style: TextStyle(color: Colors.redAccent, fontSize: 17),
                  ),
                  const SizedBox(height: 10),
                  Text(
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
