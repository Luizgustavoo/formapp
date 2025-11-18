class CategoriaAtendimento {
  final int id;
  final int usuarioId;
  final String nome;
  final DateTime dataCadastro;
  final DateTime dataAtualizacao;
  final DateTime? dataExclusao; // Pode ser nulo

  CategoriaAtendimento({
    required this.id,
    required this.usuarioId,
    required this.nome,
    required this.dataCadastro,
    required this.dataAtualizacao,
    this.dataExclusao,
  });

  factory CategoriaAtendimento.fromJson(Map<String, dynamic> json) {
    return CategoriaAtendimento(
      id: json['id'] as int,
      usuarioId: json['usuario_id'] as int,
      nome: json['nome'] as String,
      dataCadastro: DateTime.parse(json['data_cadastro'] as String),
      dataAtualizacao: DateTime.parse(json['data_atualizacao'] as String),
      dataExclusao: json['data_exclusao'] != null
          ? DateTime.tryParse(json['data_exclusao'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'nome': nome,
      'data_cadastro': dataCadastro.toIso8601String(),
      'data_atualizacao': dataAtualizacao.toIso8601String(),
      'data_exclusao': dataExclusao?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoriaAtendimento && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
