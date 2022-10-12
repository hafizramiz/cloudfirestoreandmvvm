import 'package:flutter/material.dart';
import '../model/firebase_services.dart';
import '../model/model_book.dart';
import 'datetime_helper.dart';

class AddDeleteBookViewModel extends ChangeNotifier {
  FireBaseFireStoreService firebaseService = FireBaseFireStoreService();
  TextEditingController kitapIsmiController = TextEditingController();
  TextEditingController kitapYazariController = TextEditingController();
  TextEditingController kitapBasimYiliController = TextEditingController();

  void setFormatedDate(pickedDate) {
    if (pickedDate != null) {
      String formatedDate = DateTimeHelper.toStringFromDateTime(pickedDate);
      kitapBasimYiliController.text = formatedDate;
    }
  }

  //Method to add book
  void set(pickedDate) {
    List bosListe=[];
    Book book = Book(
      kitapId: DateTime.now().microsecondsSinceEpoch.toString(),
      kitapIsmi: kitapIsmiController.text,
      kitapYazari: kitapYazariController.text,
      kitapBasimYili: DateTimeHelper.toTimeStampFromDateTime(pickedDate),
      oduncAlanlarListesi: bosListe
    );

    Map<String, dynamic> mapData = book.toJson();
    firebaseService.set(collectionPath: "Kitaplar",
        mapData: mapData,
    documentPath: book.kitapId);
    notifyListeners();
  }
  }
