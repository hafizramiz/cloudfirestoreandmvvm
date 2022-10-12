import 'dart:io';
import 'package:cloudfirestoreandmvvm/view_model/view_model_yeni_odunc_ekle.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../model/model_book.dart';

class YeniOduncEkleView extends StatelessWidget {
  Book book;
  DateTime pickedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  String photoRefPathID = DateTime.now().microsecondsSinceEpoch.toString();

  YeniOduncEkleView({required this.book});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<YeniOduncEkleViewModel>(
      create: (context) => YeniOduncEkleViewModel(),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          title: Text("Yeni Kayit Sayfasi"),
        ),
        body: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: Stack(
                      children: [
                        CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(
                                "https://brighterwriting.com/wp-content/uploads/icon-user-default-420x420.png")),
                        Positioned(
                            top: 60,
                            left: 50,
                            child: IconButton(
                                onPressed: () async {
                                  final ImagePicker _picker = ImagePicker();

                                  final PickedFile? pickedImage= await _picker.getImage(source: ImageSource.camera);

                                  print("pickedFile tipi: ${pickedImage}");

                                  ///Burada cektigim resmi dosyasini degiskene set ediyorum
                                  await Provider.of<YeniOduncEkleViewModel>(
                                      context,listen: false).setFile(pickedImage!);


                                  ///Burada once put file etmem gerek
                                  await Provider.of<YeniOduncEkleViewModel>(
                                          context,
                                          listen: false)
                                      .putFile(photoRefPathID);
                                  print(
                                      "Photo reference Id 1 gonderilen ${photoRefPathID}");

                                  ///Daha sonra resim urlsini cekip degiskene atamam gerekiyor
                                  await Provider.of<YeniOduncEkleViewModel>(
                                          context,
                                          listen: false)
                                      .setPhotoUrlData(photoRefPathID);

                                },
                                icon: Icon(
                                  Icons.camera_alt,
                                  size: 50,
                                  color: Colors.purple,
                                )))
                      ],
                    )),
                Flexible(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller:
                              Provider.of<YeniOduncEkleViewModel>(context)
                                  .isimController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Isim bos gecilemez";
                            }
                          },
                          decoration: InputDecoration(
                              suffixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                              hintText: "Isim"),
                        ),
                        TextFormField(
                          controller:
                              Provider.of<YeniOduncEkleViewModel>(context)
                                  .soyisimController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Soyisim bos gecilemez";
                            }
                          },
                          decoration: InputDecoration(
                              suffixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                              hintText: "Soy isim"),
                        ),
                        TextFormField(
                          onTap: () async {
                            pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2024)) as DateTime;
                            Provider.of<YeniOduncEkleViewModel>(context,
                                    listen: false)
                                .setDateTime(pickedDate);
                            print("secilen tarih: ${pickedDate}");
                          },
                          controller:
                              Provider.of<YeniOduncEkleViewModel>(context)
                                  .oduncAlmaTarihiController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Tarih bos gecilemez";
                            }
                          },
                          decoration: InputDecoration(
                              suffixIcon: Icon(Icons.calendar_today),
                              border: OutlineInputBorder(),
                              hintText: "Odunc Alma Tarihi"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ///Do something
                  Provider.of<YeniOduncEkleViewModel>(context, listen: false)
                      .oduncUpdate(
                          pickedDate: pickedDate,
                          id: book.kitapId,
                          oduncAlanlarListesi: book.oduncAlanlarListesi);
                  Navigator.pop(context);
                }
              },
              child: Text("Kaydet"),
            ),
          ],
        ),
      ),
    );
  }
}
