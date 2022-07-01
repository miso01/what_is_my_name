import 'package:what_is_my_name/models/name.dart';

abstract class AppState {
  const AppState();
}

class AppInitialState extends AppState {}

class PartnerPairedState extends AppState {}

class InternetConnectionUnavailableState extends AppState {
  final String message;

  const InternetConnectionUnavailableState(this.message);
}

class InternetConnectionAvailableState extends AppState {}

class MatchState extends AppState {
  final Name name;

  const MatchState(this.name);
}