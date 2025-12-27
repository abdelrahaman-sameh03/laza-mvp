import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../favorites/ui/favorites_page.dart';
import '../../cart/ui/cart_page.dart';
import '../../profile/ui/profile_page.dart';
import 'home_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _pages = const [
    HomePage(),
    FavoritesPage(),
    CartPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        indicatorColor: AppColors.primary.withOpacity(0.15),
        destinations: [
          NavigationDestination(
            icon: Semantics(label: 'tab_home', child: Icon(Icons.home_outlined)),
            selectedIcon: Semantics(label: 'tab_home', child: Icon(Icons.home)),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Semantics(label: 'tab_favorites', child: Icon(Icons.favorite_border)),
            selectedIcon: Semantics(label: 'tab_favorites', child: Icon(Icons.favorite)),
            label: 'Fav',
          ),
          NavigationDestination(
            icon: Semantics(label: 'open_cart_btn', child: Icon(Icons.shopping_bag_outlined)),
            selectedIcon: Semantics(label: 'open_cart_btn', child: Icon(Icons.shopping_bag)),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Semantics(label: 'tab_profile', child: Icon(Icons.person_outline)),
            selectedIcon: Semantics(label: 'tab_profile', child: Icon(Icons.person)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
