import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sikayet_app/firebase_options.dart';

import 'giris_sayfasi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase'i başlat
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GirisSayfasi(),
    );


  }
}
