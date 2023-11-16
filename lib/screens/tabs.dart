import 'package:flutter/material.dart';
import 'package:muzic/providers/favorites_provider.dart';
import 'package:muzic/screens/favorites.dart';
import 'package:muzic/screens/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Tabs extends ConsumerStatefulWidget {
  const Tabs({super.key});

  @override
  ConsumerState<Tabs> createState() => _TabsState();
}

class _TabsState extends ConsumerState<Tabs> {
  int currentPageIndex = 0;

  void selectPage(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const HomeScreen();
    String currentTitle = 'Yours Songs';
    if (currentPageIndex == 1) {
      activePage = Favorites(favoriteSongs: ref.watch(favoriteSongsProvider));
      currentTitle = 'Your Favorites';
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          currentTitle,
          style: const TextStyle(color: Colors.white),
        ),
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[900],
      body: activePage,
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.black26,
        indicatorColor: Colors.grey[900],
        surfaceTintColor: Colors.black,
        onDestinationSelected: selectPage,
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.folder_rounded,
              color: Colors.white,
            ),
            label: 'Files',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.favorite_rounded,
              color: Colors.white,
            ),
            label: 'Favorites',
          ),
        ],
        selectedIndex: currentPageIndex,
      ),
    );
  }
}
