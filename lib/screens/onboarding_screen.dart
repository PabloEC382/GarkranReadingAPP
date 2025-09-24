import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color bege = Color(0xFFFAE894);
const Color azulEscuro = Color(0xFF070743);
const Color amarelo = Color(0xFFB9CC01);
const Color azulPreto = Color(0xFF1A1A2E);
const Color azulSuave = Color(0xFF162447);
const Color branco = Color(0xFFFFFFFF);

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
      backgroundColor: azulPreto,
      body: SafeArea(
        child: Column(
          children: [
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => _buildDot(index),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!isFirstPage)
                    TextButton(
                      onPressed: _previousPage,
                      child: const Text('Voltar'),
                    )
                  else
                    const SizedBox(width: 70),
                  if (!isLastPage)
                    TextButton(
                      onPressed: _skipToConsent,
                      child: const Text('Pular'),
                    )
                  else
                    const SizedBox(width: 70),
                  ElevatedButton(
                    onPressed: isConsentPage
                        ? (consentSelected ? _nextPage : null)
                        : _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: azulSuave,
                      foregroundColor: branco,
                    ),
                    child: Text(isLastPage ? 'Finalizar' : 'Avançar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: branco,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            description,
            style: const TextStyle(fontSize: 18, color: branco),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildConsentPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Consentimento de Marketing',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: branco,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          const Text(
            'Você aceita receber comunicações de marketing? Sua escolha pode ser alterada depois.',
            style: TextStyle(fontSize: 18, color: branco),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text('Sim'),
                selected: marketingConsent,
                onSelected: (selected) {
                  setState(() {
                    marketingConsent = true;
                    consentSelected = true;
                  });
                },
                selectedColor: azulSuave,
                labelStyle: TextStyle(
                  color: branco,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              ChoiceChip(
                label: const Text('Não'),
                selected: !marketingConsent && consentSelected,
                onSelected: (selected) {
                  setState(() {
                    marketingConsent = false;
                    consentSelected = true;
                  });
                },
                selectedColor: azulSuave,
                labelStyle: TextStyle(
                  color: branco,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentPage == index ? 16 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? azulEscuro : Colors.grey,
        borderRadius: BorderRadius.circular(4),
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