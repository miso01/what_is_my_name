import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:what_is_my_name/models/connection.dart';
import 'package:what_is_my_name/repositories/shared_prefs_repository.dart';
import 'package:what_is_my_name/utils/constants.dart';
import 'package:what_is_my_name/utils/exceptions.dart';

class PairingRepository {
  final SharedPrefsRepository _sharedPrefsRepository = SharedPrefsRepository();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> startPairing(String connectionCode, String userId) async {
    /// we are creating new connection with userId of creator and current date
    final connection = Connection(
        firstUserId: userId,
        dateCreated: DateTime.now().millisecondsSinceEpoch);

    await _firestore
        .collection(Constants.connectionsCollection)
        .doc(connectionCode)
        .set(connection.toJson());
  }

  Future<void> joinPairing(String connectionCode, String userId) async {
    DocumentSnapshot connectionSnapshot = await getConnection(connectionCode);
    if (connectionSnapshot.exists) {
      final connection = Connection.fromJson(connectionSnapshot.data());

      /// if second user is empty or null, it means that we can connect with first user
      if (connection.secondUserId == null || connection.secondUserId.isEmpty) {
        /// here we can set our user id as a second user id and then we can it write to the database
        connection.secondUserId = userId;

        await _firestore
            .collection(Constants.connectionsCollection)
            .doc(connectionCode)
            .set(connection.toJson());

        /// after that we can save id of our partner
        _sharedPrefsRepository.savePartnerUserId(connection.firstUserId);
      } else
        throw ConnectionIsActivelyUsedException();
    } else
      throw ConnectionDoesNotExistException();
  }

  Stream<DocumentSnapshot> listenForPartner(String connectionCode) {
    return _firestore
        .collection(Constants.connectionsCollection)
        .doc(connectionCode)
        .snapshots();
  }

  Future<DocumentSnapshot> getConnection(String connectionCode) async {
    DocumentSnapshot data = await _firestore
        .collection(Constants.connectionsCollection)
        .doc(connectionCode)
        .get();
    return data;
  }
}
