import 'package:async_redux/async_redux.dart';
import 'package:arenaone/redux/app_state.dart';

final store = Store<AppState>(
  initialState: AppState.initialState(),
);
