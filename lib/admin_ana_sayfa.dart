import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sikayet_app/giris_sayfasi.dart';

class AdminSayfasi extends StatefulWidget {
  @override
  _AdminSayfasiState createState() => _AdminSayfasiState();
}

class _AdminSayfasiState extends State<AdminSayfasi> {
  final TextEditingController tarihController = TextEditingController();
  DateTime? selectedDate; // Seçilen tarih

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  "Admin Paneli",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: tarihController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Şikayet Tarihi Seç",
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
                          setState(() {
                            selectedDate = pickedDate;
                            tarihController.text =
                            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: Colors.redAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedDate = null; // Seçilen tarihi temizle
                        tarihController.clear(); // TextField içeriğini temizle
                      });
                    },
                    child: Text(
                      "Temizle",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(color: Colors.blueAccent, thickness: 1.5),
              SizedBox(height: 8),
              Text(
                "Şikayetler",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 8),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: selectedDate != null
                      ? FirebaseFirestore.instance
                      .collection('sikayet')
                      .where('cevaplandimi', isEqualTo: false)
                      .where('yolculukTarihi',
                      isEqualTo:
                      "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}")
                      .snapshots()
                      : FirebaseFirestore.instance
                      .collection('sikayet')
                      .where('cevaplandimi', isEqualTo: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Text(
                          selectedDate != null
                              ? "Seçilen tarihe ait şikayet bulunamadı."
                              : "Henüz bir şikayet yok.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }

                    final sikayetList = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: sikayetList.length,
                      itemBuilder: (context, index) {
                        final sikayet = sikayetList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            tileColor: Colors.white,
                            title: Text(
                              "${sikayet['kullaniciMail']}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.blueAccent,
                              ),
                            ),
                            subtitle: Text(
                              "Şikayet Tarihi: ${sikayet['yolculukTarihi']}",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 18,
                              color: Colors.blueAccent,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SikayetDetaySayfasi(
                                    sikayetBelgesi: sikayet,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () {
                  MaterialPageRoute route = MaterialPageRoute(
                    builder: (BuildContext context) {
                      return GirisSayfasi();
                    },
                  );
                  Navigator.push(context, route); // Ana sayfaya geri dön
                },
                child: Text(
                  "Çıkış Yap",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





class SikayetDetaySayfasi extends StatefulWidget {
  final QueryDocumentSnapshot sikayetBelgesi;

  SikayetDetaySayfasi({required this.sikayetBelgesi});

  @override
  _SikayetDetaySayfasiState createState() => _SikayetDetaySayfasiState();
}

class _SikayetDetaySayfasiState extends State<SikayetDetaySayfasi> {
  TextEditingController yanitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var data = widget.sikayetBelgesi.data() as Map<String, dynamic>;

    String kullaniciAdi = data['kullaniciAdi'] ?? 'Bilinmeyen Kullanıcı';
    String kullaniciMail = data['kullaniciMail'] ?? 'Bilinmeyen E-posta';
    String plaka = data['plaka'] ?? 'Bilinmeyen Plaka';
    String sikayet = data['sikayet'] ?? 'Şikayet detayı bulunamadı';
    String sofor = data['sofor'] ?? 'Bilinmeyen Şoför';
    String yolculukTarihi = data['yolculukTarihi'] ?? 'Tarih belirtilmemiş';

    return Scaffold(
      appBar: AppBar(
        title: Text("Şikayet Detayı"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Kullanıcı Adı: $kullaniciAdi",
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
              SizedBox(height: 8),
              Text(
                "Kullanıcı Mail: $kullaniciMail",
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
              SizedBox(height: 16),
              Text(
                "Araç Plakası: $plaka",
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
              SizedBox(height: 16),
              Text(
                "Şoför: $sofor",
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
              SizedBox(height: 16),
              Text(
                "Yolculuk Tarihi: $yolculukTarihi",
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
              SizedBox(height: 16),
              Text(
                "Şikayet Detayı:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 8),
              Text(
                sikayet,
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
              SizedBox(height: 16),

              // Yanıt TextField ekleme
              Text(
                "Yanıtınız:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: yanitController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Yanıtınızı buraya yazın...',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey,
                ),
              ),
              SizedBox(height: 16),

              // Gönder butonu
              ElevatedButton(
                onPressed: () async {
                  String yanit = yanitController.text;

                  if (yanit.isNotEmpty) {
                    // Firebase'e yanıt kaydet
                    await FirebaseFirestore.instance.collection('yanitlar').add({
                      'sikayetId': widget.sikayetBelgesi.id, // Şikayet ile ilişkilendirme
                      'cevap': yanit,
                      'kullaniciMail': widget.sikayetBelgesi['kullaniciMail'],
                      'sikayet': widget.sikayetBelgesi['sikayet'],
                      'tarih': Timestamp.now(),
                    });

                    // Şikayeti cevaplanmış olarak işaretle
                    await FirebaseFirestore.instance
                        .collection('sikayet')
                        .doc(widget.sikayetBelgesi.id)
                        .update({'cevaplandimi': true});

                    // Kullanıcıya bilgilendirme
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Yanıt başarıyla gönderildi!')),
                    );

                    // TextField'ı temizle ve geri dön
                    yanitController.clear();
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lütfen bir yanıt girin.')),
                    );
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  "Gönder",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  "Geri Dön",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
