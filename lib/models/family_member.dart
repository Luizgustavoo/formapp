class FamilyMember {
  String nomeCompleto = '';
  String sexo = '';
  String cpf = '';
  String dataNascimento = '';
  String estadoCivil = '';
  String tituloEleitor = '';
  String zonaEleitoral = '';
  String contato = '';
  String redeSocial = '';
  String religiao = '';

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
    };
  }
}
