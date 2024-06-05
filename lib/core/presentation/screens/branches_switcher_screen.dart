import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BranchesSwitcherScreen extends StatelessWidget {
  const BranchesSwitcherScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        showUnselectedLabels: true,
        
        items: generateNavigationBarItems(context),
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> generateNavigationBarItems(
          BuildContext context) =>
      [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
            color: Theme.of(context).colorScheme.secondary,
          ),
          activeIcon: Icon(
            Icons.home,
            color: Theme.of(context).colorScheme.primary,
          ),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.secondary,
          ),
          activeIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.primary,
          ),
          label: "Search",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.bookmark_border,
            color: Theme.of(context).colorScheme.secondary,
          ),
          activeIcon: Icon(
            Icons.bookmark,
            color: Theme.of(context).colorScheme.primary,
          ),
          label: "Watchlist",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outlined,
            color: Theme.of(context).colorScheme.secondary,
          ),
          activeIcon: Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.primary,
          ),
          label: "Account",
        ),
      ];
}
