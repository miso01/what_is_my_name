import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:what_is_my_name/app/app_bloc.dart';
import 'package:what_is_my_name/menu/menu_event.dart';
import 'package:what_is_my_name/menu/menu_state.dart';
import 'package:what_is_my_name/repositories/name_repository.dart';
import 'package:what_is_my_name/repositories/shared_prefs_repository.dart';
import 'package:what_is_my_name/utils/strings.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {

  SharedPrefsRepository _sharedPrefsRepository = SharedPrefsRepository();
  NameRepository _nameRepository = NameRepository();
  AppBloc _appBloc;

  MenuBloc(MenuState initialState, this._appBloc) : super(initialState);

  @override
  Stream<MenuState> mapEventToState(MenuEvent event) async* {
    if (event is ChangePartnerEvent)
      yield ChangePartnerState();
    else if (event is ChooseGenderEvent)
      yield ChooseGenderState();
    else if (event is ResetAppEvent)
      yield* _mapResetAppEvent();
  }

  Stream<MenuState> _mapResetAppEvent() async* {
    yield ResetInProgressState(Strings.resetInProgressText);
    try {
      await _nameRepository.removeAllLikedNames();
      await _sharedPrefsRepository.saveDislikedNamesIds([]);
      await _sharedPrefsRepository.saveMatchedNamesIds([]);
      await _sharedPrefsRepository.savePairingCode("");
      await _sharedPrefsRepository.savePartnerUserId("");
      _appBloc.clearData();
      yield ResetSuccessState();
    } catch (e) {
      yield ResetFailureState(Strings.resetFailureText);
    }
  }
}
