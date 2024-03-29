import 'package:formapp/app/data/models/family_service_model.dart';
import 'package:formapp/app/data/models/user_model.dart';

class People {
  int? id;
  String? nome;
  dynamic foto;
  String? sexo;
  String? cpf;
  String? dataNascimento;
  int? estadoCivilId;
  String? tituloEleitor;
  String? zonaEleitoral;
  String? telefone;
  String? redeSocial;
  String? provedorCasa;
  dynamic igrejaId;
  String? localTrabalho;
  String? cargoTrabalho;
  int? religiaoId;
  String? funcaoIgreja;
  int? usuarioId;
  int? status;
  String? dataCadastro;
  String? dataUpdate;
  int? familiaId;
  String? parentesco;
  List<FamilyService>? atendimentos;
  User? user;

  People({
    this.id,
    this.nome,
    this.foto,
    this.sexo,
    this.cpf,
    this.dataNascimento,
    this.estadoCivilId,
    this.tituloEleitor,
    this.zonaEleitoral,
    this.telefone,
    this.redeSocial,
    this.provedorCasa,
    this.igrejaId,
    this.localTrabalho,
    this.cargoTrabalho,
    this.religiaoId,
    this.funcaoIgreja,
    this.usuarioId,
    this.status,
    this.dataCadastro,
    this.dataUpdate,
    this.familiaId,
    this.parentesco,
    this.atendimentos,
    this.user,
  });

  People.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    foto = json['foto'];
    sexo = json['sexo'];
    cpf = json['cpf'];
    dataNascimento = json['data_nascimento'];
    estadoCivilId = json['estadocivil_id'];
    tituloEleitor = json['titulo_eleitor'];
    zonaEleitoral = json['zona_eleitoral'];
    telefone = json['telefone'];
    redeSocial = json['rede_social'];
    provedorCasa = json['provedor_casa'];
    igrejaId = json['igreja_id'];
    localTrabalho = json['local_trabalho'];
    cargoTrabalho = json['cargo_trabalho'];
    religiaoId = json['religiao_id'];
    funcaoIgreja = json['funcao_igreja'];
    usuarioId = json['usuario_id'];
    status = json['status'];
    dataCadastro = json['data_cadastro'];
    dataUpdate = json['data_update'];
    familiaId = json['familia_id'];
    parentesco = json['parentesco'];
    user = json['usuario'] != null ? User.fromJson(json['usuario']) : null;
    if (json['atendimentos'] != null) {
      atendimentos = <FamilyService>[];
      json['atendimentos'].forEach((v) {
        atendimentos!.add(FamilyService.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nome'] = nome;
    data['foto'] = foto;
    data['sexo'] = sexo;
    data['cpf'] = cpf;
    data['data_nascimento'] = dataNascimento;
    data['estadocivil_id'] = estadoCivilId;
    data['titulo_eleitor'] = tituloEleitor;
    data['zona_eleitoral'] = zonaEleitoral;
    data['telefone'] = telefone;
    data['rede_social'] = redeSocial;
    data['provedor_casa'] = provedorCasa;
    data['igreja_id'] = igrejaId as String;
    data['local_trabalho'] = localTrabalho;
    data['cargo_trabalho'] = cargoTrabalho;
    data['religiao_id'] = religiaoId;
    data['funcao_igreja'] = funcaoIgreja;
    data['usuario_id'] = usuarioId;
    data['status'] = status;
    data['data_cadastro'] = dataCadastro;
    data['data_update'] = dataUpdate;
    data['familia_id'] = familiaId;
    data['parentesco'] = parentesco;
    if (atendimentos != null) {
      data['atendimentos'] = atendimentos!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'foto': foto,
      'sexo': sexo,
      'cpf': cpf,
      'data_nascimento': dataNascimento,
      'estadocivil_id': estadoCivilId,
      'titulo_eleitor': tituloEleitor,
      'zona_eleitoral': zonaEleitoral,
      'telefone': telefone,
      'rede_social': redeSocial,
      'provedor_casa': provedorCasa,
      'igreja_id': igrejaId as String,
      'local_trabalho': localTrabalho,
      'cargo_trabalho': cargoTrabalho,
      'religiao_id': religiaoId,
      'funcao_igreja': funcaoIgreja,
      'usuario_id': usuarioId,
      'status': status,
      'data_cadastro': dataCadastro,
      'data_update': dataUpdate,
      'familia_id': familiaId,
      'parentesco': parentesco,
    };
  }
}
