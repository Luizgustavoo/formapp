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
      this.parentesco});

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
    return data;
  }
}
