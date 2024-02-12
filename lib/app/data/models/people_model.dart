class Pessoas {
  int? id;
  String? nome;
  String? foto;
  String? sexo;
  String? cpf;
  String? data_nascimento;
  int? estadocivil_id;
  String? titulo_eleitor;
  String? zona_eleitoral;
  String? telefone;
  String? rede_social;
  String? provedor_casa;
  dynamic igreja_id;
  String? local_trabalho;
  String? cargo_trabalho;
  int? religiao_id;
  String? funcao_igreja;
  int? usuario_id;
  int? status;
  String? data_cadastro;
  String? data_update;
  int? familia_id;
  String? parentesco;

  Pessoas(
      {this.id,
      this.nome,
      this.foto,
      this.sexo,
      this.cpf,
      this.data_nascimento,
      this.estadocivil_id,
      this.titulo_eleitor,
      this.zona_eleitoral,
      this.telefone,
      this.rede_social,
      this.provedor_casa,
      this.igreja_id,
      this.local_trabalho,
      this.cargo_trabalho,
      this.religiao_id,
      this.funcao_igreja,
      this.usuario_id,
      this.status,
      this.data_cadastro,
      this.data_update,
      this.familia_id,
      this.parentesco});

  Pessoas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    foto = json['foto'];
    sexo = json['sexo'];
    cpf = json['cpf'];
    data_nascimento = json['data_nascimento'];
    estadocivil_id = json['estadocivil_id'];
    titulo_eleitor = json['titulo_eleitor'];
    zona_eleitoral = json['zona_eleitoral'];
    telefone = json['telefone'];
    rede_social = json['rede_social'];
    provedor_casa = json['provedor_casa'];
    igreja_id = json['igreja_id'];
    local_trabalho = json['local_trabalho'];
    cargo_trabalho = json['cargo_trabalho'];
    religiao_id = json['religiao_id'];
    funcao_igreja = json['funcao_igreja'];
    usuario_id = json['usuario_id'];
    status = json['status'];
    data_cadastro = json['data_cadastro'];
    data_update = json['data_update'];
    familia_id = json['familia_id'];
    parentesco = json['parentesco'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nome'] = nome;
    data['foto'] = foto;
    data['sexo'] = sexo;
    data['cpf'] = cpf;
    data['data_nascimento'] = data_nascimento;
    data['estadocivil_id'] = estadocivil_id;
    data['titulo_eleitor'] = titulo_eleitor;
    data['zona_eleitoral'] = zona_eleitoral;
    data['telefone'] = telefone;
    data['rede_social'] = rede_social;
    data['provedor_casa'] = provedor_casa;
    data['igreja_id'] = igreja_id as String;
    data['local_trabalho'] = local_trabalho;
    data['cargo_trabalho'] = cargo_trabalho;
    data['religiao_id'] = religiao_id;
    data['funcao_igreja'] = funcao_igreja;
    data['usuario_id'] = usuario_id;
    data['status'] = status;
    data['data_cadastro'] = data_cadastro;
    data['data_update'] = data_update;
    data['familia_id'] = familia_id;
    data['parentesco'] = parentesco;
    return data;
  }
}
