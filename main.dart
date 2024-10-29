import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
//package untuk tampilan ui (material ui)
import 'package:provider/provider.dart';
//package untuk interaksi aplikasi

//fungsi main (fungsi utama)
void main() {
  runApp(
      MyApp()); //memanggil fungsi runapp yang menjalankan keseluruhan aplikasi didalam my app()
}

//membuat abstrak aplikasidari statelesswidget (template aplikasi),aplikasinya bernama myapp
class MyApp extends StatelessWidget {
  const MyApp(
      {super.key}); //menunjukkan bahwa aplikasi ini akan tetap, tidak berubah setelah dibuild

  @override //mengganti nilai lama yang sudah ada ditemplate,dengan nilai nilai yang baru (replace/overwrite)
  Widget build(BuildContext context) {
    //fungsi yang membangun ui (ui mengatur posisi widget,dst)
    //ChangeNotifierProvider mendengarkan/mendeteksi semua interaksi yang terjadi di aplikasi
    return ChangeNotifierProvider(
      create: (context) =>
          MyAppState(), //membuat satu state bernama myapp state
      child: MaterialApp(
        //membuat state ini menggunakan style desain material
        title: 'Namer App', //diberi judulnamer_app
        theme: ThemeData(
          //data tema aplikasi,diberi warna deeporange
          useMaterial3: true, //versi materialUI yang dipakai versi (13)
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home:
            MyHomePage(), //nama halaman "myhomepage" yang menggunakan state "myappstate"
      ),
    );
  }
}

//mendefinisikan myappstate
class MyAppState extends ChangeNotifier {
  //state myappstate diisi dengan 2 kata random yang digabung,kata random tsb disimpan divariable WordPair
  var current = WordPair.random();
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  //membuat variable bertipe "list" bernama favorit untuk menyimpan daftar kata yang di like
  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}
// ...

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ...

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          //mengubah kata dalam pair menjadi huruf kecil
          pair.asLowerCase,
          style:
              style, //menerapkan style dengan nama style yg sudah dibuat,ke dalam text
          //memberi label pada masing masing kata,supaya text tertata dengan benar oleh aplikasi
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}
