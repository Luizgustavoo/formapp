import 'package:formapp/app/data/models/user_model.dart';

class EstadoCivil {
  int? id;
  String? descricao;
  int? usuarioId;
  int? status;
  String? dataCadastro;
  String? dataUpdate;
  User? user;

  EstadoCivil(
      {this.id,
      this.descricao,
      this.usuarioId,
      this.status,
      this.dataCadastro,
      this.dataUpdate,
      this.user});

  EstadoCivil.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    usuarioId = json['usuario_id'];
    status = json['status'];
    dataCadastro = json['data_cadastro'];
    dataUpdate = json['data_update'];
    user = json['usuario'] != null ? User.fromJson(json['usuario']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['descricao'] = descricao;
    data['usuario_id'] = usuarioId;
    data['status'] = status;
    data['data_cadastro'] = dataCadastro;
    data['data_update'] = dataUpdate;
    if (user != null) {
      data['usuario'] = user!.toJson();
    }
    return data;
  }
}
