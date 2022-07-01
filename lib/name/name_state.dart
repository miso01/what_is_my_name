import 'package:what_is_my_name/models/advertisement.dart';

abstract class NameState {
  const NameState();
}

class NameInitialState extends NameState {}

class NamesFetchSuccessState extends NameState {}

class NamesFetchInProgressState extends NameState {
  final String message;

  const NamesFetchInProgressState(this.message);
}

class NamesLikedState extends NameState {}

class NamesDislikedState extends NameState {}

class RefreshedState extends NameState {}

class DeviceShakenState extends NameState {}

class ErrorState extends NameState {
  final String message;

  const ErrorState(this.message);
}

class ShowAdvertisementState extends NameState {
  final Advertisement advertisement;

  const ShowAdvertisementState(this.advertisement);
}

class OpenAdvertisementState extends NameState {
  final String webUrl;

  OpenAdvertisementState(this.webUrl);
}
