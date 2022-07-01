import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:what_is_my_name/models/advertisement.dart';
import 'package:what_is_my_name/utils/constants.dart';

class AdvertisementRepository {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Advertisement>> getAdvertisements() async {
    List<Advertisement> advertisements = List();
    final documentSnapshot = await _firestore
        .collection(Constants.advertisementsCollection)
        .doc(Constants.advertisementsListDocument)
        .get();
    final List<dynamic> ads = documentSnapshot.data()[Constants.advertisementsListField];
    ads.forEach((ad) {
      advertisements.add(Advertisement.fromJson(ad));
    });
    return advertisements;
  }
}
