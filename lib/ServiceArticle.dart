import 'dart:convert';
import 'package:http/http.dart' as http;

class ServiceArticle {
  final String urlBase = "http://127.0.0.1:8000/api";

  /// Récupérer la liste des articles
  Future<List<dynamic>> recupererArticles() async {
    final response = await http.get(Uri.parse("$urlBase/articles/"));
    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes)); // Gérer les caractères spéciaux
    } else {
      throw Exception("Erreur lors de la récupération des articles");
    }
  }

  /// Ajouter un nouvel article
  Future<bool> ajouterArticle(String titre, String contenu) async {
    final response = await http.post(
      Uri.parse("$urlBase/articles/"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"titre": titre, "contenu": contenu}),
    );

    if (response.statusCode == 201) {
      // Succès
      return true;
    } else {
      // Échec : lever une exception avec des détails sur l'erreur
      throw Exception("Erreur ${response.statusCode}: ${response.body}");
    }
  }


  /// Modifier un article existant
  Future<bool> modifierArticle(int id, String titre, String contenu) async {
    final response = await http.put(
      Uri.parse("$urlBase/articles/$id/"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"titre": titre, "contenu": contenu}),
    );
    if (response.statusCode == 200) {
      // Succès
      return true;
    }
    else {
      throw Exception("Erreur lors de la modification de l'article");
    }
  }

  /// Supprimer un article
  Future<void> supprimerArticle(int id) async {
    final response = await http.delete(Uri.parse("$urlBase/articles/$id/"));
    if (response.statusCode != 200) {
      throw Exception("Erreur lors de la suppression de l'article");
    }
  }
}
