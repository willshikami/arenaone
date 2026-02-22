import 'package:async_redux/async_redux.dart';
import '../app_state.dart';

class SetCurrentTabIndexAction extends ReduxAction<AppState> {
  final int index;

  SetCurrentTabIndexAction(this.index);

  @override
  AppState? reduce() {
    return state.copyWith(currentTabIndex: index);
  }
}

class SetSelectedDateAction extends ReduxAction<AppState> {
  final DateTime date;

  SetSelectedDateAction(this.date);

  @override
  AppState? reduce() {
    return state.copyWith(selectedDate: date);
  }
}
