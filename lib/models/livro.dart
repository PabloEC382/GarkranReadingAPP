class Livro {
  final String titulo;
  final String autor;
  final String? capaPath;
  final String status;
  final String? notas;

  Livro({
    required this.titulo,
    required this.autor,
    this.capaPath,
    this.status = 'Não iniciado',
    this.notas,
  });

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