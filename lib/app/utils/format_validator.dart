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

  static RxString formatDate(String date) {
    final RegExp dateRegex = RegExp(r'^(\d{2})(\d{2})(\d{4})$');

    final matches = dateRegex.allMatches(date);

    if (matches.isNotEmpty) {
      final match = matches.first;
      return RxString('${match[1]}/${match[2]}/${match[3]}');
    }

    return RxString(date);
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

  static bool validateDateSubmited(String? input) {
    if (input == null || input.isEmpty) {
      return false;
    }

    final RegExp dateRegex =
        RegExp(r'^([0-2][0-9]|3[0-1])/(0[1-9]|1[0-2])/(19|20)\d{2}$');
    if (!dateRegex.hasMatch(input)) {
      return false;
    }

    final List<String> parts = input.split('/');
    final int day = int.parse(parts[0]);
    final int month = int.parse(parts[1]);
    final int year = int.parse(parts[2]);

    if (day < 1 || day > 31) {
      return false;
    }

    if (month < 1 || month > 12) {
      return false;
    }

    if (year < 1900 || year > 2100) {
      return false;
    }

    // Verificar meses com 30 dias
    if ([4, 6, 9, 11].contains(month) && day > 30) {
      return false;
    }

    // Verificar mês de fevereiro
    if (month == 2) {
      final bool isLeapYear =
          year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
      if ((isLeapYear && day > 29) || (!isLeapYear && day > 28)) {
        return false;
      }
    }

    return true;
  }
}
