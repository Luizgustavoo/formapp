class Chat {
  int? id;
  String? mensagem;
  int? remetenteId;
  int? destinatarioId;
  String? dataCadastro;
  String? dataUpdate;
  String? lida;

  Chat(
      {this.id,
      this.mensagem,
      this.remetenteId,
      this.destinatarioId,
      this.dataCadastro,
      this.dataUpdate,
      this.lida});

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mensagem = json['mensagem'];
    remetenteId = json['remetente_id'];
    destinatarioId = json['destinatario_id'];
    dataCadastro = json['data_cadastro'];
    dataUpdate = json['data_update'];
    lida = json['lida'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mensagem'] = mensagem;
    data['remetente_id'] = remetenteId;
    data['destinatario_id'] = destinatarioId;
    data['data_cadastro'] = dataCadastro;
    data['data_update'] = dataUpdate;
    data['lida'] = lida;
    return data;
  }
}
