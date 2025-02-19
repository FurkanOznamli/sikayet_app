import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sikayet_app/admin_ana_sayfa.dart';
import 'package:sikayet_app/ana_sayfa.dart';
import 'package:sikayet_app/kayit_sayfasi.dart';

class GirisSayfasi extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController sifreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 6,
            child: Container(
              padding: EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "GİRİŞ YAP",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "E-Posta",
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: sifreController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Şifre",
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      _girisYap(context);
                    },
                    child: Text(
                      "Giriş Yap",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KayitOlSayfasi(),
                        ),
                      );
                    },
                    child: Text("Hesabınız yok mu? Kayıt Ol"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _girisYap(BuildContext context) async {
    try {
      // Kullanıcı bilgilerini al
      final email = emailController.text.trim();
      final sifre = sifreController.text.trim();

      // Firebase Authentication ile giriş yap
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: sifre);

      // Giriş başarılı olduğunda yönlendirme yap
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Giriş başarılı!")),
      );
      if (email == "admin@gmail.com" && sifre == "adminler")
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminSayfasi()),
        );
      else
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AnaSayfa()),
        );
    } on FirebaseAuthException catch (e) {
      // Firebase Authentication hatalarını işle
      String hataMesaji;
      if (e.code == 'user-not-found') {
        hataMesaji = "Kullanıcı bulunamadı. Lütfen kayıt olun.";
      } else if (e.code == 'wrong-password') {
        hataMesaji = "Hatalı şifre girdiniz.";
      } else {
        hataMesaji = "Bir hata oluştu Lütfen boş bırakmayınız";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(hataMesaji)),
      );
    } catch (e) {
      // Diğer hatalar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bir hata oluştu: $e")),
      );
    }
  }


}

