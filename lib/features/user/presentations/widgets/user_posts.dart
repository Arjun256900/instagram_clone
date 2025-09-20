import 'package:flutter/material.dart';
import 'package:instagram/features/user/presentations/widgets/empty_user_posts.dart';

class UserPosts extends StatefulWidget {
  const UserPosts({super.key});

  @override
  State<UserPosts> createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(() {
      setState(() {});
      debugPrint("Switched to tab ${_tabController!.index}");
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DefaultTabController(
      // YOU CAN NOW DO _tabController.index to get the index of the tab (starts from 0 xD)
      length: 3,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: isDark ? Colors.white : Colors.black,
            // labelColor:
            //     isDark ? Colors.white : Colors.black, // selected icon or text
            tabs: [
              Tab(
                child: Image.asset(
                  isDark
                      ? _tabController!.index == 0
                          ? 'assets/grid_selected_dark.png'
                          : 'assets/grid_unselected_dark.png'
                      : _tabController!.index == 0
                      ? 'assets/grid_selected_light.png'
                      : 'assets/grid_unselected_light.png',
                  height: 64,
                  width: 64,
                ),
              ),
              Tab(
                child: Image.asset(
                  isDark
                      ? _tabController!.index == 1
                          ? 'assets/reels_selected_dark.png'
                          : 'assets/reels_unselected_dark.png'
                      : _tabController!.index == 1
                      ? 'assets/reels_selected_dark.png'
                      : 'assets/reels_unselected_dark.png',
                  height: 64,
                  width: 64,
                ),
              ),
              Tab(
                child: Image.asset(
                  isDark
                      ? _tabController!.index == 2
                          ? 'assets/tagged_selected_dark.png'
                          : 'assets/tagged_unselected_dark.png'
                      : _tabController!.index == 2
                      ? 'assets/tagged_selected_light.png'
                      : 'assets/tagged_unselected_light.png',
                  height: 74,
                  width: 74,
                ),
              ),
            ],
          ),

          // Constrain TabBarView’s height (must)
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Emptyuserposts(
                  message: "Capture the moment with a friend",
                  postType: "post",
                ),
                Emptyuserposts(
                  message: "Share a moment with the world",
                  postType: "reel",
                ),
                Emptyuserposts(
                  message: "Photos and videos of you",
                  postType: "tagged",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
