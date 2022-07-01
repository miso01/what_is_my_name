abstract class PairingState {
  const PairingState();
}

class PairingInitialState extends PairingState {}

class SendCodeState extends PairingState {}

class PairingInProgressState extends PairingState {
  final String message;

  const PairingInProgressState(this.message);
}

class JoinPairingSuccessState extends PairingState {
  final String message;

  const JoinPairingSuccessState(this.message);
}

class StartPairingSuccessState extends PairingState {
  final String message;

  const StartPairingSuccessState(this.message);
}

class JoinPairingFailureState extends PairingState {
  final String message;

  const JoinPairingFailureState(this.message);
}

class StartConnectionFailureState extends PairingState {
  final String message;

  const StartConnectionFailureState(this.message);
}

class CodeGeneratedState extends PairingState {
  final String code;

  const CodeGeneratedState(this.code);
}

class CodeGenerationInProgress extends PairingState {
  final String message;

  const CodeGenerationInProgress(this.message);
}
