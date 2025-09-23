import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- SplashScreen mínima ---
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: azulEscuro,
      body: const Center(
        child: CircularProgressIndicator(color: amarelo),
      ),
    );
  }
}

// --- OnboardingScreen mínima ---
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bege,
      body: const Center(
        child: Text('Onboarding', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

// --- LivroCrudScreen mínima ---
class LivroCrudScreen extends StatelessWidget {
  const LivroCrudScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo')),
      body: const Center(
        child: Text('CRUD de Livros', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

// --- Classe Livro mínima ---
class Livro {
  final String titulo;
  final String autor;
  final int paginas;
  final String imagem;

  Livro({required this.titulo, required this.autor, required this.paginas, required this.imagem});
}

// ...existing code...

// ...existing code...

const Color azulEscuro = Color(0xFF070743);
const Color azul = Color(0xFF169D99);
const Color amarelo = Color(0xFFB9CC01);
const Color bege = Color(0xFFFAE894);
const Color magenta = Color(0xFFAB0768);
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema Livros',
      theme: ThemeData(
        primaryColor: azulEscuro,
        scaffoldBackgroundColor: bege,
        appBarTheme: const AppBarTheme(
          backgroundColor: azulEscuro,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: magenta,
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: amarelo,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const LivroCrudScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class LivroDialog extends StatefulWidget {
  final Livro? livro;

  const LivroDialog({super.key, this.livro});

  @override
  State<LivroDialog> createState() => _LivroDialogState();
}

class _LivroDialogState extends State<LivroDialog> {
  final _formKey = GlobalKey<FormState>();
  late String titulo;
  late String autor;
  late int paginas;
  late String imagem;

  @override
  void initState() {
    super.initState();
    titulo = widget.livro?.titulo ?? '';
    autor = widget.livro?.autor ?? '';
    paginas = widget.livro?.paginas ?? 0;
    imagem = widget.livro?.imagem ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: bege,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        widget.livro == null ? 'Adicionar Livro' : 'Editar Livro',
        style: TextStyle(
          color: azulEscuro,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: titulo,
                decoration: InputDecoration(
                  labelText: 'Título',
                  labelStyle: TextStyle(color: azulEscuro),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: azul),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o título' : null,
                onSaved: (value) => titulo = value!,
              ),
              TextFormField(
                initialValue: autor,
                decoration: InputDecoration(
                  labelText: 'Autor',
                  labelStyle: TextStyle(color: azulEscuro),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: azul),
                  ),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o autor' : null,
                onSaved: (value) => autor = value!,
              ),
              TextFormField(
                initialValue: paginas == 0 ? '' : paginas.toString(),
                decoration: InputDecoration(
                  labelText: 'Páginas',
                  labelStyle: TextStyle(color: azulEscuro),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: azul),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe as páginas';
                  if (int.tryParse(value) == null) return 'Número inválido';
                  return null;
                },
                onSaved: (value) => paginas = int.parse(value!),
              ),
              TextFormField(
                initialValue: imagem,
                decoration: InputDecoration(
                  labelText: 'Caminho da imagem',
                  labelStyle: TextStyle(color: azulEscuro),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: azul),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Informe o caminho da imagem' : null,
                onSaved: (value) => imagem = value!,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancelar', style: TextStyle(color: magenta)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: azul,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Salvar'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Navigator.of(context).pop(
                Livro(
                  titulo: titulo,
                  autor: autor,
                  paginas: paginas,
                  imagem: imagem,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}




