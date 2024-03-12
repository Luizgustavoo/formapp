class FamilyService {
  int? id;
  String? dataAtendimento;
  String? assunto;
  String? descricao;
  int? usuarioId;
  String? dataCadastro;
  String? dataUpdate;
  int? pessoaId;

  FamilyService({
    this.id,
    this.dataAtendimento,
    this.assunto,
    this.descricao,
    this.usuarioId,
    this.dataCadastro,
    this.dataUpdate,
    this.pessoaId,
  });

  FamilyService.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dataAtendimento = json['data_atendimento'];
    assunto = json['assunto'];
    descricao = json['descricao'];
    usuarioId = json['usuario_id'];
    dataCadastro = json['data_cadastro'];
    dataUpdate = json['data_update'];
    pessoaId = json['pessoa_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['data_atendimento'] = dataAtendimento;
    data['assunto'] = assunto;
    data['descricao'] = descricao;
    data['usuario_id'] = usuarioId;
    data['data_cadastro'] = dataCadastro;
    data['data_update'] = dataUpdate;
    data['pessoa_id'] = pessoaId;
    return data;
  }
}
