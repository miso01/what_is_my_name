import 'package:connectivity/connectivity.dart';
import 'package:what_is_my_name/models/name.dart';

abstract class AppEvent {
  const AppEvent();
}

class ListenForPartnerPairingEvent extends AppEvent {}

class PartnerPairedEvent extends AppEvent {}

class ListenForInternetConnectionChangesEvent extends AppEvent {}

class InternetConnectionChangedEvent extends AppEvent {
  final ConnectivityResult connectivityResult;

  const InternetConnectionChangedEvent(this.connectivityResult);
}

class ListenForPartnerLikedNamesIdsEvent extends AppEvent {}

class MatchEvent extends AppEvent {
  final Name name;

  const MatchEvent(this.name);
}
