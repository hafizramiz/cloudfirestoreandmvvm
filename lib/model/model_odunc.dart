import 'package:cloud_firestore/cloud_firestore.dart';

class Odunc {
  final String isim;
  final String soyisim;
  final Timestamp oduncAlmaTarihi;
  final String photoUrl;

  Odunc(this.isim, this.soyisim, this.oduncAlmaTarihi, this.photoUrl);

  ///Method convert to Json
  Map<String, dynamic> toJson() {
    return {
      "isim": this.isim,
      "soyisim": this.soyisim,
      "oduncAlmaTarihi": this.oduncAlmaTarihi,
      "photoUrl": this.photoUrl
    };
  }

  ///Constructor convert Json to object
  Odunc.fromJson(Map<String, dynamic> json)
      : this.isim = json["isim"],
        this.soyisim = json["soyisim"],
        this.oduncAlmaTarihi = json["oduncAlmaTarihi"],
        this.photoUrl = json["photoUrl"];
}
