import 'package:cloudfirestoreandmvvm/view_model/datetime_helper.dart';
import 'package:cloudfirestoreandmvvm/view_model/view_model_add_book.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBookView extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddDeleteBookViewModel>(
      create: (context) => AddDeleteBookViewModel(),
      builder: (BuildContext context, child) {
        DateTime? pickedDate;
        return Scaffold(
            appBar: AppBar(
              title: Text("Kitap Ekleme Sayfasi"),
            ),
            body: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Kitap ismi bos olamaz";
                      } else {
                        return null;
                      }
                    },
                    controller: Provider.of<AddDeleteBookViewModel>(context)
                        .kitapIsmiController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.book),
                        border: OutlineInputBorder(),
                        hintText: "Kitap ismi"),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Yazar ismi bos olamaz";
                      } else {
                        return null;
                      }
                    },
                    controller: Provider.of<AddDeleteBookViewModel>(context)
                        .kitapYazariController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.edit_off_rounded),
                        border: OutlineInputBorder(),
                        hintText: "Kitap Yazari"),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Lutfen tarih secin";
                      } else {
                        return null;
                      }
                    },
                    onTap: () async {
                      ///Zaman secimi yapma islemi
                       pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      ) as DateTime;
                        Provider.of<AddDeleteBookViewModel>(context,listen: false).setFormatedDate(pickedDate);
                    },
                    controller: Provider.of<AddDeleteBookViewModel>(context,listen: false).kitapBasimYiliController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                        hintText: "Tarih girin"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Provider.of<AddDeleteBookViewModel>(context,listen: false).set(pickedDate??DateTime.now());
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Kaydediliyor")));
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Ekle"),
                  )
                ],
              ),
            ));
      },
    );
  }
}
