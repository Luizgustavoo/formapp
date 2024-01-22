class FamilyMember {
  String nomeCompleto = '';
  String sexo = '';
  String cpf = '';
  String trabalho = '';
  String dataNascimento = '';
  String estadoCivil = '';
  String provedor = '';
  String tituloEleitor = '';
  String zonaEleitoral = '';
  String contato = '';
  String redeSocial = '';
  String religiao = '';
  String cargo = '';
  String funcIgreja = '';
  String igreja = '';

  FamilyMember({
    required this.nomeCompleto,
    required this.sexo,
    required this.cpf,
    required this.dataNascimento,
    required this.estadoCivil,
    required this.tituloEleitor,
    required this.zonaEleitoral,
    required this.contato,
    required this.redeSocial,
    required this.religiao,
    required this.trabalho,
    required this.cargo,
    required this.funcIgreja,
    required this.igreja,
    required this.provedor,
  });

  // Método para criar uma cópia do FamilyMember com as alterações desejadas
  FamilyMember copyWith({
    String? nomeCompleto,
    String? sexo,
    String? cpf,
    String? dataNascimento,
    String? estadoCivil,
    String? tituloEleitor,
    String? zonaEleitoral,
    String? contato,
    String? redeSocial,
    String? religiao,
    String? trabalho,
    String? cargo,
    String? funcIgreja,
    String? igreja,
  }) {
    return FamilyMember(
      nomeCompleto: nomeCompleto ?? this.nomeCompleto,
      sexo: sexo ?? this.sexo,
      cpf: cpf ?? this.cpf,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      estadoCivil: estadoCivil ?? this.estadoCivil,
      tituloEleitor: tituloEleitor ?? this.tituloEleitor,
      zonaEleitoral: zonaEleitoral ?? this.zonaEleitoral,
      contato: contato ?? this.contato,
      redeSocial: redeSocial ?? this.redeSocial,
      religiao: religiao ?? this.religiao,
      trabalho: trabalho ?? this.trabalho,
      cargo: cargo ?? this.cargo,
      funcIgreja: funcIgreja ?? this.funcIgreja,
      igreja: igreja ?? this.igreja,
      provedor: provedor,
    );
  }

  // Método para criar um FamilyMember a partir de um mapa (usado para carregar dados)
  factory FamilyMember.fromMap(Map<String, dynamic> map) {
    return FamilyMember(
      nomeCompleto: map['nomeCompleto'] ?? '',
      sexo: map['sexo'] ?? '',
      cpf: map['cpf'] ?? '',
      dataNascimento: map['dataNascimento'] ?? '',
      estadoCivil: map['estadoCivil'] ?? '',
      tituloEleitor: map['tituloEleitor'] ?? '',
      zonaEleitoral: map['zonaEleitoral'] ?? '',
      contato: map['contato'] ?? '',
      redeSocial: map['redeSocial'] ?? '',
      religiao: map['religiao'] ?? '',
      trabalho: map['trabalho'] ?? '',
      cargo: map['cargo'],
      funcIgreja: map['funcaoIgreja'],
      igreja: map['igreja'],
      provedor: map['provedor'],
    );
  }

  // Método para converter o FamilyMember em um mapa (usado para salvar dados)
  Map<String, dynamic> toMap() {
    return {
      'nomeCompleto': nomeCompleto,
      'sexo': sexo,
      'cpf': cpf,
      'dataNascimento': dataNascimento,
      'estadoCivil': estadoCivil,
      'tituloEleitor': tituloEleitor,
      'zonaEleitoral': zonaEleitoral,
      'contato': contato,
      'redeSocial': redeSocial,
      'religiao': religiao,
      'trabalho': trabalho,
      'funcaoIgreja': funcIgreja,
      'cargo': cargo,
      'igreja': igreja,
      'provedor': provedor,
    };
  }
}
