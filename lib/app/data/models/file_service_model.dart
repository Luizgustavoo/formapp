class ArquivoAtendimento {
  final int id;
  final String nomeOriginal;
  final String? nomeArmazenado;
  final String? caminho;
  final String? tipoMime;
  final String? extensao;
  final int? tamanhoBytes;
  final String url; // 👈 URL protegida da API

  ArquivoAtendimento({
    required this.id,
    required this.nomeOriginal,
    this.nomeArmazenado,
    this.caminho,
    this.tipoMime,
    this.extensao,
    this.tamanhoBytes,
    required this.url,
  });

  factory ArquivoAtendimento.fromJson(Map<String, dynamic> json) {
    return ArquivoAtendimento(
      id: json['id'],
      nomeOriginal: json['nome_original'],
      nomeArmazenado: json['nome_armazenado'],
      caminho: json['caminho'],
      tipoMime: json['tipo_mime'],
      extensao: json['extensao'],
      tamanhoBytes: json['tamanho_bytes'],
      url: json['url'], // 👈 vem do accessor do Laravel
    );
  }
}
