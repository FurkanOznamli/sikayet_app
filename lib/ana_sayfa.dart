import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sikayet_app/cevaplar.dart';
import 'package:sikayet_app/giris_sayfasi.dart';

import 'iletisim_sayfasi.dart';
import 'kisisel_bilgi.dart';

class AnaSayfa extends StatelessWidget {
  final TextEditingController tarihController = TextEditingController();
  final TextEditingController plakaController = TextEditingController();
  final TextEditingController soforController = TextEditingController();
  final TextEditingController sikayetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    MaterialPageRoute route = MaterialPageRoute(
                      builder: (BuildContext context) {
                        return KisiselBilgilerSayfasi();
                      },
                    );
                    Navigator.push(context, route);
                  },
                  icon: Icon(Icons.account_circle, size: 40, color: Colors.blueAccent),
                ),
                SizedBox(width: 75),
                Text(
                  "ANA SAYFA",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(width: 60),
                IconButton(
                  onPressed: () {
                    MaterialPageRoute route = MaterialPageRoute(
                      builder: (BuildContext context) {
                        return Cevaplar();
                      },
                    );
                    Navigator.push(context, route);
                  },
                  icon: Icon(Icons.mail, size: 40, color: Colors.blueAccent),
                ),
              ],
            ),
            Divider(height: 40, color: Colors.grey[300], thickness: 2),
            TextField(
              controller: tarihController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Yolculuk Tarihi",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: Icon(Icons.calendar_today, color: Colors.blueAccent),
              ),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  tarihController.text =
                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                }
              },
            ),
            SizedBox(height: 16),
            _createQuestionField(
              context,
              label: "Aracın Plakasını Biliyor musunuz?",
              controller: plakaController,
              hintText: "Plaka (eğer biliyorsanız)",
            ),
            SizedBox(height: 16),
            _createQuestionField(
              context,
              label: "Şoförün İsmini Biliyor musunuz?",
              controller: soforController,
              hintText: "Şoför İsmi (eğer biliyorsanız)",
            ),
            SizedBox(height: 16),
            TextField(
              controller: sikayetController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Şikayetiniz",
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () async {
                User? user = FirebaseAuth.instance.currentUser;


                if (user != null) {
                  await FirebaseFirestore.instance.collection('sikayet').add({
                    'kullaniciAdi': user.displayName ?? "Gizli",
                    'kullaniciMail': user.email ?? "Bilinmiyor",
                    'yolculukTarihi': tarihController.text.trim(),
                    'plaka': plakaController.text.trim(),
                    'sofor': soforController.text.trim(),
                    'sikayet': sikayetController.text.trim(),
                    'tarih': DateTime.now(),
                    'cevaplandimi' : false,
                  });

                  _showSnackbar(context, "Şikayet başarıyla gönderildi.");
                  tarihController.clear();
                  plakaController.clear();
                  soforController.clear();
                  sikayetController.clear();
                } else {
                  _showSnackbar(context, "Giriş yapılmamış.");
                }
              },
              child: Text(
                "Şikayeti Gönder",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                MaterialPageRoute pageRoute = MaterialPageRoute(
                  builder: (BuildContext context) {
                    return GirisSayfasi();
                  },
                );
                Navigator.push(context, pageRoute);
              },
              child: Text(
                "Çıkış Yap",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 200),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IletisimSayfasi(),
                    ),
                  );
                },
                child: Text(
                  "Bize Ulaşın",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createQuestionField(
      BuildContext context, {
        required String label,
        required TextEditingController controller,
        required String hintText,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
