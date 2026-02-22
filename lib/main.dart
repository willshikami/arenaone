import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'core/app_store.dart';
import 'core/theme.dart';
import 'navigation/main_navigation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        theme: AppTheme.lightTheme,
        home: MainNavigation(), // Removed const
      ),
    );
  }
}
