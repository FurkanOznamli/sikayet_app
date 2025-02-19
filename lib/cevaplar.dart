import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tarih formatlama için intl paketi

class Cevaplar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser; // Giriş yapan kullanıcıyı al
    final String? userEmail = user?.email;

    if (userEmail == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Geri Dönüşler"),
          backgroundColor: Colors.blueAccent,
        ),
        body: Center(
          child: Text(
            "Giriş yapmış bir kullanıcı bulunamadı.",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Geri Dönüşler"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('yanitlar')
                .where('kullaniciMail', isEqualTo: userEmail) // Kullanıcının mailine göre filtreleme
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    "Henüz bir geri dönüş bulunmuyor.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              final cevaplarList = snapshot.data!.docs;

              return ListView.builder(
                itemCount: cevaplarList.length,
                itemBuilder: (context, index) {
                  final cevapData = cevaplarList[index].data() as Map<String, dynamic>;

                  final String sikayet = cevapData['sikayet'] ?? 'Şikayet detayı bulunamadı';
                  final String cevap = cevapData['cevap'] ?? 'Cevap bulunamadı';
                  final Timestamp? timestamp = cevapData['tarih'] as Timestamp?;

                  String formattedDate = "Tarih bilinmiyor";
                  if (timestamp != null) {
                    DateTime date = timestamp.toDate();
                    formattedDate = DateFormat('dd MMMM yyyy, HH:mm').format(date); // Örneğin: 16 Ocak 2025, 14:30
                  }

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Şikayetiniz:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            sikayet,
                            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Yanıt:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            cevap,
                            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Tarih:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            formattedDate,
                            style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
