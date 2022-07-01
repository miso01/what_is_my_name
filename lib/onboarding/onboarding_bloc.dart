import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:what_is_my_name/onboarding/onboarding_event.dart';
import 'package:what_is_my_name/onboarding/onboarding_state.dart';
import 'package:what_is_my_name/repositories/auth_repository.dart';
import 'package:what_is_my_name/utils/strings.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc(OnboardingState initialState) : super(initialState);

  final AuthRepository _authRepository = AuthRepository();

  @override
  Stream<OnboardingState> mapEventToState(OnboardingEvent event) async* {
    if (event is SignInAnonymouslyEvent)
      yield* _mapSignInAnonymouslyEvent();
    else if (event is ShowNextPageEvent)
      yield ShowNextPageState();
    else if (event is ShowPreviousPageEvent)
      yield ShowPreviousPageState();
  }

  Stream<OnboardingState> _mapSignInAnonymouslyEvent() async* {
    yield AuthInProgressState(Strings.loginInProgressText);
    final isSignedIn =  _authRepository.isSignedIn();
    if (isSignedIn)
      yield AuthSuccessState();
    else {
      try {
        await _authRepository.signInAnonymously();
        yield AuthSuccessState();
      } catch (e) {
        yield AuthFailureState(Strings.loginFailedText);
      }
    }
  }
}
