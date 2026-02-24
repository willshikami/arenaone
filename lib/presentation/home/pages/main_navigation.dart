import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import '../../../redux/app_state.dart';
import 'home_page.dart';
import '../../auth/pages/sport_selection_page.dart';
import '../../../redux/actions/navigation_actions.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, vm) {
        if (!vm.isOnboardingCompleted) {
          return const SportSelectionPage();
        }

        return Scaffold(
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
            selectedFontSize: 11,
            unselectedFontSize: 11,
            items: const [
              BottomNavigationBarItem(
                icon: SFIcon(SFIcons.sf_house, fontSize: 24),
                activeIcon: SFIcon(SFIcons.sf_house_fill, fontSize: 24),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SFIcon(SFIcons.sf_magnifyingglass, fontSize: 24),
                activeIcon: SFIcon(SFIcons.sf_magnifyingglass, fontSize: 24, fontWeight: FontWeight.bold),
                label: 'Explore',
              ),
              BottomNavigationBarItem(
                icon: SFIcon(SFIcons.sf_sportscourt, fontSize: 24),
                activeIcon: SFIcon(SFIcons.sf_sportscourt_fill, fontSize: 24),
                label: 'Scores',
              ),
              BottomNavigationBarItem(
                icon: SFIcon(SFIcons.sf_star, fontSize: 24),
                activeIcon: SFIcon(SFIcons.sf_star_fill, fontSize: 24),
                label: 'Following',
              ),
            ],
          ),
        );
      },
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
        isOnboardingCompleted: state.isOnboardingCompleted,
        onTabTapped: (index) => dispatch(SetCurrentTabIndexAction(index)),
      );
}

class _ViewModel extends Vm {
  final int currentTabIndex;
  final bool isOnboardingCompleted;
  final ValueChanged<int> onTabTapped;

  _ViewModel({
    required this.currentTabIndex,
    required this.isOnboardingCompleted,
    required this.onTabTapped,
  }) : super(equals: [currentTabIndex, isOnboardingCompleted]);
}
