import 'dart:convert';

class User {
  int? id;
  String? nome;
  String? username;
  int? tipousuarioId;
  int? status;
  String? dataCadastro;
  String? dataUpdate;
  String? rememberToken;
  User({
    this.id,
    this.nome,
    this.username,
    this.tipousuarioId,
    this.status,
    this.dataCadastro,
    this.dataUpdate,
    this.rememberToken,
  });

  @override
  String toString() {
    return 'User(id: $id, nome: $nome, username: $username, tipousuarioId: $tipousuarioId, status: $status, dataCadastro: $dataCadastro, dataUpdate: $dataUpdate, rememberToken: $rememberToken)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'username': username,
      'tipousuario_id': tipousuarioId,
      'status': status,
      'data_cadastro': dataCadastro,
      'data_update': dataUpdate,
      'remember_token': rememberToken,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] != null ? map['id'] as int : null,
      nome: map['nome'] != null ? map['nome'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      tipousuarioId:
          map['tipousuario_id'] != null ? map['tipousuario_id'] as int : null,
      status: map['status'] != null ? map['status'] as int : null,
      dataCadastro:
          map['data_cadastro'] != null ? map['data_cadastro'] as String : null,
      dataUpdate:
          map['data_update'] != null ? map['data_update'] as String : null,
      rememberToken: map['remember_token'] != null
          ? map['remember_token'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
