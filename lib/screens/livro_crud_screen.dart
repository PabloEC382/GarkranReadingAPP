import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/livro.dart';
import '../widgets/livro_dialog.dart';
import '../services/livro_persistence.dart';

const Color azul = Color(0xFF169D99);
const Color bege = Color(0xFFFAE894);
const Color azulPreto = Color(0xFF121E24);
const Color azulProfundo = Color(0xFF0D1B2A);
const Color azulPetroleo = Color(0xFF007C92);
const Color azulSuave = Color(0xFF5BC0BE);
const Color branco = Colors.white;

enum LivroLayout { vertical, horizontal }

class LivroCrudScreen extends StatefulWidget {
  const LivroCrudScreen({super.key});

  @override
  State<LivroCrudScreen> createState() => _LivroCrudScreenState();
}

class _LivroCrudScreenState extends State<LivroCrudScreen> {
  List<Livro> livros = [];
  LivroLayout _layout = LivroLayout.vertical;

  @override
  void initState() {
    super.initState();
    _carregarLivros();
  }

  Future<void> _carregarLivros() async {
    final loaded = await LivroPersistence.carregarLivros();
    setState(() {
      livros = loaded;
    });
  }

  Future<void> _salvarLivros() async {
    await LivroPersistence.salvarLivros(livros);
  }

  void _adicionarLivro() async {
    final novoLivro = await showDialog<Livro>(
      context: context,
      builder: (context) => LivroDialog(),
    );
    if (novoLivro != null) {
      setState(() {
        livros.add(novoLivro);
      });
      await _salvarLivros();
    }
  }

  void _editarLivro(int index) async {
    final livroEditado = await showDialog<Livro>(
      context: context,
      builder: (context) => LivroDialog(livro: livros[index]),
    );
    if (livroEditado != null) {
      setState(() {
        livros[index] = livroEditado;
      });
      await _salvarLivros();
    }
  }

  void _removerLivro(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover livro'),
        content: const Text('Tem certeza que deseja remover este livro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              setState(() {
                livros.removeAt(index);
              });
              await _salvarLivros();
              Navigator.of(context).pop();
            },
            child: const Text('Remover'),
          ),
        ],
      ),
    );
  }

  void _mostrarNotas(BuildContext context, String notas) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notas do Livro'),
        content: Text(notas),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: azulPreto,
      appBar: AppBar(
        titleSpacing: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
          child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.contain,
            width: 40,
            height: 40,
          ),
        ),
        title: const Text('Meus Livros'),
        backgroundColor: azulProfundo,
        foregroundColor: branco,
        actions: [
          IconButton(
            icon: Icon(
              _layout == LivroLayout.vertical ? Icons.view_module : Icons.view_list,
              color: branco,
            ),
            tooltip: _layout == LivroLayout.vertical ? 'Visualizar em grade' : 'Visualizar em lista',
            onPressed: () {
              setState(() {
                _layout = _layout == LivroLayout.vertical
                    ? LivroLayout.horizontal
                    : LivroLayout.vertical;
              });
            },
          ),
        ],
      ),
      body: livros.isEmpty
          ? const Center(
              child: Text(
                'Nenhum livro cadastrado.',
                style: TextStyle(color: branco),
              ),
            )
          : _layout == LivroLayout.vertical
              ? ListView.builder(
                  itemCount: livros.length,
                  itemBuilder: (context, index) {
                    final livro = livros[index];
                    Widget leadingWidget;
                    if (kIsWeb) {
                      leadingWidget = ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/logo.png',
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                      );
                    } else if (livro.capaPath != null && livro.capaPath!.isNotEmpty) {
                      leadingWidget = ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(livro.capaPath!),
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.book, size: 40),
                        ),
                      );
                    } else {
                      leadingWidget = const Icon(Icons.book, size: 40);
                    }
                    return Card(
                      color: azulPetroleo,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: leadingWidget,
                        title: Text(
                          livro.titulo,
                          style: const TextStyle(color: branco),
                        ),
                        subtitle: Text(
                          'Autor: ${livro.autor}\n'
                          'Gênero: ${livro.genero}\n'
                          'Folhas: ${livro.quantidadeFolhas}',
                          style: const TextStyle(color: branco),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editarLivro(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removerLivro(index),
                            ),
                            if (livro.notas != null && livro.notas!.isNotEmpty)
                              IconButton(
                                icon: const Icon(Icons.sticky_note_2, color: Colors.amber),
                                onPressed: () => _mostrarNotas(context, livro.notas!),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: livros.length,
                  itemBuilder: (context, index) {
                    final livro = livros[index];
                    Widget leadingWidget;
                    if (kIsWeb) {
                      leadingWidget = ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/logo.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      );
                    } else if (livro.capaPath != null && livro.capaPath!.isNotEmpty) {
                      leadingWidget = ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(livro.capaPath!),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.book, size: 80),
                        ),
                      );
                    } else {
                      leadingWidget = const Icon(Icons.book, size: 80);
                    }
                    return Card(
                      color: azulPetroleo,
                      child: Container(
                        constraints: const BoxConstraints(
                          maxHeight: 220,
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              leadingWidget,
                              const SizedBox(height: 8),
                              Text(
                                livro.titulo,
                                style: const TextStyle(color: branco, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                livro.autor,
                                style: const TextStyle(color: branco),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                livro.status,
                                style: const TextStyle(color: branco, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => _editarLivro(index),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _removerLivro(index),
                                  ),
                                  if (livro.notas != null && livro.notas!.isNotEmpty)
                                    IconButton(
                                      icon: const Icon(Icons.sticky_note_2, color: Colors.amber),
                                      onPressed: () => _mostrarNotas(context, livro.notas!),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarLivro,
        backgroundColor: azulSuave,
        foregroundColor: branco,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}