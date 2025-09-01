import 'package:flutter/material.dart';

const Color azulEscuro = Color(0xFF070743);
const Color azul = Color(0xFF169D99);
const Color amarelo = Color(0xFFB9CC01);
const Color bege = Color(0xFFFAE894);
const Color magenta = Color(0xFFAB0768);

void main() {
  runApp(const MyApp());
}

class Livro {
  String titulo;
  String autor;
  int paginas;
  bool disponivel;

  Livro({
    required this.titulo,
    required this.autor,
    required this.paginas,
    required this.disponivel,
  });
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
      home: const LivroCrudScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LivroCrudScreen extends StatefulWidget {
  const LivroCrudScreen({super.key});

  @override
  State<LivroCrudScreen> createState() => _LivroCrudScreenState();
}

class _LivroCrudScreenState extends State<LivroCrudScreen> {
  List<Livro> livros = [
    Livro(
      titulo: 'Confissões',
      autor: 'Agostinho',
      paginas: 400,
      disponivel: true,
    ),
    Livro(
      titulo: 'Sumula Teológica',
      autor: 'Tomás de Aquino',
      paginas: 900,
      disponivel: true,
    ),
    Livro(
      titulo: 'Metafísica',
      autor: 'Aristóteles',
      paginas: 350,
      disponivel: false,
    ),
  ];

  void _adicionarLivro() async {
    final novoLivro = await showDialog<Livro>(
      context: context,
      builder: (context) => LivroDialog(),
    );
    if (novoLivro != null) {
      setState(() {
        livros.add(novoLivro);
      });
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
    }
  }

  void _removerLivro(int index) {
    setState(() {
      livros.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sistema Livros',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
          child: livros.isEmpty
              ? Text(
                  'Nenhum livro cadastrado.',
                  style: TextStyle(
                    color: azulEscuro,
                    fontSize: 18,
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: livros.length,
                  itemBuilder: (context, index) {
                    final livro = livros[index];
                    return Card(
                      color: Colors.white,
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: amarelo, width: 2),
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        title: Text(
                          livro.titulo,
                          style: TextStyle(
                            color: azulEscuro,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Autor: ${livro.autor}',
                                style: TextStyle(color: azul, fontSize: 16),
                              ),
                              Text(
                                'Páginas: ${livro.paginas}',
                                style: TextStyle(color: amarelo, fontSize: 16),
                              ),
                              Text(
                                'Disponibilidade: ${livro.disponivel ? "Disponível" : "Indisponível"}',
                                style: TextStyle(
                                  color: livro.disponivel ? azul : magenta,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              color: azul,
                              onPressed: () => _editarLivro(index),
                              tooltip: 'Editar',
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: magenta,
                              onPressed: () => _removerLivro(index),
                              tooltip: 'Remover',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarLivro,
        child: const Icon(Icons.add),
        tooltip: 'Adicionar Livro',
      ),
    );
  }
}

class LivroDialog extends StatefulWidget {
  final Livro? livro;

  LivroDialog({this.livro});

  @override
  State<LivroDialog> createState() => _LivroDialogState();
}

class _LivroDialogState extends State<LivroDialog> {
  final _formKey = GlobalKey<FormState>();
  late String titulo;
  late String autor;
  late int paginas;
  bool disponivel = true;

  @override
  void initState() {
    super.initState();
    titulo = widget.livro?.titulo ?? '';
    autor = widget.livro?.autor ?? '';
    paginas = widget.livro?.paginas ?? 0;
    disponivel = widget.livro?.disponivel ?? true;
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
              SwitchListTile(
                title: Text(
                  'Disponível',
                  style: TextStyle(color: azulEscuro),
                ),
                activeColor: amarelo,
                inactiveThumbColor: magenta,
                value: disponivel,
                onChanged: (value) {
                  setState(() {
                    disponivel = value;
                  });
                },
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
                  disponivel: disponivel,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}

