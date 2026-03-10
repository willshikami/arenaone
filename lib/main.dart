import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:arenaone/redux/store.dart';
import 'package:arenaone/redux/actions/navigation_actions.dart';
import 'package:arenaone/utils/app_theme.dart';
import 'package:arenaone/presentation/home/pages/main_navigation.dart';
import 'package:arenaone/data/services/supabase_config.dart';
import 'package:arenaone/data/services/live_activity_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  try {
    await SupabaseConfig.initialize();
    debugPrint('✅ Supabase initialized successfully');
  } catch (e) {
    debugPrint('❌ Supabase initialization failed: $e');
  }

  // Initialize Live Activity Service
  await LiveActivityService().init();
  
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
