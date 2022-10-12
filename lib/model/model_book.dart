import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final String kitapId;
  final String kitapIsmi;
  final String kitapYazari;
  final Timestamp kitapBasimYili;
  final List oduncAlanlarListesi;

  Book(
      {required this.kitapId,
      required this.kitapIsmi,
      required this.kitapYazari,
      required this.kitapBasimYili,
      required this.oduncAlanlarListesi});

//Method to change Json
  Map<String, dynamic> toJson() {
    return {
      "kitapIsmi": kitapIsmi,
      "kitapYazari": kitapYazari,
      "kitapBasimYili": kitapBasimYili,
      "kitapId": kitapId,
      "oduncAlanlarListesi": oduncAlanlarListesi
    };
  }

  //Constructor to change from Json
  Book.fromJson(Map<String, dynamic> json)
      : this.kitapId = json["kitapId"],
        this.kitapIsmi = json["kitapIsmi"],
        this.kitapYazari = json["kitapYazari"],
        this.kitapBasimYili = json["kitapBasimYili"],
        this.oduncAlanlarListesi  = json["oduncAlanlarListesi"];
}
