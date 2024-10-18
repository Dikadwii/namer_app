//memasukkan package yang dibutuhkan oleh aplikasi
import 'package:english_words/english_words.dart';
//package untuk bahasa inggris
import 'package:flutter/material.dart';
//package untuk tampilan ui (material ui)
import 'package:provider/provider.dart';
//package untuk interaksi aplikasi

//fungsi main (fungsi utama)
void main() {
  runApp(MyApp());//memanggil fungsi runapp yang menjalankan keseluruhan aplikasi didalam my app()
}

//membuat abstrak aplikasidari statelesswidget (template aplikasi),aplikasinya bernama myapp
class MyApp extends StatelessWidget {
  const MyApp({super.key});//menunjukkan bahwa aplikasi ini akan tetap, tidak berubah setelah dibuild

  @override//mengganti nilai lama yang sudah ada ditemplate,dengan nilai nilai yang baru (replace/overwrite)
  Widget build(BuildContext context) {
    //fungsi yang membangun ui (ui mengatur posisi widget,dst)
    //ChangeNotifierProvider mendengarkan/mendeteksi semua interaksi yang terjadi di aplikasi
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),//membuat satu state bernama myapp state 
      child: MaterialApp(//membuat state ini menggunakan style desain material
        title: 'Namer App',//diberi judul namer_app
        theme: ThemeData(//data tema aplikasi,diberi warna deeporange
          useMaterial3: true,//versi materialUI yang dipakai versi (13)
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),//nama halaman "myhomepage" yang menggunakan state "myappstate"
      ),
    );
  }
}
//mendefinisikan myappstate
class MyAppState extends ChangeNotifier {
  //state myappstate diisi dengan 2 kata random yang digabung,kata random tsb disimpan divariable WordPair
  var current = WordPair.random();
}
//membuat layout pada halaman homepage
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();//widget menggunakan state myappstate
    //dibawah ini adalah kode program untuk menyusun layout

    return Scaffold(//base (canvas) dari layout
      body: Column(//diatas scafold ada body,bodynya diberi kolom
        children: [//didalam kolom diberi teks
          Text('A random idea:'),
          Text(appState.current.asLowerCase),//mengambil random teks dari appstate pada variable wordpair curent,lalu diubah menjadi huruf kecil semua dan ditampilkan sebagai teks
          ElevatedButton(
            onPressed: () {
              print('button pressed!');
            },
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}