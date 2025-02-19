import 'package:flutter/material.dart';

class IletisimSayfasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bize Ulaşın"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(

      padding: EdgeInsets.all(20.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Adres:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "104 Cadde, No: 56, Isparta, Türkiye",
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
                Divider(height: 32, color: Colors.grey[300], thickness: 1),
                Text(
                  "Telefon:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "+90 507 932 6347",
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
                Divider(height: 32, color: Colors.grey[300], thickness: 1),
                Text(
                  "E-posta:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "destek@isparta.edu.tr",
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}