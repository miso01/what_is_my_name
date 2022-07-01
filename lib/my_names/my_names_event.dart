import 'package:what_is_my_name/models/name.dart';

abstract class MyNamesEvent {
  const MyNamesEvent();
}

class ShowMyLikedNamesEvent extends MyNamesEvent {}

class ShowCommonNamesEvent extends MyNamesEvent {}

class RemoveLikedNameEvent extends MyNamesEvent {
  final Name name;

  const RemoveLikedNameEvent(this.name);
}
