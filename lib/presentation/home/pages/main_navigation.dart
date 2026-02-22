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
        backgroundColor: Colors.white,
        body: HomeScreen(), // Removed const
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: vm.currentTabIndex,
          onTap: vm.onTabTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search_outlined), activeIcon: Icon(Icons.search), label: 'Explore'),
            BottomNavigationBarItem(icon: Icon(Icons.scoreboard_outlined), activeIcon: Icon(Icons.scoreboard), label: 'Scores'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), activeIcon: Icon(Icons.favorite), label: 'Following'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
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
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
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
