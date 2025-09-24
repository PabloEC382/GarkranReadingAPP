import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

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

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final prefs = await SharedPreferences.getInstance();
      final completed = prefs.getBool('onboarding_completed') ?? false;
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      if (completed) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    });
  }

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

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool marketingConsent = false;
  bool consentSelected = false;

  final List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      title: 'Bem-vindo ao Garkran Reading APP',
      description: 'Seu sistema de livros digital. Organize, cadastre e gerencie sua leitura de forma prática.',
    ),
    _OnboardingPageData(
      title: 'Como funciona',
      description: 'Cadastre livros, acompanhe seu progresso e tenha sua biblioteca sempre à mão.',
    ),
    _OnboardingPageData(
      title: 'Privacidade e LGPD',
      description: 'Este app respeita sua privacidade. Nenhum dado pessoal é coletado sem seu consentimento.',
    ),
    _OnboardingPageData(
      title: 'Consentimento de Marketing',
      description: 'Você aceita receber comunicações de marketing? Sua escolha pode ser alterada depois.',
      isConsent: true,
    ),
  ];

  void _nextPage() async {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);
      await prefs.setBool('marketing_consent', marketingConsent);
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  void _skipToConsent() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;
    final isFirstPage = _currentPage == 0;
    final isConsentPage = _pages[_currentPage].isConsent;

    return Scaffold(
      backgroundColor: bege,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    if (page.isConsent) {
                      return _buildConsentPage();
                    }
                    return _buildPage(page.title, page.description);
                  },
                ),
              ),
              if (!isLastPage)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (index) => _buildDot(index)),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!isFirstPage && !isLastPage)
                    TextButton(
                      onPressed: _previousPage,
                      child: const Text('Voltar'),
                    )
                  else
                    const SizedBox(width: 64),
                  if (!isLastPage)
                    TextButton(
                      onPressed: _skipToConsent,
                      child: const Text('Pular'),
                    )
                  else
                    const SizedBox(width: 64),
                ],
              ),
              const SizedBox(height: 8),
              if (!isConsentPage)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: azul,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  onPressed: _nextPage,
                  child: Text(_currentPage < _pages.length - 2 ? 'Avançar' : 'Ir para consentimento'),
                ),
              if (isConsentPage)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: azul,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  onPressed: consentSelected ? _nextPage : null,
                  child: const Text('Finalizar'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(String title, String description) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.asset(
            'assets/logo.png',
            width: 120,
            height: 120,
            fit: BoxFit.contain,
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

  Widget _buildConsentPage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.privacy_tip, size: 80, color: Colors.grey),
        const SizedBox(height: 32),
        Text(
          'Consentimento de Marketing',
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
          'Você aceita receber comunicações de marketing? Sua escolha pode ser alterada depois.',
          style: TextStyle(
            color: azul,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChoiceChip(
              label: const Text('Sim'),
              selected: marketingConsent == true && consentSelected,
              onSelected: (selected) {
                setState(() {
                  marketingConsent = true;
                  consentSelected = true;
                });
              },
            ),
            const SizedBox(width: 16),
            ChoiceChip(
              label: const Text('Não'),
              selected: marketingConsent == false && consentSelected,
              onSelected: (selected) {
                setState(() {
                  marketingConsent = false;
                  consentSelected = true;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 16 : 12,
      height: 12,
      decoration: BoxDecoration(
        color: _currentPage == index ? azul : amarelo,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

class _OnboardingPageData {
  final String title;
  final String description;
  final bool isConsent;
  const _OnboardingPageData({
    required this.title,
    required this.description,
    this.isConsent = false,
  });
}

class LivroCrudScreen extends StatefulWidget {
  const LivroCrudScreen({super.key});

  @override
  State<LivroCrudScreen> createState() => _LivroCrudScreenState();
}

class _LivroCrudScreenState extends State<LivroCrudScreen> {
  List<Livro> livros = [];

  @override
  void initState() {
    super.initState();
    _carregarLivros();
  }

  Future<void> _carregarLivros() async {
    final prefs = await SharedPreferences.getInstance();
    final livrosJson = prefs.getString('livros');
    if (livrosJson != null) {
      final List<dynamic> decoded = jsonDecode(livrosJson);
      setState(() {
        livros = decoded.map((e) => Livro.fromJson(e)).toList();
      });
    }
  }

  Future<void> _salvarLivros() async {
    final prefs = await SharedPreferences.getInstance();
    final livrosJson = jsonEncode(livros.map((e) => e.toJson()).toList());
    await prefs.setString('livros', livrosJson);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        backgroundColor: azul,
        foregroundColor: Colors.white,
      ),
      backgroundColor: bege,
      body: livros.isEmpty
          ? const Center(child: Text('Nenhum livro cadastrado.'))
          : ListView.builder(
              itemCount: livros.length,
              itemBuilder: (context, index) {
                final livro = livros[index];
                Widget leadingWidget;
                if (kIsWeb) {
                  leadingWidget = ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/logo.png',
                      width: 48,
                      height: 48,
                      fit: BoxFit.contain,
                    ),
                  );
                } else if (livro.capaPath != null && livro.capaPath!.isNotEmpty) {
                  leadingWidget = ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(livro.capaPath!),
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.book, size: 40),
                    ),
                  );
                } else {
                  leadingWidget = const Icon(Icons.book, size: 40);
                }
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: leadingWidget,
                    title: Text(livro.titulo),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(livro.autor),
                        Text('Status: ${livro.status}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (livro.notas != null && livro.notas!.trim().isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.sticky_note_2, color: Colors.amber),
                            tooltip: 'Ver notas',
                            onPressed: () => _mostrarNotas(context, livro.notas!),
                          ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editarLivro(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removerLivro(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarLivro,
        backgroundColor: azul,
        child: const Icon(Icons.add, color: Colors.white),
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
}

class LivroDialog extends StatefulWidget {
  final Livro? livro;
  LivroDialog({this.livro});

  @override
  State<LivroDialog> createState() => _LivroDialogState();
}

class _LivroDialogState extends State<LivroDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tituloController;
  late TextEditingController _autorController;
  late TextEditingController _notasController;
  String? _capaPath;
  String _status = 'Não iniciado';
  final List<String> _statusOptions = ['Não iniciado', 'Lendo', 'Concluído'];

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.livro?.titulo ?? '');
    _autorController = TextEditingController(text: widget.livro?.autor ?? '');
    _notasController = TextEditingController(text: widget.livro?.notas ?? '');
    _capaPath = widget.livro?.capaPath;
    _status = widget.livro?.status ?? 'Não iniciado';
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (kIsWeb) return; // Não permite upload no web
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _capaPath = picked.path;
      });
    }
  }

  Widget _buildCapaWidget() {
    if (kIsWeb) {
      // No web, sempre mostra a logo padrão
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/logo.png',
          width: 100,
          height: 100,
          fit: BoxFit.contain,
        ),
      );
    } else if (_capaPath != null && _capaPath!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          File(_capaPath!),
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.book, size: 60),
        ),
      );
    } else {
      return Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.livro == null ? 'Adicionar Livro' : 'Editar Livro'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: kIsWeb ? null : _pickImage,
                child: _buildCapaWidget(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o título' : null,
              ),
              TextFormField(
                controller: _autorController,
                decoration: const InputDecoration(labelText: 'Autor'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o autor' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                items: _statusOptions
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _status = value;
                    });
                  }
                },
                decoration: const InputDecoration(labelText: 'Status de leitura'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notasController,
                decoration: const InputDecoration(labelText: 'Notas/Comentários'),
                minLines: 2,
                maxLines: 5,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final livro = Livro(
                titulo: _tituloController.text,
                autor: _autorController.text,
                capaPath: kIsWeb ? null : _capaPath,
                status: _status,
                notas: _notasController.text,
              );
              Navigator.of(context).pop(livro);
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}

class Livro {
  final String titulo;
  final String autor;
  final String? capaPath;
  final String status;
  final String? notas;
  Livro({required this.titulo, required this.autor, this.capaPath, this.status = 'Não iniciado', this.notas});

  Map<String, dynamic> toJson() => {
    'titulo': titulo,
    'autor': autor,
    'capaPath': capaPath,
    'status': status,
    'notas': notas,
  };

  factory Livro.fromJson(Map<String, dynamic> json) => Livro(
    titulo: json['titulo'] ?? '',
    autor: json['autor'] ?? '',
    capaPath: json['capaPath'],
    status: json['status'] ?? 'Não iniciado',
    notas: json['notas'],
  );
}

