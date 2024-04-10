import 'package:get/get.dart';

class FormattersValidators {
  static RxString formatCPF(String cpf) {
    final RegExp cpfRegex = RegExp(r'^(\d{3})(\d{3})(\d{3})(\d{2})$');

    final matches = cpfRegex.allMatches(cpf);

    if (matches.isNotEmpty) {
      final match = matches.first;
      return RxString('${match[1]}.${match[2]}.${match[3]}-${match[4]}');
    }

    return RxString(cpf);
  }

  static RxString formatDate(String cpf) {
    final RegExp cpfRegex = RegExp(r'^(\d{2})(\d{2})(\d{4})$');

    final matches = cpfRegex.allMatches(cpf);

    if (matches.isNotEmpty) {
      final match = matches.first;
      return RxString('${match[1]}/${match[2]}/${match[3]}');
    }

    return RxString(cpf);
  }

  static RxString formatPhone(String phone) {
    final RegExp phoneRegex = RegExp(r'^(\d{2})(\d{5})(\d{4})$');

    final matches = phoneRegex.allMatches(phone);

    if (matches.isNotEmpty) {
      final match = matches.first;
      return RxString('(${match[1]}) ${match[2]}-${match[3]}');
    }

    return RxString(phone);
  }

  static RxString formatCEP(String cep) {
    final RegExp cepRegex = RegExp(r'^(\d{5})(\d{3})$');

    final matches = cepRegex.allMatches(cep);

    if (matches.isNotEmpty) {
      final match = matches.first;
      return RxString('${match[1]}-${match[2]}');
    }

    return RxString(cep);
  }

  static bool validateCPF(String cpf) {
    // Adicione aqui sua lógica de validação de CPF
    // Exemplo simplificado para fins educacionais
    return cpf.replaceAll(RegExp(r'\D'), '').length == 11;
  }

  static bool validatePhone(String phone) {
    // Adicione aqui sua lógica de validação de telefone
    // Exemplo simplificado para fins educacionais
    return phone.replaceAll(RegExp(r'\D'), '').length == 11;
  }

  static bool validateCEP(String cep) {
    return cep.replaceAll(RegExp(r'\D'), '').length == 8;
  }
}
