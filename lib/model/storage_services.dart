import 'package:firebase_storage/firebase_storage.dart';
class StorageServices{
  Reference connectToStorage(String storageRefPath,String photoRefPath){
    final storageRef=FirebaseStorage.instance.ref(storageRefPath);
    final photoRef=storageRef.child(photoRefPath);
    return photoRef;
  }
}