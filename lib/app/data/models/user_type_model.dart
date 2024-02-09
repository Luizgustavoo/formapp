class TipoUsuario {
  int? id;
  String? descricao;
  int? status;
  String? dataCadastro;
  String? dataUpdate;

  TipoUsuario(
      {this.id,
      this.descricao,
      this.status,
      this.dataCadastro,
      this.dataUpdate});

  TipoUsuario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    status = json['status'];
    dataCadastro = json['data_cadastro'];
    dataUpdate = json['data_update'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['descricao'] = descricao;
    data['status'] = status;
    data['data_cadastro'] = dataCadastro;
    data['data_update'] = dataUpdate;
    return data;
  }
}
