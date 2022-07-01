import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:what_is_my_name/models/name.dart';
import 'package:what_is_my_name/repositories/auth_repository.dart';
import 'package:what_is_my_name/repositories/shared_prefs_repository.dart';
import 'package:what_is_my_name/utils/constants.dart';
import 'package:what_is_my_name/utils/exceptions.dart';
import 'package:what_is_my_name/utils/utils.dart';

class NameRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  NameRepository() {
    _firestore.settings = Settings(persistenceEnabled: false);
  }

  final AuthRepository _authRepository = AuthRepository();
  final SharedPrefsRepository _sharedPrefsRepository = SharedPrefsRepository();

  Future<Name> likeName(Name name) async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none)
      throw NoInternetConnectionException();

    final user = _authRepository.getUser();

    final usersLikedListRef =
        _firestore.collection(Constants.usersCollection).doc(user.uid);

    final namesRef = _firestore
        .collection(Constants.namesCollection + "_SK")
        .doc(Constants.namesDocument);

    final batch = _firestore.batch();

    /// update values in list or create list if does not exist
    batch.set(
        usersLikedListRef,
        {
          Constants.likedNamesListField: FieldValue.arrayUnion([name.id])
        },
        SetOptions(merge: true));

    /// remove liked name from the list
    batch.set(
        namesRef,
        {
          Constants.namesDocument: FieldValue.arrayRemove([name.toJson()])
        },
        SetOptions(merge: true));

    name.likes = name.likes + 1;
    name.rating = toThreeDecimals(name.likes / name.dislikes);

    /// add name to the list with updated likes count
    batch.set(
        namesRef,
        {
          Constants.namesDocument: FieldValue.arrayUnion([name.toJson()])
        },
        SetOptions(merge: true));

    await batch.commit();

    return name;
  }

  Future<Name> removeLikedName(Name name) async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none)
      throw NoInternetConnectionException();

    final user = _authRepository.getUser();

    final batch = _firestore.batch();

    /// update values in list or create list if does not exist
    batch.set(
        _firestore.collection(Constants.usersCollection).doc(user.uid),
        {
          Constants.likedNamesListField: FieldValue.arrayRemove([name.id])
        },
        SetOptions(merge: true));

    batch.set(
        _firestore
            .collection(Constants.namesCollection + "_SK")
            .doc(Constants.namesDocument),
        {
          Constants.namesDocument: FieldValue.arrayRemove([name.toJson()])
        },
        SetOptions(merge: true));

    name.likes = name.likes - 1;
    name.rating = toThreeDecimals(name.likes / name.dislikes);

    batch.set(
        _firestore
            .collection(Constants.namesCollection + "_SK")
            .doc(Constants.namesDocument),
        {
          Constants.namesDocument: FieldValue.arrayUnion([name.toJson()])
        },
        SetOptions(merge: true));

    await batch.commit();
    return name;
  }



  Future<Name> removeDislikedName(Name name) async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none)
      throw NoInternetConnectionException();

    final user = _authRepository.getUser();

    final batch = _firestore.batch();

    /// update values in list or create list if does not exist
    batch.set(
        _firestore.collection(Constants.usersCollection).doc(user.uid),
        {
          Constants.likedNamesListField: FieldValue.arrayRemove([name.id])
        },
        SetOptions(merge: true));

    batch.set(
        _firestore
            .collection(Constants.namesCollection + "_SK")
            .doc(Constants.namesDocument),
        {
          Constants.namesDocument: FieldValue.arrayRemove([name.toJson()])
        },
        SetOptions(merge: true));

    name.dislikes = name.dislikes - 1;
    name.rating = toThreeDecimals(name.likes / name.dislikes);

    batch.set(
        _firestore
            .collection(Constants.namesCollection + "_SK")
            .doc(Constants.namesDocument),
        {
          Constants.namesDocument: FieldValue.arrayUnion([name.toJson()])
        },
        SetOptions(merge: true));

    await batch.commit();
    return name;
  }

  Future<void> removeAllLikedNames() async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none)
      throw NoInternetConnectionException();

    final user = _authRepository.getUser();

    await _firestore
        .collection(Constants.usersCollection)
        .doc(user.uid)
        .delete();
  }

  /// disliked names are saved only in shared preferences,
  /// it can save up reads and writes in firebase database
  Future<void> dislikeName(Name name) async {
    if (await Connectivity().checkConnectivity() == ConnectivityResult.none)
      throw NoInternetConnectionException();

    List<int> dislikedNamesIds =
        await _sharedPrefsRepository.getDislikedNamesIds();
    dislikedNamesIds.add(name.id);

    await _sharedPrefsRepository.saveDislikedNamesIds(dislikedNamesIds);

    final batch = _firestore.batch();

    final namesRef = _firestore
        .collection(Constants.namesCollection + "_SK")
        .doc(Constants.namesDocument);

    /// remove disliked name from the list
    batch.set(
        namesRef,
        {
          Constants.namesDocument: FieldValue.arrayRemove([name.toJson()])
        },
        SetOptions(merge: true));

    name.dislikes = name.dislikes + 1;
    name.rating = toThreeDecimals(name.likes / name.dislikes);

    /// add name to the list with updated likes count
    batch.set(
        namesRef,
        {
          Constants.namesDocument: FieldValue.arrayUnion([name.toJson()])
        },
        SetOptions(merge: true));

    await batch.commit();
  }

  Future<List<Name>> getNames(String countryCode) async {
    if(await Connectivity().checkConnectivity() == ConnectivityResult.none)
      throw NoInternetConnectionException();

    List<Name> names = List();

    final docSnapshot = await _firestore
        .collection(Constants.namesCollection + "_" + countryCode)
        .doc(Constants.namesDocument)
        .get();

    docSnapshot
        .data()[Constants.namesDocument]
        .forEach((element) => names.add(Name.fromJson(element)));
    names.shuffle();
    names.sort(
        (Name first, Name second) => first.rating.compareTo(second.rating));
    names = names.reversed.toList();
    return names;
  }

  Future<List<int>> getMyLikedNamesIds() async {
    if(await Connectivity().checkConnectivity() == ConnectivityResult.none)
      throw NoInternetConnectionException();

    final user = _authRepository.getUser();
    List<int> likedNamesId;

    DocumentSnapshot data = await _firestore
        .collection(Constants.usersCollection)
        .doc(user.uid)
        .get();

    List<dynamic> likedNamesData;
    if (data.data() != null)
      likedNamesData = data.data()[Constants.likedNamesListField];
    if (likedNamesData == null)
      likedNamesId = List();
    else
      likedNamesId = likedNamesData.cast<int>();
    return likedNamesId;
  }

  Future<List<int>> getMyDislikedNamesIds() async =>
      await _sharedPrefsRepository.getDislikedNamesIds();

  Future<Stream<DocumentSnapshot>> listenForPartnerLikedNamesIds(
      String partnerUserId) async {
    return _firestore
        .collection(Constants.usersCollection)
        .doc(partnerUserId)
        .snapshots();
  }

//  Future<void> uploadNames(BuildContext context) async {
//
//    if(await Connectivity().checkConnectivity() == ConnectivityResult.none)
//      throw NoInternetConnectionException();
//
//    List<Map<String, dynamic>> names = new List();
//    String data =
//        await DefaultAssetBundle.of(context).loadString("assets/jan.json");
//    final jsonResult = json.decode(data);
//    jsonResult.forEach((ele) {
//      Name name = Name.fromJson(ele);
//      name.likes = 1;
//      name.dislikes = 1;
//      name.rating = toThreeDecimals(name.likes / name.dislikes);
//      names.add(name.toJson());
//    });
//
//
//    var gg = {"names": names};
//    await _firestore
//        .collection(Constants.namesCollection + "_SK")
//        .doc(Constants.namesDebugDocument)
//        .set(gg);
//  }
}
