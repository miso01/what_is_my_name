abstract class NameEvent {
  const NameEvent();
}

class GetNamesEvent extends NameEvent {
  final String countryCode;
  final bool isGenderChanged;

  const GetNamesEvent({this.countryCode, this.isGenderChanged});
}

class DislikeNameEvent extends NameEvent {}

class LikeNameEvent extends NameEvent {}

class RefreshEvent extends NameEvent {}

class ListenForDeviceShakeEvent extends NameEvent {}

class DeviceShakenEvent extends NameEvent {}

class ShowAdvertisementEvent extends NameEvent{}

class OpenAdvertisementEvent extends NameEvent{
  final String webUrl;

  const OpenAdvertisementEvent(this.webUrl);
}
