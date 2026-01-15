import 'package:ucif/app/data/models/service_category_model.dart';
import 'package:ucif/app/data/models/user_model.dart';

class Atendimento {
  // Campos obrigatórios (NOT NULL)
  final int id; // int(11)
  final int categoriaId; // bigint(20) - Foreign Key
  final int pessoaId; // bigint(20) - Foreign Key
  final DateTime dataAtendimento; // datetime
  final String observacoes; // longtext
  final int usuarioId; // bigint(20) - Foreign Key

  final CategoriaAtendimento? categoria;
  final User? usuario;

  // Campos opcionais (NULL SIM)
  final DateTime? dataCadastro; // datetime - Padrão: current_timestamp()
  final DateTime? dataUpdate; // datetime - Padrão: current_timestamp()

  Atendimento({
    required this.id,
    required this.categoriaId,
    required this.pessoaId,
    required this.dataAtendimento,
    required this.observacoes,
    required this.usuarioId,
    this.categoria,
    this.usuario,
    this.dataCadastro,
    this.dataUpdate,
  });

  /// Construtor factory para desserializar (Converter JSON para objeto Dart)
  factory Atendimento.fromJson(Map<String, dynamic> json) {
    // Função utilitária para conversão segura de String para DateTime
    DateTime? parseDateTime(dynamic value) {
      if (value == null) return null;
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    return Atendimento(
      id: json['id'] as int,
      categoriaId: json['categoria_id'] as int,
      pessoaId: json['pessoa_id'] as int,
      // data_atendimento é NOT NULL, então deve ser parseado como DateTime
      dataAtendimento: DateTime.parse(json['data_atendimento'] as String),
      observacoes: json['observacoes'] as String,
      usuarioId: json['usuario_id'] as int,
      // Campos que aceitam NULL
      dataCadastro: parseDateTime(json['data_cadastro']),
      dataUpdate: parseDateTime(json['data_update']),
      categoria: json['categoria'] != null
          ? CategoriaAtendimento.fromJson(
              json['categoria'] as Map<String, dynamic>,
            )
          : null,

      usuario: json['usuario'] != null
          ? User.fromJson(
              json['usuario'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  /// Método para serializar (Converter objeto Dart para JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoria_id': categoriaId,
      'pessoa_id': pessoaId,
      'data_atendimento': dataAtendimento.toIso8601String(),
      'observacoes': observacoes,
      'usuario_id': usuarioId,
      'data_cadastro':
          dataCadastro?.toIso8601String(), // Usa ?. para Null Safety
      'data_update': dataUpdate?.toIso8601String(), // Usa ?. para Null Safety
      'categoria': categoria?.toJson(),
      'usuario': usuario?.toJson(),
    };
  }
}
