class Livro {
  String id;
  String titulo;
  String autor;
  String genero;
  int quantidadeFolhas;
  String? notas;
  String? capaPath;
  String status;

  Livro({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.genero,
    required this.quantidadeFolhas,
    this.notas,
    this.capaPath,
    this.status = 'Não iniciado',
  });

  factory Livro.fromJson(Map<String, dynamic> json) => Livro(
    id: json['id'] ?? '',
    titulo: json['titulo'] ?? '',
    autor: json['autor'] ?? '',
    genero: json['genero'] ?? '',
    quantidadeFolhas: (json['quantidadeFolhas'] is int)
        ? json['quantidadeFolhas']
        : int.tryParse(json['quantidadeFolhas']?.toString() ?? '0') ?? 0,
    notas: json['notas'],
    capaPath: json['capaPath'],
  );


  Map<String, dynamic> toJson() => {
        'id': id,
        'titulo': titulo,
        'autor': autor,
        'genero': genero,
        'quantidadeFolhas': quantidadeFolhas,
        'notas': notas,
        'capaPath': capaPath,
        'status': status,
      };
}
