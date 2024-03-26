import 'package:ucif/app/data/models/family_model.dart';

class User {
  int? id;
  String? nome;
  String? username;
  int? tipousuarioId;
  int? status;
  String? dataCadastro;
  String? dataUpdate;
  String? senha;
  int? usuarioId;
  User? user;
  String? tokenFirebase;
  dynamic familiaId;
  Family? family;
  dynamic foto;

  User({
    this.id,
    this.nome,
    this.username,
    this.tipousuarioId,
    this.status,
    this.dataCadastro,
    this.dataUpdate,
    this.user,
    this.usuarioId,
    this.senha,
    this.tokenFirebase,
    this.familiaId,
    this.family,
    this.foto,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    username = json['username'];
    tipousuarioId = json['tipousuario_id'];
    status = json['status'];
    dataCadastro = json['data_cadastro'];
    dataUpdate = json['data_update'];
    senha = json['senha'];
    tokenFirebase = json['token_firebase'];
    usuarioId = json['usuario_id'] as int;
    user = json['usuario'] != null ? User.fromJson(json['usuario']) : null;
    familiaId = json['familia_id'] as dynamic;
    family = json['familia'] != null ? Family.fromJson(json['familia']) : null;
    foto = json['foto'];
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
    data['senha'] = senha;
    data['token_firebase'] = tokenFirebase;
    data['usuario_id'] = usuarioId;
    if (user != null) {
      data['usuario'] = user!.toJson();
    }
    data['familia_id'] = familiaId;
    data['foto'] = foto;
    return data;
  }
}
