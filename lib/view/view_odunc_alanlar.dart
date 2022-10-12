import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudfirestoreandmvvm/model/model_odunc.dart';
import 'package:cloudfirestoreandmvvm/view/view_yeni_odunc_ekle.dart';
import 'package:cloudfirestoreandmvvm/view_model/datetime_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/model_book.dart';

class OduncAlanlarView extends StatefulWidget {
  Book book;

  OduncAlanlarView({required this.book});

  @override
  State<OduncAlanlarView> createState() => _OduncAlanlarViewState();
}

class _OduncAlanlarViewState extends State<OduncAlanlarView> {
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ///Anasayfadan gelen listeyi bir degiskene aliyorum
    List<dynamic> gOduncAlanlarListesi = widget.book.oduncAlanlarListesi;

    ///Daha sonra burada ayiklama yapiyorum
    List<Odunc> oduncAlanlarListesi = gOduncAlanlarListesi.map((mapData) {
      Odunc odunc = Odunc.fromJson(mapData);
      return odunc;
    }).toList();

    return Scaffold(
        appBar: AppBar(
          title: Text(" ${widget.book.kitapIsmi}: Odunc Alanlar"),
        ),
        body: oduncAlanlarListesi.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                  "${widget.book.kitapIsmi} kitabini henuz kimse odunc almadi"),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                YeniOduncEkleView(
                                    book: widget.book))).then(onGoBack);
                  },
                  child: Text("Ilk Odunc Kaydi Olustur.")),
            ],
          ),
        )
            : Column(
          children: [
            Flexible(
              child: ListView.builder(
                  itemCount: oduncAlanlarListesi.length,
                  itemBuilder: (context, int index) {
                    Timestamp myTimeStamp =
                        oduncAlanlarListesi[index].oduncAlmaTarihi;
                    String oduncAlmaTarihi =
                    DateTimeHelper.toStringFromTimeStamp(
                        myTimeStamp);
                    return Card(
                      semanticContainer: true,
                      child: ListTile(
                        title: Text(
                            "Odunc Alan: ${oduncAlanlarListesi[index]
                                .isim} ${oduncAlanlarListesi[index].soyisim}"),
                        subtitle: Text(
                            "Odunc Alma Tarihi:${oduncAlmaTarihi}"),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              oduncAlanlarListesi[index].photoUrl),
                        ),
                      ),
                    );
                  }),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              YeniOduncEkleView(
                                book: widget.book,
                              ))).then(onGoBack);
                },
                child: Text("Yeni Odunc Ekle")),
          ],
        ));
  }
}
