import 'package:ucif/app/data/models/family_model.dart';
import 'package:ucif/app/data/models/family_service_model.dart';
import 'package:ucif/app/data/models/health_model.dart';
import 'package:ucif/app/data/models/marital_status_model.dart';
import 'package:ucif/app/data/models/medicine_model.dart';
import 'package:ucif/app/data/models/religion_model.dart';
import 'package:ucif/app/data/models/user_model.dart';

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
  String? username;
  String? senha;
  List<FamilyService>? atendimentos;
  List<Health>? acometimentosSaude;
  List<Medicine>? medicamentos;
  User? user;
  Family? family;
  Religion? religion;
  MaritalStatus? maritalStatus;
  bool? peopleLocal = false;
  User? userSistema;
  String? medicamentosOffline;
  String? acometimentosOffline;

  String? estado_civil_name;
  String? usuario_name;
  String? religiao_name;

  People(
      {this.id,
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
      this.religion,
      this.username,
      this.senha,
      this.maritalStatus,
      this.peopleLocal,
      this.family,
      this.userSistema,
      this.acometimentosOffline,
      this.estado_civil_name,
      this.usuario_name,
      this.religiao_name,
      this.medicamentosOffline});

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
    username = json['username'];
    senha = json['senha'];
    dataUpdate = json['data_update'];
    familiaId = json['familia_id'];
    parentesco = json['parentesco'];
    user = json['usuario'] != null ? User.fromJson(json['usuario']) : null;
    userSistema = json['usuario_sistema'] != null
        ? User.fromJson(json['usuario_sistema'])
        : null;
    if (json['atendimentos'] != null) {
      atendimentos = <FamilyService>[];
      json['atendimentos'].forEach((v) {
        atendimentos!.add(FamilyService.fromJson(v));
      });
    }
    if (json['acometimentossaude'] != null) {
      acometimentosSaude = <Health>[];
      json['acometimentossaude'].forEach((v) {
        acometimentosSaude!.add(Health.fromJson(v));
      });
    }
    if (json['medicamentos'] != null) {
      medicamentos = <Medicine>[];
      json['medicamentos'].forEach((v) {
        medicamentos!.add(Medicine.fromJson(v));
      });
    }
    family = json['familia'] != null ? Family.fromJson(json['familia']) : null;
    religion =
        json['religiao'] != null ? Religion.fromJson(json['religiao']) : null;
    maritalStatus = json['estadocivil'] != null
        ? MaritalStatus.fromJson(json['estadocivil'])
        : null;
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
    data['username'] = username;
    data['senha'] = senha;
    data['parentesco'] = parentesco;
    if (atendimentos != null) {
      data['atendimentos'] = atendimentos!.map((v) => v.toJson()).toList();
    }
    if (acometimentosSaude != null) {
      data['acometimentossaude'] =
          acometimentosSaude!.map((v) => v.toJson()).toList();
    }
    if (medicamentos != null) {
      data['medicamentos'] = medicamentos!.map((v) => v.toJson()).toList();
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
      'medicamentosOffline': medicamentosOffline,
      'acometimentosOffline': acometimentosOffline,
      'religiao_name': religiao_name,
      'usuario_name' : usuario_name,
      'estado_civil_name' : estado_civil_name
    };
  }
}
