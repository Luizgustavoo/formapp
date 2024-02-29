class User {
  int? id;
  String? nome;
  String? username;
  int? tipousuarioId;
  int? status;
  String? dataCadastro;
  String? dataUpdate;
  String? password;
  int? usuarioId;
  User? user;

  User(
      {this.id,
      this.nome,
      this.username,
      this.tipousuarioId,
      this.status,
      this.dataCadastro,
      this.dataUpdate,
      this.user,
      this.usuarioId,
      this.password});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    username = json['username'];
    tipousuarioId = json['tipousuario_id'];
    status = json['status'];
    dataCadastro = json['data_cadastro'];
    dataUpdate = json['data_update'];
    password = json['password'];
    usuarioId = json['usuario_id'] as int;
    user = json['usuario'] != null ? User.fromJson(json['usuario']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nome'] = nome;
    data['username'] = username;
    data['tipousuario_id'] = tipousuarioId;
    data['status'] = status;
    data['data_cadastro'] = dataCadastro;
    data['data_update'] = dataUpdate;
    data['password'] = password;
    data['usuario_id'] = usuarioId;
    if (user != null) {
      data['usuario'] = user!.toJson();
    }
    return data;
  }
}
