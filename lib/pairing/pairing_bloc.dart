import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:what_is_my_name/pairing/pairing_event.dart';
import 'package:what_is_my_name/repositories/auth_repository.dart';
import 'package:what_is_my_name/repositories/pairing_repository.dart';
import 'package:what_is_my_name/repositories/shared_prefs_repository.dart';
import 'package:what_is_my_name/utils/exceptions.dart';
import 'package:what_is_my_name/utils/strings.dart';
import 'package:what_is_my_name/utils/utils.dart';
import 'pairing_state.dart';

class PairingBloc extends Bloc<PairingEvent,PairingState> {
  final PairingRepository _connectionRepository = PairingRepository();
  final AuthRepository _authRepository = AuthRepository();
  final SharedPrefsRepository _sharedPrefsRepository = SharedPrefsRepository();

  PairingBloc(PairingState initialState) : super(initialState);

  @override
  Stream<PairingState> mapEventToState(PairingEvent event) async* {
    if (event is StartPairingEvent)
      yield* _mapStartPairingEvent(event);
    else if (event is JoinPairingEvent)
      yield* _mapJoinPairingEvent(event);
    else if (event is SendCodeEvent)
      yield SendCodeState();
    else if (event is GenerateCodeEvent) yield* _mapGenerateCodeEvent();
  }

  Stream<PairingState> _mapGenerateCodeEvent() async* {
    yield CodeGenerationInProgress(Strings.generatingCodeText);
    DocumentSnapshot connectionSnapshot;
    String code;
    do {
      code = generate6DigitsNumber().toString();
      connectionSnapshot = await _connectionRepository.getConnection(code);
    } while (connectionSnapshot.exists);
    yield CodeGeneratedState(code);
  }

  Stream<PairingState> _mapJoinPairingEvent( JoinPairingEvent event) async* {
    try {
      yield PairingInProgressState(Strings.joinPairingInProgressText);
      final user =  _authRepository.getUser();
      await _connectionRepository.joinPairing(event.code, user.uid);
      await _sharedPrefsRepository.savePairingCode(event.code);
      yield JoinPairingSuccessState(Strings.bothPartnersConnectedText);
    } catch (e) {
      String message;
      if (e is ConnectionDoesNotExistException)
        message = Strings.codeDoesNotExistsText;
      else if (e is ConnectionIsActivelyUsedException)
        message = Strings.codeOccupiedText;
      else
        message = Strings.connectionUnsuccessfulText;
      yield JoinPairingFailureState(message);
    }
  }

  Stream<PairingState> _mapStartPairingEvent(
      StartPairingEvent event) async* {
    try {
      yield PairingInProgressState(Strings.startPairingInProgressText);
      final user = _authRepository.getUser();
      await _connectionRepository.startPairing(event.code, user.uid);
      await _sharedPrefsRepository.savePairingCode(event.code);
      yield StartPairingSuccessState(Strings.successfullyConnectedText);
    } catch (e) {
      yield StartConnectionFailureState(Strings.connectionUnsuccessfulText);
    }
  }
}
