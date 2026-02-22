import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import '../../../redux/app_state.dart';
import 'home_page.dart';
import '../../../redux/actions/navigation_actions.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, vm) => Scaffold(
        backgroundColor: const Color(0xFF0D0D10), // Dark base
        body: IndexedStack(
          index: vm.currentTabIndex,
          children: const [
            HomeScreen(),
            PlaceholderScreen(title: 'Explore'),
            PlaceholderScreen(title: 'Scores'),
            PlaceholderScreen(title: 'Following'),
            PlaceholderScreen(title: 'Profile'),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: vm.currentTabIndex > 3 ? 0 : vm.currentTabIndex,
          onTap: vm.onTabTapped,
          backgroundColor: const Color(0xFF0D0D10),
          selectedItemColor: const Color(0xFFFF6A1A),
          unselectedItemColor: Colors.grey.shade600,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search_outlined), activeIcon: Icon(Icons.search), label: 'Explore'),
            BottomNavigationBarItem(icon: Icon(Icons.scoreboard_outlined), activeIcon: Icon(Icons.scoreboard), label: 'Scores'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), activeIcon: Icon(Icons.favorite), label: 'Following'),
          ],
        ),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D10),
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _Factory extends VmFactory<AppState, MainNavigation, _ViewModel> {
  _Factory(super.widget);

  @override
  _ViewModel fromStore() => _ViewModel(
        currentTabIndex: state.currentTabIndex,
        onTabTapped: (index) => dispatch(SetCurrentTabIndexAction(index)),
      );
}

class _ViewModel extends Vm {
  final int currentTabIndex;
  final ValueChanged<int> onTabTapped;

  _ViewModel({
    required this.currentTabIndex,
    required this.onTabTapped,
  }) : super(equals: [currentTabIndex]);
}
