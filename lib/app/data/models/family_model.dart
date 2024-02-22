import 'package:formapp/app/data/models/people_model.dart';
import 'package:formapp/app/data/models/user_model.dart';

class Family {
  int? id;
  String? nome;
  String? endereco;
  String? numero_casa;
  String? bairro;
  String? cidade;
  String? uf;
  String? complemento;
  String? residencia_propria;
  int? usuario_id;
  int? status;
  String? data_cadastro;
  String? data_update;
  String? cep;
  User? user;
  List<People>? pessoas;
  bool? familyLocal;

  Family(
      {this.id,
      this.nome,
      this.endereco,
      this.numero_casa,
      this.bairro,
      this.cidade,
      this.uf,
      this.complemento,
      this.residencia_propria,
      this.usuario_id,
      this.status,
      this.data_cadastro,
      this.data_update,
      this.cep,
      this.user,
      this.pessoas});

  Family.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    nome = json['nome'];
    endereco = json['endereco'];
    numero_casa = json['numero_casa'];
    bairro = json['bairro'];
    cidade = json['cidade'];
    uf = json['uf'];
    complemento = json['complemento'];
    residencia_propria = json['residencia_propria'];
    usuario_id = json['usuario_id'] as int;
    status = json['status'] as int;
    data_cadastro = json['data_cadastro'];
    data_update = json['data_update'];
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
    data['numero_casa'] = numero_casa;
    data['bairro'] = bairro;
    data['cidade'] = cidade;
    data['uf'] = uf;
    data['complemento'] = complemento;
    data['residencia_propria'] = residencia_propria;
    data['usuario_id'] = usuario_id;
    data['status'] = status;
    data['data_cadastro'] = data_cadastro;
    data['data_update'] = data_update;
    data['cep'] = cep;
    if (user != null) {
      data['usuario'] = user!.toJson();
    }
    if (pessoas != null) {
      data['pessoas'] = pessoas!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
