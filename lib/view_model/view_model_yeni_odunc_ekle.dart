import 'dart:io';

import 'package:cloudfirestoreandmvvm/model/firebase_services.dart';
import 'package:cloudfirestoreandmvvm/model/model_odunc.dart';
import 'package:cloudfirestoreandmvvm/model/storage_services.dart';
import 'package:cloudfirestoreandmvvm/view_model/datetime_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class YeniOduncEkleViewModel extends ChangeNotifier {
  FireBaseFireStoreService firebaseServise = FireBaseFireStoreService();
  StorageServices storageServices=StorageServices();
  TextEditingController isimController = TextEditingController();
  TextEditingController soyisimController = TextEditingController();
TextEditingController oduncAlmaTarihiController=TextEditingController();
 String photoUrl="https://brighterwriting.com/wp-content/uploads/icon-user-default-420x420.png";
 late File image;

 ///File set islemini yapiyorum
  Future<void> setFile(PickedFile pickedImage) async{
      image= await File(pickedImage.path);
      image= image;
  }

 ///Burada photo yukluyorum
 Future<void>putFile(String photoRefPath)async {
   Reference photoRef=storageServices.connectToStorage("kitabiOduncAlanlar", photoRefPath);
     TaskSnapshot uploadTask=await photoRef.putFile(image);
     print("upload task ref yolu: ${uploadTask.ref}");
 }


 ///Burada cekilen Url bilgisini photoUrl degiskenine atadim
 Future<void> setPhotoUrlData(String photoRefPath) async{
   Reference photoRef=storageServices.connectToStorage("kitabiOduncAlanlar", photoRefPath);
   photoUrl=await photoRef.getDownloadURL();
   print("photo url si: ${photoUrl}");
 }

///--------------------------------------------------------
void setDateTime(DateTime? pickedDate){
  if(pickedDate!=null){
    oduncAlmaTarihiController.text=DateTimeHelper.toStringFromDateTime(pickedDate);
  }
}

  ///Metod: yeni kayit atmak icin
  void oduncUpdate(
      {required String id,
        required List oduncAlanlarListesi,
        required pickedDate}) {

    ///Contorllardan girilen veriler ile Yeni obje olusturdum
    Odunc odunc=Odunc(
        isimController.text,
        soyisimController.text,
        DateTimeHelper.toTimeStampFromDateTime(pickedDate),
        photoUrl
    );


    ///Objeyi map'e donusturdum
    Map<String,dynamic>mapData=odunc.toJson();
     ///Listeye ekledim
    oduncAlanlarListesi.add(mapData);
    ///YEni listeyi firebase'de update ettim
    firebaseServise
        .update("Kitaplar", id, {"oduncAlanlarListesi": oduncAlanlarListesi});
    notifyListeners();
  }
}
