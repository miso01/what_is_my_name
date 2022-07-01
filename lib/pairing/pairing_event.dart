abstract class PairingEvent {
  const PairingEvent();
}

class StartPairingEvent extends PairingEvent {
  final String code;

  const StartPairingEvent(this.code);
}

class JoinPairingEvent extends PairingEvent {
  final String code;

  const JoinPairingEvent(this.code);
}

class SendCodeEvent extends PairingEvent {}

class GenerateCodeEvent extends PairingEvent {}
