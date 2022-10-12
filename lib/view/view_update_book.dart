import 'package:cloudfirestoreandmvvm/view_model/view_model_update_book.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/model_book.dart';
import '../view_model/datetime_helper.dart';

class UpdateBookView extends StatelessWidget {
  Book book;

  UpdateBookView({required this.book});

  final _formKey = GlobalKey<FormState>();
  bool controlVar = true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UpdateBookViewModel>(
        create: (context) => UpdateBookViewModel(),
        builder: (BuildContext context, child) {
          if (controlVar) {
            Provider.of<UpdateBookViewModel>(context).setInitialData(book);
          }
          controlVar = false;
          DateTime pickedDate = DateTimeHelper.toDateTimeFromTimeStamp(
              book.kitapBasimYili);
          return Scaffold(
            appBar: AppBar(
              title: Text("Kitap Ismi: ${book.kitapIsmi}"),
            ),
            body: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: Provider
                        .of<UpdateBookViewModel>(context)
                        .kitapIsmiController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Kitap ismi bos olamaz";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.book),
                        border: OutlineInputBorder(),
                        hintText: "Kitap ismi"),
                  ),
                  TextFormField(
                    controller: Provider
                        .of<UpdateBookViewModel>(context)
                        .kitapYazariController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Yazar ismi bos olamaz";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.edit),
                        border: OutlineInputBorder(),
                        hintText: "Kitap Yazari"),
                  ),
                  TextFormField(
                    controller: Provider
                        .of<UpdateBookViewModel>(context)
                        .kitapBasimYiliController,
                    onTap: () async {
                      ///Zaman secimi yapiyorum
                      pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now()) as DateTime;
                      Provider.of<UpdateBookViewModel>(context, listen: false)
                          .setPickedDate(pickedDate);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Basim Tarihi bos olamaz";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                        hintText: "Kitap Basim Yili"),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        ///Update buttonu
                        if (_formKey.currentState!.validate()) {
                          Provider.of<UpdateBookViewModel>(
                              context, listen: false).update(
                              book.kitapId, pickedDate);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Guncelleniyor")));
                        }
                        print("kitap id: ${book.kitapId}");
                      },
                      child: Text("Guncelle"))
                ],
              ),
            ),
          );
        });
  }
}
