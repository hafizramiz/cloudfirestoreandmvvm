import 'package:cloudfirestoreandmvvm/view_model/datetime_helper.dart';
import 'package:flutter/material.dart';
import '../model/firebase_services.dart';
import '../model/model_book.dart';

class UpdateBookViewModel extends ChangeNotifier{
  FireBaseFireStoreService firebaseService = FireBaseFireStoreService();
  TextEditingController kitapIsmiController=TextEditingController();
  TextEditingController kitapYazariController=TextEditingController();
  TextEditingController kitapBasimYiliController=TextEditingController();

  void setInitialData(Book book){
    kitapIsmiController.text=book.kitapIsmi;
    kitapYazariController.text=book.kitapYazari;
    kitapBasimYiliController.text=DateTimeHelper.toStringFromTimeStamp(book.kitapBasimYili);
  }

 void setPickedDate(DateTime pickedDate){
    kitapBasimYiliController.text=DateTimeHelper.toStringFromDateTime(pickedDate);
  }

//Method to update book
  void update(String id,DateTime pickedDate) {
    firebaseService.update("Kitaplar", id, {
      "kitapIsmi": kitapIsmiController.text,
      "kitapYazari": kitapYazariController.text,
      "kitapBasimYili":DateTimeHelper.toTimeStampFromDateTime(pickedDate)
    });
  }
}