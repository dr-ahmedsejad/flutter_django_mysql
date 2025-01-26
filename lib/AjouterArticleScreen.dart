import 'package:flutter/material.dart';
import 'package:flutter_django_mysql/ServiceArticle.dart';

class AjouterArticleScreen extends StatefulWidget {
  @override
  _AjouterArticleScreenState createState() => _AjouterArticleScreenState();
}

class _AjouterArticleScreenState extends State<AjouterArticleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _contenuController = TextEditingController();
  ServiceArticle ServArticle = ServiceArticle();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ajouter un Article",
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
                  hintText: "Entrez le titre de l'article",
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
                  hintText: "Écrivez le contenu de l'article ici...",
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
                      // setState(() {
                      // });
                        var resultat = await ServArticle.ajouterArticle(
                            _titreController.text, _contenuController.text);
                        if (resultat == true) {
                          // Afficher un message de succès
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Article ajouté avec succès")),
                          );
                          Navigator.pop(context, true);
                        }

                      else{
                        // Afficher le message d'erreur
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Erreur : Échec de l'ajout de l'article.")),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo, // Couleur de fond
                    padding: EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    "Ajouter",
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
