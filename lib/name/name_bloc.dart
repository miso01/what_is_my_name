import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shake/shake.dart';
import 'package:what_is_my_name/app/app_bloc.dart';
import 'package:what_is_my_name/models/name.dart';
import 'package:what_is_my_name/name/name_event.dart';
import 'package:what_is_my_name/name/name_state.dart';
import 'package:what_is_my_name/repositories/advertisement_repository.dart';
import 'package:what_is_my_name/repositories/name_repository.dart';
import 'package:what_is_my_name/repositories/shared_prefs_repository.dart';
import 'package:what_is_my_name/utils/exceptions.dart';
import 'package:what_is_my_name/utils/sex_of_baby.dart';
import 'package:what_is_my_name/utils/strings.dart';

class NameBloc extends Bloc<NameEvent, NameState> {
  final AppBloc _appBloc;

  NameBloc(NameState initialState, this._appBloc) : super(initialState);

  NameRepository _nameRepository = NameRepository();
  SharedPrefsRepository _sharedPrefsRepository = SharedPrefsRepository();
  AdvertisementRepository _advertisementRepository = AdvertisementRepository();
  int _swipeCounter = 0;
  final int _advertisementSwipeCount = 50;

  @override
  Stream<NameState> mapEventToState(NameEvent event) async* {
    if (event is GetNamesEvent) {
      yield* _mapGetNamesEvent(event.countryCode, event.isGenderChanged);
    } else if (event is DislikeNameEvent) {
      yield* _mapNameDislikeEvent();
    } else if (event is LikeNameEvent) {
      yield* _mapNameLikeEvent();
    } else if (event is RefreshEvent) {
      yield* _mapRefreshedEvent();
    } else if (event is ListenForDeviceShakeEvent) {
      yield* _mapListenForDeviceShakeEvent();
    } else if (event is DeviceShakenEvent) {
      yield* _mapDeviceShakenEvent();
    } else if (event is OpenAdvertisementEvent) {
      yield OpenAdvertisementState(event.webUrl);
    }
  }

  Stream<NameState> _mapDeviceShakenEvent() async* {
      if (_appBloc.previousSwipeState is NamesLikedState) {
        /// remove name from liked list
        _appBloc.previousSwipeState = null;
        final lastLikedName = _appBloc.filteredNames.firstWhere((element) => element.id == _appBloc.likedNamesIds.last);
        _appBloc.likedNamesIds.removeLast();
        _appBloc.unseenNames.insert(0, lastLikedName);
        final updatedName = await _nameRepository.removeLikedName(lastLikedName);
        _appBloc.allNames.removeWhere((element) => element.id == updatedName.id);
        _appBloc.allNames.add(updatedName);
        _appBloc.filteredNames.removeWhere((element) => element.id == updatedName.id);
        _appBloc.filteredNames.add(updatedName);
      } else if (_appBloc.previousSwipeState is NamesDislikedState) {
        /// remove name from disliked list
        _appBloc.previousSwipeState = null;
        final lastDislikedName = _appBloc.allNames.singleWhere((element) => element.id == _appBloc.dislikedNamesIds.last);
        _appBloc.dislikedNamesIds.removeLast();
        _appBloc.unseenNames.insert(0, lastDislikedName);
        await _sharedPrefsRepository.saveDislikedNamesIds(_appBloc.dislikedNamesIds);
        final updatedName = await _nameRepository.removeDislikedName(lastDislikedName);
        _appBloc.allNames.removeWhere((element) => element.id == updatedName.id);
        _appBloc.allNames.add(updatedName);
        _appBloc.filteredNames.removeWhere((element) => element.id == updatedName.id);
        _appBloc.filteredNames.add(updatedName);
      }
      yield DeviceShakenState();
  }

  List<Name> getUnseenNames() {
    List<Name> unseenNames = new List();
    _appBloc.filteredNames.forEach((name) {
      if (!_appBloc.likedNamesIds.contains(name.id) &&
          !_appBloc.dislikedNamesIds.contains(name.id)) unseenNames.add(name);
    });
    return unseenNames;
  }

