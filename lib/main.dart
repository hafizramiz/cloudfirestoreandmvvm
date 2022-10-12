import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudfirestoreandmvvm/model/firebase_services.dart';
import 'package:cloudfirestoreandmvvm/model/model_book.dart';
import 'package:cloudfirestoreandmvvm/view/view_add_book.dart';
import 'package:cloudfirestoreandmvvm/view/view_odunc_alanlar.dart';
import 'package:cloudfirestoreandmvvm/view/view_update_book.dart';
import 'package:cloudfirestoreandmvvm/view_model/datetime_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    Provider<FireBaseFireStoreService>(
      create: (context) => FireBaseFireStoreService(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddBookView()));
        },
        label: const Text('Kitap Ekle'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      appBar: AppBar(
        title: Text("Kitaplar"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        initialData: null,
        stream: Provider.of<FireBaseFireStoreService>(context, listen: false)
            .getBookStream("Kitaplar"),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Hata olustu');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Yukleniyor");
          } else {
            ///Asyncden temizleme
            var asyncdenTemizleme = snapshot.data!;
            List<DocumentSnapshot> documentSnapListesi = asyncdenTemizleme.docs;

            List<Book> bookList =
                documentSnapListesi.map((DocumentSnapshot document) {
              Book book =
                  Book.fromJson(document.data() as Map<String, dynamic>);
              return book;
            }).toList();

            return FilterlemeWidgeti(bookList: bookList);
          }
        },
      ),
    );
  }
}

///Filterleme yapiyorum

class FilterlemeWidgeti extends StatefulWidget {
  const FilterlemeWidgeti({
    required this.bookList,
  });

  final List<Book> bookList;

  @override
  State<FilterlemeWidgeti> createState() => _FilterlemeWidgetiState();
}

bool isFiltering = false;
TextEditingController _searchController = TextEditingController();
List<Book> filteredBookList = [];

void dispose() {
  _searchController.dispose();
}

class _FilterlemeWidgetiState extends State<FilterlemeWidgeti> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          onChanged: (_) {
            if (_searchController.text != null ||
                _searchController.text.isNotEmpty) {
              isFiltering = true;
              filteredBookList = widget.bookList
                  .where((bookItem) => bookItem.kitapIsmi
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase()))
                  .toList();
              setState(() {});
            }
          },
          decoration: InputDecoration(
              suffixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              hintText: "Arama yap"),
        ),
        Flexible(
          child: ListView.builder(
              itemCount: isFiltering
                  ? filteredBookList.length
                  : widget.bookList.length,
              itemBuilder: (context, int index) {
                List<Book> chosenList =
                    isFiltering ? filteredBookList : widget.bookList;
                return Slidable(
                  child: ListTile(
                    title: Text(" ${chosenList[index].kitapIsmi}"),
                    subtitle: Text(" ${chosenList[index].kitapYazari}"),
                    trailing: Text(
                        "Basim Tarihi: ${DateTimeHelper.toStringFromTimeStamp(chosenList[index].kitapBasimYili)}"),
                  ),
                  startActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) {
                          Provider.of<FireBaseFireStoreService>(context,
                                  listen: false)
                              .delete(
                                  "Kitaplar", widget.bookList[index].kitapId);
                        },
                        backgroundColor: Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Sil',
                      ),
                      SlidableAction(
                        onPressed: (_) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateBookView(
                                      book: widget.bookList[index])));
                        },
                        backgroundColor: Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Guncelle',
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OduncAlanlarView(book: widget.bookList[index])));
                        },
                        backgroundColor: Color(0xFF7BC043),
                        foregroundColor: Colors.white,
                        icon: Icons.person,
                        label: 'Odunc Alanlar',
                      ),
                    ],
                  ),
                );
              }),
        ),
      ],
    );
  }
}
