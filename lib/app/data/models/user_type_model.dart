class TipoUsuario {
  int? id;
  String? descricao;
  int? status;
  String? cada_cadastro;
  String? data_update;

  TipoUsuario(
      {this.id,
      this.descricao,
      this.status,
      this.cada_cadastro,
      this.data_update});

  TipoUsuario.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    status = json['status'];
    cada_cadastro = json['data_cadastro'];
    data_update = json['data_update'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['descricao'] = descricao;
    data['status'] = status;
    data['data_cadastro'] = cada_cadastro;
    data['data_update'] = data_update;
    return data;
  }
}
