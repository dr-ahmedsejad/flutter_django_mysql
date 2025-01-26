import 'package:flutter/material.dart';
import 'package:flutter_django_mysql/AjouterArticleScreen.dart';
import 'package:flutter_django_mysql/ModifierArticleScreen.dart';
import 'ServiceArticle.dart';
import 'DetailArticleScreen.dart';

void main(){
  runApp(MaterialApp(home: ListeArticles()));
}

class ListeArticles extends StatefulWidget {
  @override
  _EtatListeArticles createState() => _EtatListeArticles();
}

class _EtatListeArticles extends State<ListeArticles> {
  final ServiceArticle _serviceArticle = ServiceArticle();
  List<dynamic> _articles = [];
  bool _enChargement = false;

  @override
  void initState() {
    super.initState();
    _recupererArticles();
  }

  /// Récupérer la liste des articles
  Future<void> _recupererArticles() async {
    setState(() {
      _enChargement = true;
    });
    try {
      final articles = await _serviceArticle.recupererArticles();
      setState(() {
        _articles = articles;
      });
    } catch (e) {
      print("Erreur: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du chargement des articles")),
      );
    } finally {
      setState(() {
        _enChargement = false;
      });
    }
  }

  /// Supprimer un article
  void _supprimerArticle(int id) async {
    final confirmer = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmer la suppression"),
        content: Text("Voulez-vous vraiment supprimer cet article ?"),
        actions: [
          TextButton(
            child: Text("Annuler"),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          ElevatedButton(
            child: Text("Supprimer"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirmer == true) {
      try {
        await _serviceArticle.supprimerArticle(id);
        setState(() {
          _articles.removeWhere((article) => article['id'] == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Article supprimé avec succès")),
        );
      } catch (e) {
        print("Erreur: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de la suppression de l'article")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Articles",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: _enChargement
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.indigo),
            SizedBox(height: 16),
            Text(
              "Chargement des articles...",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      )
          : _articles.isEmpty
          ? Center(
        child: Text(
          "Aucun article disponible",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: _articles.length,
        itemBuilder: (context, index) {
          final article = _articles[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.indigo,
                radius: 25,
                child: Text(
                  article['titre'][0].toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              title: Text(
                article['titre'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                article['contenu'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.green),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ModifierArticleScreen(id: article['id'], titre: article['titre'], contenu: article['contenu'])),
                      ).then((value) {
                        if (value == true) {
                          _recupererArticles();
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _supprimerArticle(article['id']),
                  ),
                  // Afficher une icône en fonction de l'état de l'article
                  article['etat'] == 'EN_ATTENTE'
                      ? Icon(Icons.hourglass_empty, color: Colors.orange)
                      : Icon(Icons.check_circle, color: Colors.green),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailArticleScreen(
                      id: article['id'],
                      titre: article['titre'],
                      contenu: article['contenu'],
                      etat: article['etat'],
                      date: article['date_publication'],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AjouterArticleScreen()),
          ).then((value) {
            if (value == true) {
              _recupererArticles();
            }
          });
        },
        backgroundColor: Colors.indigo,
        child: Icon(Icons.add),
        tooltip: "Ajouter un article",
      ),
    );
  }
}
