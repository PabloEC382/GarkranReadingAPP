import 'package:flutter/material.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.ease);
    } else {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bege,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    _buildPage(
                      title: 'Bem-vindo ao Garkran Reading APP',
                      description: 'Seu sistema de livros digital. Organize, cadastre e gerencie sua leitura de forma prática.',
                      image: 'assets/logo.png',
                    ),
                    _buildPage(
                      title: 'LGPD Introdutório',
                      description: 'Este app não coleta nem armazena dados pessoais. Sua privacidade é respeitada desde o início.',
                      image: 'assets/branding.png',
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (index) => _buildDot(index)),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: azul,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: _nextPage,
                child: Text(_currentPage < 1 ? 'Próximo' : 'Começar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage({required String title, required String description, required String image}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.asset(
            image,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          title,
          style: TextStyle(
            color: azulEscuro,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: 16),
        Text(
          description,
          style: TextStyle(
            color: azul,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
      ],
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: _currentPage == index ? azul : amarelo,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}


const Color azulEscuro = Color(0xFF070743);
const Color azul = Color(0xFF169D99);
const Color amarelo = Color(0xFFB9CC01);
const Color bege = Color(0xFFFAE894);
const Color magenta = Color(0xFFAB0768);




void main() {
  runApp(const MyApp());
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: azulEscuro,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Image.asset(
                  'assets/logo.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(
                color: amarelo,
              ),
            ],
          ),
        ),
      ),
    );
  }
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
          'Catálogo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
          softWrap: true,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: livros.isEmpty
                  ? Text(
                      'Nenhum livro cadastrado.',
                      style: TextStyle(
                        color: azulEscuro,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    )
                  : SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: livros.length,
                        itemBuilder: (context, index) {
                          final livro = livros[index];
                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: bege,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  title: Text(
                                    livro.titulo,
                                    style: TextStyle(
                                      color: azulEscuro,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Autor: ${livro.autor}', style: TextStyle(color: azul, fontSize: 16)),
                                      Text('Páginas: ${livro.paginas}', style: TextStyle(color: amarelo, fontSize: 16)),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('Fechar', style: TextStyle(color: magenta)),
                                      onPressed: () => Navigator.of(context).pop(),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.white,
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(color: amarelo, width: 2),
                              ),
                              child: Container(
                                width: 140,
                                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        'assets/logo.png',
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      livro.titulo,
                                      style: TextStyle(
                                        color: azulEscuro,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.center,
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarLivro,
        tooltip: 'Adicionar Livro',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          'Este aplicativo respeita a LGPD: nenhum dado pessoal é coletado ou armazenado. Sua privacidade é garantida.',
          style: TextStyle(color: azulEscuro, fontSize: 13),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
      ),
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
                activeThumbColor: amarelo,
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

