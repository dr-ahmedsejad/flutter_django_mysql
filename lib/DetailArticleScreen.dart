import 'package:flutter/material.dart';

class DetailArticleScreen extends StatelessWidget {
  final int id;
  final String titre;
  final String contenu;
  final String etat;
  final String date;


  DetailArticleScreen({
    required this.id,
    required this.titre,
    required this.contenu,
    required this.etat,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    String date_pub = date.substring(0, 10);
    return Scaffold(
      appBar: AppBar(
        title: Text("Détail de l'Article"),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Titre :",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.indigo,
              ),
            ),
            SizedBox(height: 8),
            Text(
              titre,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 16),
            Text(
              "Contenu :",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.indigo,
              ),
            ),
            SizedBox(height: 8),
            Text(
              contenu,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Colors.indigo,
                ),
                SizedBox(width: 8),
                Text(
                  "Date : $date_pub",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "État :",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.indigo,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                etat == 'EN_ATTENTE'
                    ? Icon(Icons.hourglass_empty, color: Colors.orange)
                    : Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  etat == 'EN_ATTENTE' ? "En Attente" : "Valide",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
