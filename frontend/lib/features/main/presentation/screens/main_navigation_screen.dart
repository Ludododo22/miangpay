import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../cards/presentation/screens/cards_screen.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';
import '../../../history/presentation/screens/history_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../transfer/presentation/screens/transfer_type_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _index = 0;

  final _screens = const [
    DashboardScreen(showBottomNav: false),
    TransferTypeScreen(),
    CardsScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.secondary.withValues(alpha: .14),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Accueil'),
          NavigationDestination(icon: Icon(Icons.swap_horiz_outlined), selectedIcon: Icon(Icons.swap_horiz_rounded), label: 'Transfert'),
          NavigationDestination(icon: Icon(Icons.credit_card_outlined), selectedIcon: Icon(Icons.credit_card_rounded), label: 'Cartes'),
          NavigationDestination(icon: Icon(Icons.history_outlined), selectedIcon: Icon(Icons.history_rounded), label: 'Activités'),
          NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Profil'),
        ],
      ),
    );
  }
}