  Stream<NameState> _mapGetNamesEvent(
      String countryCode, bool isGenderChanged) async* {
    yield NamesFetchInProgressState(Strings.fetchNamesInProgressText);
    if (_appBloc.allNames.isNotEmpty && isGenderChanged) {
      final String gender = await _sharedPrefsRepository.getChosenGender();
      _appBloc.filteredNames.clear();
      if (gender == Gender.DO_NOT_KNOW)
        _appBloc.filteredNames.addAll(_appBloc.allNames);
      else
        _appBloc.allNames.forEach((name) {
          if (name.gender == gender) _appBloc.filteredNames.add(name);
        });
      _appBloc.unseenNames = getUnseenNames();
      yield NamesFetchSuccessState();
    } else if (_appBloc.allNames.isEmpty) {
      /// if names are empty or if user changed gender
      try {
        final names = await _nameRepository.getNames(countryCode);
        final dislikedNamesIds = await _nameRepository.getMyDislikedNamesIds();
        final likedNamesIds = await _nameRepository.getMyLikedNamesIds();
        final String gender = await _sharedPrefsRepository.getChosenGender();
        _appBloc.allNames = names;
        _appBloc.matchedNamesIds =
            await _sharedPrefsRepository.getMatchedNamesIds();
        _appBloc.filteredNames.clear();
        if (gender == Gender.DO_NOT_KNOW)
          _appBloc.filteredNames.addAll(names);
        else
          names.forEach((name) {
            if (name.gender == gender) _appBloc.filteredNames.add(name);
          });
        _appBloc.dislikedNamesIds = dislikedNamesIds;
        _appBloc.likedNamesIds = likedNamesIds;
        _appBloc.unseenNames = getUnseenNames();
        yield NamesFetchSuccessState();
      } catch (e) {
        String message;
        if (e is NoInternetConnectionException)
          message = Strings.internetConnectionProblemText;
        else
          message = Strings.getNamesFailureText;
        yield ErrorState(message);
      }
    } else
      yield NamesFetchSuccessState();
  }

  Stream<NameState> _mapListenForDeviceShakeEvent() async* {
    ShakeDetector detector = ShakeDetector.waitForStart(onPhoneShake: () {
      add(DeviceShakenEvent());
    });
    detector.startListening();
  }

  Stream<NameState> _mapNameLikeEvent() async* {
    try {
      final updatedName =
          await _nameRepository.likeName(_appBloc.unseenNames[0]);

      /// replace old name with updated likes, rating....
      _appBloc.allNames.removeWhere((element) => element.id == updatedName.id);
      _appBloc.allNames.add(updatedName);
      _appBloc.filteredNames
          .removeWhere((element) => element.id == updatedName.id);
      _appBloc.filteredNames.add(updatedName);
      final matchedNamesIds = await _sharedPrefsRepository.getMatchedNamesIds();
      _appBloc.likedNamesIds.add(_appBloc.unseenNames[0].id);
      _appBloc.checkForMyMatch(_appBloc.unseenNames[0].id, matchedNamesIds);
      _appBloc.unseenNames.removeAt(0);
      _appBloc.previousSwipeState = NamesLikedState();
      _swipeCounter++;
      yield NamesLikedState();
    } catch (e) {
      String message;
      if (e is NoInternetConnectionException)
        message = Strings.internetConnectionProblemText;
      else
        message = Strings.likeFailureText;
      yield ErrorState(message);
    }
  }

  Stream<NameState> _mapNameDislikeEvent() async* {
    try {
      await _nameRepository.dislikeName(_appBloc.unseenNames[0]);
      _appBloc.dislikedNamesIds.add(_appBloc.unseenNames[0].id);
      _appBloc.unseenNames.removeAt(0);
      _appBloc.previousSwipeState = NamesDislikedState();
      _swipeCounter++;
      yield NamesDislikedState();
    } catch (e) {
      String message;
      if (e is NoInternetConnectionException)
        message = Strings.internetConnectionProblemText;
      else
        message = Strings.generalErrorText;
      yield ErrorState(message);
    }
  }

  Stream<NameState> _mapRefreshedEvent() async* {
    if (_swipeCounter == _advertisementSwipeCount) {
      final _random = new Random();
      _swipeCounter = 0;
      if (_appBloc.advertisements == null) {
        _appBloc.advertisements =
            await _advertisementRepository.getAdvertisements();
        if (_appBloc.advertisements.isNotEmpty) {
          final ad = _appBloc
              .advertisements[_random.nextInt(_appBloc.advertisements.length)];
          yield ShowAdvertisementState(ad);
        } else
          yield RefreshedState();
      }
      final ad = _appBloc
          .advertisements[_random.nextInt(_appBloc.advertisements.length)];
      yield ShowAdvertisementState(ad);
    } else
      yield RefreshedState();
  }
}
