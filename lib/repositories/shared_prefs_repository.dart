import 'package:shared_preferences/shared_preferences.dart';
import 'package:what_is_my_name/utils/constants.dart';

class SharedPrefsRepository {
  SharedPreferences prefs;

  Future<void> _init() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
  }

  Future<void> savePartnerUserId(String userId) async {
    await _init();
    await prefs.setString(Constants.partnerUserId, userId);
  }

  Future<String> getPartnerUserId() async {
    await _init();
    return prefs.getString(Constants.partnerUserId);
  }

  Future<void> savePairingCode(String code) async {
    await _init();
    await prefs.setString(Constants.pairingCode, code);
  }

  Future<String> getPairingCode() async {
    await _init();
    return prefs.getString(Constants.pairingCode);
  }

  Future<void> saveChosenGender(String gender) async {
    await _init();
    await prefs.setString(Constants.sexOfBaby, gender);
  }

  Future<String> getChosenGender() async {
    await _init();
    return prefs.getString(Constants.sexOfBaby);
  }

  Future<void> saveMatchedNamesIds(List<int> matchedNamesIds) async {
    await _init();
    List<String> matchedNamesIdsList =
        matchedNamesIds.map((i) => i.toString()).toList();
    await prefs.setStringList(Constants.matchedNameIds, matchedNamesIdsList);
  }

  Future<List<int>> getMatchedNamesIds() async {
    await _init();
    List<int> matchedNamesIds = List();
    final matchedNamesIdsStringList =
        prefs.getStringList(Constants.matchedNameIds);
    if (matchedNamesIdsStringList != null)
      matchedNamesIds =
          matchedNamesIdsStringList.map((i) => int.parse(i)).toList();
    return matchedNamesIds;
  }

  Future<void> saveDislikedNamesIds(List<int> dislikedNames) async {
    await _init();
    List<String> dislikedNamesStringList =
        dislikedNames.map((i) => i.toString()).toList();
    return prefs.setStringList(
        Constants.dislikedNamesListField, dislikedNamesStringList);
  }



  Future<List<int>> getDislikedNamesIds() async {
    await _init();
    List<int> dislikedNamesIds = List();
    final dislikedNamesStringList =
        prefs.getStringList(Constants.dislikedNamesListField);
    if (dislikedNamesStringList != null)
      dislikedNamesIds =
          dislikedNamesStringList.map((i) => int.parse(i)).toList();
    return dislikedNamesIds;
  }
}
