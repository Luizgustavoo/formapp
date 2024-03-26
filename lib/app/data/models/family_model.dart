import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/data/models/user_model.dart';

class Family {
  int? id;
  String? nome;
  String? endereco;
  String? numeroCasa;
  String? bairro;
  String? cidade;
  String? uf;
  String? complemento;
  String? residenciaPropria;
  int? usuarioId;
  int? status;
  String? dataCadastro;
  String? dataUpdate;
  String? cep;
  User? user;
  List<People>? pessoas;
  bool? familyLocal = false;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Family &&
          runtimeType == other.runtimeType &&
          id == other.id; // Adicione outros atributos se necessário

  @override
  int get hashCode => id.hashCode; // Use outros atributos se necessário

  Family(
      {this.id,
      this.nome,
      this.endereco,
      this.numeroCasa,
      this.bairro,
      this.cidade,
      this.uf,
      this.complemento,
      this.residenciaPropria,
      this.usuarioId,
      this.status,
      this.dataCadastro,
      this.dataUpdate,
      this.cep,
      this.user,
      this.pessoas});

  Family.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    nome = json['nome'];
    endereco = json['endereco'];
    numeroCasa = json['numero_casa'];
    bairro = json['bairro'];
    cidade = json['cidade'];
    uf = json['uf'];
    complemento = json['complemento'];
    residenciaPropria = json['residencia_propria'];
    usuarioId = json['usuario_id'] as int;
    status = json['status'] as int;
    dataCadastro = json['data_cadastro'];
    dataUpdate = json['data_update'];
    cep = json['cep'];
    user = json['usuario'] != null ? User.fromJson(json['usuario']) : null;
    if (json['pessoas'] != null) {
      pessoas = <People>[];
      json['pessoas'].forEach((v) {
        pessoas!.add(People.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nome'] = nome;
    data['endereco'] = endereco;
    data['numero_casa'] = numeroCasa;
    data['bairro'] = bairro;
    data['cidade'] = cidade;
    data['uf'] = uf;
    data['complemento'] = complemento;
    data['residencia_propria'] = residenciaPropria;
    data['usuario_id'] = usuarioId;
    data['status'] = status;
    data['data_cadastro'] = dataCadastro;
    data['data_update'] = dataUpdate;
    data['cep'] = cep;
    if (user != null) {
      data['usuario'] = user!.toJson();
    }
    if (pessoas != null) {
      data['pessoas'] = pessoas!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'endereco': endereco,
      'numero_casa': numeroCasa,
      'bairro': bairro,
      'cidade': cidade,
      'uf': uf,
      'complemento': complemento,
      'residencia_propria': residenciaPropria,
      'usuario_id': usuarioId,
      'status': status,
      'data_cadastro': dataCadastro,
      'data_update': dataUpdate,
      'cep': cep,
    };
  }
}
