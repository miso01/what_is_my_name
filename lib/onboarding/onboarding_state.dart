abstract class OnboardingState {
  const OnboardingState();
}

class OnboardingInitialState extends OnboardingState {}

class AuthInProgressState extends OnboardingState {
  final message;

  const AuthInProgressState(this.message);
}

class AuthSuccessState extends OnboardingState {}

class AuthFailureState extends OnboardingState {
  final message;

  const AuthFailureState(this.message);
}

class ShowNextPageState extends OnboardingState {}

class ShowPreviousPageState extends OnboardingState {}
