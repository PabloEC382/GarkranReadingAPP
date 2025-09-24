import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/livro.dart';

class LivroPersistence {
  static const String _livrosKey = 'livros';

  static Future<void> salvarLivros(List<Livro> livros) async {
    final prefs = await SharedPreferences.getInstance();
    final livrosJson = livros.map((livro) => livro.toJson()).toList();
    await prefs.setString(_livrosKey, jsonEncode(livrosJson));
  }

  static Future<List<Livro>> carregarLivros() async {
    final prefs = await SharedPreferences.getInstance();
    final livrosString = prefs.getString(_livrosKey);
    if (livrosString == null) return [];
    final List<dynamic> livrosJson = jsonDecode(livrosString);
    return livrosJson.map((json) => Livro.fromJson(json)).toList();
  }
}