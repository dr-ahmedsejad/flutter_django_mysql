import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_django_mysql/ServiceArticle.dart';

class ModifierArticleScreen extends StatefulWidget {
  final int id;
  final String titre;
  final String contenu;

  ModifierArticleScreen({
    required this.id,
    required this.titre,
    required this.contenu,
  });

  @override
  _ModifierArticleScreenState createState() => _ModifierArticleScreenState();
}

class _ModifierArticleScreenState extends State<ModifierArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titreController;
  late TextEditingController _contenuController;
  ServiceArticle ServArticle = ServiceArticle();

  @override
  void initState() {
    super.initState();
    _titreController = TextEditingController(text: widget.titre);
    _contenuController = TextEditingController(text: widget.contenu);
  }

  @override
  void dispose() {
    _titreController.dispose();
    _contenuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Modifier l'Article",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Titre de l'article",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.indigo,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _titreController,
                decoration: InputDecoration(
                  hintText: "Modifiez le titre de l'article",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Le titre est obligatoire";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text(
                "Contenu de l'article",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.indigo,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _contenuController,
                decoration: InputDecoration(
                  hintText: "Modifiez le contenu de l'article",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Le contenu est obligatoire";
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final resultat = await ServArticle.modifierArticle(
                        widget.id,
                        _titreController.text,
                        _contenuController.text,
                      );
                      if (resultat == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Article modifié avec succès")),
                        );
                        Navigator.pop(context, true);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Erreur : Échec de la modification.")),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    "Modifier",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
