import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:what_is_my_name/app/app_event.dart';
import 'package:what_is_my_name/app/app_state.dart';
import 'package:what_is_my_name/models/advertisement.dart';
import 'package:what_is_my_name/models/connection.dart';
import 'package:what_is_my_name/models/name.dart';
import 'package:what_is_my_name/name/name_state.dart';
import 'package:what_is_my_name/repositories/name_repository.dart';
import 'package:what_is_my_name/repositories/pairing_repository.dart';
import 'package:what_is_my_name/repositories/shared_prefs_repository.dart';
import 'package:what_is_my_name/utils/constants.dart';
import 'package:what_is_my_name/utils/strings.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc(AppState initialState) : super(initialState);

  PairingRepository _connectionRepository = PairingRepository();
  SharedPrefsRepository _sharedPrefsRepository = SharedPrefsRepository();
  NameRepository _nameRepository = NameRepository();
  StreamSubscription<DocumentSnapshot> _partnerConnectionSubscription;
  StreamSubscription<ConnectivityResult> _internetConnectionSubscription;
  StreamSubscription<DocumentSnapshot> _partnerLikedNamesSubscription;

  List<Name> allNames = List();
  List<int> matchedNamesIds = List();
  List<Name> filteredNames = List();
  List<Name> unseenNames = List();
  List<int> dislikedNamesIds = List();
  List<int> likedNamesIds = List();
  List<int> partnerLikedNamesIds = List();
  List<Advertisement> advertisements;
  NameState previousSwipeState;

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is ListenForPartnerPairingEvent)
      yield* _mapListenForPartnerPairingEvent();
    else if (event is ListenForInternetConnectionChangesEvent)
      yield* _mapListenForConnectivityChangesEvent();
    else if (event is PartnerPairedEvent)
      yield PartnerPairedState();
    else if (event is InternetConnectionChangedEvent)
      yield* _mapConnectivityChangedEvent(event);
    else if (event is ListenForPartnerLikedNamesIdsEvent)
      yield* _mapListenPartnerLikedNamesIdsEvent();
    else if (event is MatchEvent) {
      matchedNamesIds.add(event.name.id);
      await _sharedPrefsRepository.saveMatchedNamesIds(matchedNamesIds);
      yield MatchState(event.name);
    }
  }

  Stream<AppState> _mapListenForPartnerPairingEvent() async* {
    String pairingCode = await _sharedPrefsRepository.getPairingCode();
    String partnerId = await _sharedPrefsRepository.getPartnerUserId();

    /// if pairing code and partner id is null or empty we can start listening for pairing
    if (pairingCode != null && pairingCode != "" && pairingCode != Constants.onlyMe) {
      if (partnerId == null || partnerId == "") {
          _partnerConnectionSubscription = _connectionRepository
              .listenForPartner(pairingCode)
              .listen((event) {
            if (event.exists) {
              final Connection connection = Connection.fromJson(event.data());

              /// when secondUserId is not null or empty it means that partner is successfully connected
              /// and we can save partner id to the shared prefs
              if (connection.secondUserId != null &&
                  connection.secondUserId != "") {
                _sharedPrefsRepository
                    .savePartnerUserId(connection.secondUserId);
                add(PartnerPairedEvent());
              }
            }
          });
      }
    }
  }

  Stream<AppState> _mapListenForConnectivityChangesEvent() async* {
    if (_internetConnectionSubscription == null)
      _internetConnectionSubscription = Connectivity()
          .onConnectivityChanged
          .listen((ConnectivityResult result) => add(InternetConnectionChangedEvent(result)));
  }

  Stream<AppState> _mapConnectivityChangedEvent(
      InternetConnectionChangedEvent event) async* {
    if (event.connectivityResult != ConnectivityResult.none) {
      final isConnectionAvailable = await DataConnectionChecker().hasConnection;
      if (isConnectionAvailable)
        yield InternetConnectionAvailableState();
      else
        yield InternetConnectionUnavailableState(
            Strings.internetConnectionProblemText);
    } else
      yield InternetConnectionUnavailableState(
          Strings.internetConnectionProblemText);
  }

  Stream<AppState> _mapListenPartnerLikedNamesIdsEvent() async* {
    final partnerUserId = await _sharedPrefsRepository.getPartnerUserId();
    if (partnerUserId != null && partnerUserId.isNotEmpty) {
      final stream = await _nameRepository.listenForPartnerLikedNamesIds(partnerUserId);
      _partnerLikedNamesSubscription = stream.listen((event) {
        if (event.exists && event.data != null) {
          final List<int> listIds = event.data()[Constants.likedNamesListField].cast<int>();
          partnerLikedNamesIds = listIds;
          partnerLikedNamesIds.forEach((partnerLikedNameId) {
            if(!matchedNamesIds.contains(partnerLikedNameId))
              checkForPartnerMatch(partnerLikedNameId, matchedNamesIds);
          });
        }
      });
    }
  }

  void checkForPartnerMatch(int partnerLikedNameId, List<int> matchedNamesIds){
    /// called when partner likes name
    if (likedNamesIds.contains(partnerLikedNameId)) {
      final name = filteredNames.firstWhere((element) => element.id == partnerLikedNameId, orElse: ()=> null);
      if(name != null)
        add(MatchEvent(name));
    }
  }

  void checkForMyMatch(int myLikedNameId, List<int> matchedNamesIds) {
    /// called when user like name
    if (partnerLikedNamesIds.contains(myLikedNameId)) {
      final name = filteredNames.firstWhere((element) => element.id == myLikedNameId, orElse: ()=> null);
      if(name != null)
        add(MatchEvent(name));
    }
  }

  void stopPartnerLikedNamesSubscription()async{
    await _partnerLikedNamesSubscription?.cancel();//TODO pozor na partner
    await _partnerConnectionSubscription?.cancel();
    partnerLikedNamesIds.clear();
  }

  void clearData() {
    allNames = List();
    filteredNames = List();
    unseenNames = List();
    dislikedNamesIds = List();
    likedNamesIds = List();
    partnerLikedNamesIds = List();
    advertisements = null;
    previousSwipeState = null;
  }

  @override
  Future<void> close() {
    _internetConnectionSubscription.cancel();
    _partnerConnectionSubscription.cancel();
    return super.close();
  }
}
