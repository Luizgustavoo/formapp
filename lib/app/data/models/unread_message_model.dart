class UnreadMessage {
  int? remetenteId;
  int? pessoaId;
  String? nome;
  String? foto;
  int? naoLida;

  UnreadMessage(
      {this.remetenteId, this.pessoaId, this.nome, this.foto, this.naoLida});

  UnreadMessage.fromJson(Map<String, dynamic> json) {
    remetenteId = json['remetente_id'];
    pessoaId = json['pessoa_id'];
    nome = json['nome'];
    foto = json['foto'];
    naoLida = json['nao_lida'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['remetente_id'] = remetenteId;
    data['pessoa_id'] = pessoaId;
    data['nome'] = nome;
    data['foto'] = foto;
    data['nao_lida'] = naoLida;
    return data;
  }
}
