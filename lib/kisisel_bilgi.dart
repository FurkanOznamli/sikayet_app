import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class KisiselBilgilerSayfasi extends StatefulWidget {
  @override
  _KisiselBilgilerSayfasiState createState() => _KisiselBilgilerSayfasiState();
}

class _KisiselBilgilerSayfasiState extends State<KisiselBilgilerSayfasi> {
  Map<String, dynamic>? kullaniciBilgileri;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _kullaniciBilgileriniGetir();
  }

  Future<void> _kullaniciBilgileriniGetir() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Kullanıcının UID'si ile Firestore'dan veri çek
        DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (snapshot.exists) {
          setState(() {
            kullaniciBilgileri = snapshot.data();
            isLoading = false;
          });
        } else {
          setState(() {
            kullaniciBilgileri = null;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          kullaniciBilgileri = null;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Hata: $e");
      setState(() {
        kullaniciBilgileri = null;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (kullaniciBilgileri == null) {
      return Scaffold(
        body: Center(
          child: Text("Kullanıcı bilgileri bulunamadı."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueAccent,),
      backgroundColor: Colors.blue[50],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6,
          child: Container(
            padding: EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kişisel Bilgiler",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 20),
                _bilgiGoster("TC Kimlik No", kullaniciBilgileri!['tcNo']),
                _bilgiGoster("İsim", kullaniciBilgileri!['isim']),
                _bilgiGoster("Soyisim", kullaniciBilgileri!['soyisim']),
                _bilgiGoster("Telefon", kullaniciBilgileri!['telNo']),
                _bilgiGoster("E-Posta", kullaniciBilgileri!['mail']),
                //_bilgiGoster("Şifre", kullaniciBilgileri!['sifre']),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, "/");
                  },
                  child: Text("Çıkış Yap"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bilgiGoster(String baslik, String deger) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            deger,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          Divider(thickness: 1, color: Colors.grey[300]),
        ],
      ),
    );
  }
}
