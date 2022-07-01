abstract class MenuState {
  const MenuState();
}

class MenuInitialState extends MenuState {}

class ChangePartnerState extends MenuState {}

class ChooseGenderState extends MenuState {}

class ResetSuccessState extends MenuState {}

class ResetFailureState extends MenuState {
  final String message;

  const ResetFailureState(this.message);
}

class ResetInProgressState extends MenuState {
  final String message;

  const ResetInProgressState(this.message);
}
