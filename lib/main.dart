import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'redux/store.dart';
import 'redux/actions/navigation_actions.dart';
import 'utils/app_theme.dart';
import 'presentation/home/pages/main_navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load preferences before showing the UI
  await store.dispatchAndWait(LoadUserPreferencesAction());
  
  runApp(const ArenaOneApp());
}

class ArenaOneApp extends StatelessWidget {
  const ArenaOneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        title: 'Arena One',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme, // Switched from lightTheme to darkTheme
        home: const MainNavigation(),
      ),
    );
  }
}
