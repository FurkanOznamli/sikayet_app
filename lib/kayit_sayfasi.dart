import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KayitOlSayfasi extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController tcKimlikController = TextEditingController();
  final TextEditingController isimController = TextEditingController();
  final TextEditingController soyisimController = TextEditingController();
  final TextEditingController telefonController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController sifreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    "Kayıt Ol",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                buildTextFormField(
                  "TC Kimlik No",
                  Icons.person_outline,
                  tcKimlikController,
                  TextInputType.number,
                      (value) {
                    if (value == null || value.isEmpty) {
                      return "TC Kimlik No gerekli.";
                    } else if (value.length != 11) {
                      return "TC Kimlik No 11 haneli olmalıdır.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                buildTextFormField(
                  "İsim",
                  Icons.person,
                  isimController,
                  TextInputType.text,
                      (value) {
                    if (value == null || value.isEmpty) {
                      return "İsim gerekli.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                buildTextFormField(
                  "Soyisim",
                  Icons.person,
                  soyisimController,
                  TextInputType.text,
                      (value) {
                    if (value == null || value.isEmpty) {
                      return "Soyisim gerekli.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                buildTextFormField(
                  "Telefon No",
                  Icons.phone,
                  telefonController,
                  TextInputType.phone,
                      (value) {
                    if (value == null || value.isEmpty) {
                      return "Telefon No gerekli.";
                    } else if (value.length != 10) {
                      return "Telefon No 10 haneli olmalıdır.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                buildTextFormField(
                  "Mail Adresi",
                  Icons.email,
                  mailController,
                  TextInputType.emailAddress,
                      (value) {
                    if (value == null || value.isEmpty) {
                      return "Mail adresi gerekli.";
                    } else if (!value.contains("@")) {
                      return "Geçerli bir mail adresi girin.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                buildTextFormField(
                  "Şifre",
                  Icons.lock,
                  sifreController,
                  TextInputType.text,
                      (value) {
                    if (value == null || value.isEmpty) {
                      return "Şifre gerekli.";
                    } else if (value.length < 6) {
                      return "Şifre en az 6 karakter olmalıdır.";
                    }
                    return null;
                  },
                  obscureText: true,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await registerUser(context);
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Kayıt Ol", style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField(
      String label,
      IconData icon,
      TextEditingController controller,
      TextInputType keyboardType,
      String? Function(String?)? validator, {
        bool obscureText = false,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: validator,
    );
  }

  Future<void> registerUser(BuildContext context) async {
    try {
      // Firebase Authentication Kullanıcı Kaydı
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: mailController.text.trim(),
        password: sifreController.text.trim(),
      );

      // Kullanıcı Bilgilerini Firestore'a Kaydet
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'tcNo': tcKimlikController.text.trim(),
        'isim': isimController.text.trim(),
        'soyisim': soyisimController.text.trim(),
        'telNo': telefonController.text.trim(),
        'mail': mailController.text.trim(),
      });

      // Başarılı Mesajı
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kayıt başarılı!")),
      );
    } on FirebaseAuthException catch (e) {
      // Hata Mesajı
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: ${e.message}")),
      );
    } catch (e) {
      // Genel Hata
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bir hata oluştu.")),
      );
    }
  }
}
