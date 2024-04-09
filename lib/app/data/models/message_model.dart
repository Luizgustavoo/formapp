class Message {
  int? id;
  String? titulo;
  String? descricao;
  int? usuarioId;
  String? dataCadastro;
  String? dataUpdate;
  String? lida;
  int? remetenteId;
  String? remetenteNome;
  int? destinatario;
  String? solicitacao;

  Message(
      {this.id,
      this.titulo,
      this.descricao,
      this.usuarioId,
      this.dataCadastro,
      this.dataUpdate,
      this.remetenteId,
      this.remetenteNome,
      this.destinatario,
      this.solicitacao});

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'];
    descricao = json['descricao'];
    usuarioId = json['usuario_id'];
    dataCadastro = json['data_cadastro'];
    dataUpdate = json['data_update'];
    lida = json['lida'];
    remetenteId = json['remetente_id'];
    remetenteNome = json['remetente_nome'];
    destinatario = json['destinatario'];
    solicitacao = json['solicitacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['titulo'] = titulo;
    data['descricao'] = descricao;
    data['usuario_id'] = usuarioId;
    data['data_cadastro'] = dataCadastro;
    data['data_update'] = dataUpdate;
    data['lida'] = lida;
    data['remetente_id'] = remetenteId;
    data['remetente_nome'] = remetenteNome;
    data['destinatario'] = destinatario;
    data['solicitacao'] = solicitacao;
    return data;
  }
}
