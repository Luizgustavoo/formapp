class Message {
  int? id;
  String? data;
  String? titulo;
  String? descricao;
  int? usuarioId;
  String? dataCadastro;
  String? dataUpdate;
  String? lida;

  Message({
    this.id,
    this.data,
    this.titulo,
    this.descricao,
    this.usuarioId,
    this.dataCadastro,
    this.dataUpdate,
  });

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    data = json['data'];
    titulo = json['titulo'];
    descricao = json['descricao'];
    usuarioId = json['usuario_id'];
    dataCadastro = json['data_cadastro'];
    dataUpdate = json['data_update'];
    lida = json['lida'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['data'] = data;
    data['titulo'] = titulo;
    data['descricao'] = descricao;
    data['usuario_id'] = usuarioId;
    data['data_cadastro'] = dataCadastro;
    data['data_update'] = dataUpdate;
    data['lida'] = lida;
    return data;
  }
}
