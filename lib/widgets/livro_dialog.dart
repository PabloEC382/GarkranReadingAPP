import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/livro.dart';

const Color azulProfundo = Color(0xFF1A2439);
const Color azulAcinzentado = Color(0xFF2F4A6A);
const Color azulSuave = Color(0xFF4A6FA5);
const Color branco = Colors.white;

const List<String> generosDisponiveis = [
  'Ação',
  'Terror',
  'SCI-FI',
  'Filosofia',
  'Aventura',
];

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
  final List<String> generos = [
    'Ação',
    'Terror',
    'SCI-FI',
    'Filosofia',
    'Aventura',
  ];

  String? _generoSelecionado;

  TextEditingController _folhasController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.livro?.titulo ?? '');
    _autorController = TextEditingController(text: widget.livro?.autor ?? '');
    _notasController = TextEditingController(text: widget.livro?.notas ?? '');
    _capaPath = widget.livro?.capaPath;
    _status = widget.livro?.status ?? 'Não iniciado';
    _generoSelecionado = widget.livro?.genero; // Se estiver editando
    if (widget.livro != null) {
      _folhasController.text = widget.livro!.quantidadeFolhas.toString();
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _autorController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    if (kIsWeb) return;
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
      return const Icon(Icons.book, size: 64);
    }
    if (_capaPath != null && _capaPath!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(_capaPath!),
          width: 64,
          height: 64,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.book, size: 64),
        ),
      );
    }
    return const Icon(Icons.book, size: 64);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: azulProfundo,
      title: Text(
        widget.livro == null ? 'Adicionar Livro' : 'Editar Livro',
        style: const TextStyle(color: branco),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _buildCapaWidget(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tituloController,
                style: const TextStyle(color: branco),
                decoration: const InputDecoration(
                  labelText: 'Título',
                  labelStyle: TextStyle(color: branco),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: azulAcinzentado),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: azulSuave),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Informe o título' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _autorController,
                style: const TextStyle(color: branco),
                decoration: const InputDecoration(
                  labelText: 'Autor',
                  labelStyle: TextStyle(color: branco),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: azulAcinzentado),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: azulSuave),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Informe o autor' : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _status,
                dropdownColor: azulProfundo,
                style: const TextStyle(color: branco),
                items: _statusOptions
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status, style: const TextStyle(color: branco)),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _status = value);
                },
                decoration: const InputDecoration(
                  labelText: 'Status',
                  labelStyle: TextStyle(color: branco),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: azulAcinzentado),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: azulSuave),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _generoSelecionado,
                decoration: const InputDecoration(labelText: 'Gênero'),
                items: generosDisponiveis
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _generoSelecionado = value;
                  });
                },
                validator: (value) => value == null ? 'Selecione um gênero' : null,
              ),
              TextFormField(
                controller: _folhasController,
                decoration: const InputDecoration(labelText: 'Quantidade de folhas'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe a quantidade de folhas';
                  if (int.tryParse(value) == null) return 'Digite um número válido';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notasController,
                style: const TextStyle(color: branco),
                decoration: const InputDecoration(
                  labelText: 'Notas',
                  labelStyle: TextStyle(color: branco),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: azulAcinzentado),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: azulSuave),
                  ),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: azulSuave,
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: azulSuave,
            foregroundColor: branco,
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final novoLivro = Livro(
                id: widget.livro?.id ?? UniqueKey().toString(),
                titulo: _tituloController.text,
                autor: _autorController.text,
                genero: _generoSelecionado!,
                quantidadeFolhas: int.parse(_folhasController.text),
                notas: _notasController.text,
                capaPath: _capaPath,
                status: _status,
              );
              Navigator.of(context).pop(novoLivro);
            }
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}