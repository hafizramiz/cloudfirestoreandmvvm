import 'package:cloud_firestore/cloud_firestore.dart';

// Burada bir yardimci servis olusturdum
class FireBaseFireStoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getBookStream(String collectionPath) {
    Stream<QuerySnapshot> stream =
        firestore.collection(collectionPath).snapshots();
    return stream;
  }

  //Add metodu
  void set(
      {required String collectionPath,
      required String documentPath,
      required Map<String, dynamic> mapData}) {
    firestore.collection(collectionPath).doc(documentPath).set(mapData);
  }

  //Delete metodu
  void delete(String collectionPath, String documentId) {
    firestore.collection(collectionPath).doc(documentId).delete();
  }

//Update metodu
  void update(
      String collectionPath, String documentId, Map<String, dynamic> mapData) {
    firestore.collection(collectionPath).doc(documentId).update(mapData);
  }
}
