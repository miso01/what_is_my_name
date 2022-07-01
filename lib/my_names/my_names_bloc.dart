import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:what_is_my_name/app/app_bloc.dart';
import 'package:what_is_my_name/models/name.dart';
import 'package:what_is_my_name/my_names/my_names_event.dart';
import 'package:what_is_my_name/repositories/name_repository.dart';

import 'my_names_state.dart';

class MyNamesBloc extends Bloc<MyNamesEvent, MyNamesState> {
  AppBloc _appBloc;

  MyNamesBloc(MyNamesState initialState, this._appBloc) : super(initialState);

  final NameRepository _nameRepository = NameRepository();
  final List<Name> likedNames = List();
  final List<Name> commonNames = List();

  @override
  Stream<MyNamesState> mapEventToState(MyNamesEvent event) async* {
    if (event is ShowMyLikedNamesEvent) {
      yield ShowMyLikedNamesState();
    } else if (event is ShowCommonNamesEvent)
      yield ShowCommonNamesState();
    else if (event is RemoveLikedNameEvent)
      yield* _mapRemoveLikedNameEvent(event);
  }

  Stream<MyNamesState> _mapRemoveLikedNameEvent(RemoveLikedNameEvent event) async* {
    await _nameRepository.removeLikedName(event.name);
    unlikeName(event.name);
  }

  void getMyLikedNames() {
    likedNames.clear();
    _appBloc.filteredNames.forEach((name) {
      if (_appBloc.likedNamesIds.contains(name.id)) likedNames.add(name);
    });
  }

  void getCommonNames() {
    List<int> commonNamesIds = List();
    _appBloc.partnerLikedNamesIds.forEach((partnerLikedNameId) {
      if (_appBloc.likedNamesIds.contains(partnerLikedNameId))
        commonNamesIds.add(partnerLikedNameId);
    });

    commonNames.clear();

    _appBloc.filteredNames.forEach((name) {
      if (commonNamesIds.contains(name.id)) commonNames.add(name);
    });
  }

  void unlikeName(Name name) {
    _appBloc.unseenNames.add(name);
    _appBloc.likedNamesIds.remove(name.id);
    likedNames.remove(name);
    commonNames.remove(name);
  }
}
