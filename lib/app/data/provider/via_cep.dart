import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ucif/app/utils/connection_service.dart';

class ViaCEPService {
  static Future<Map<String, dynamic>> getAddressFromCEP(String cep) async {
    if (await ConnectionStatus.verifyConnection()) {
      final response =
          await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('erro')) {
          // CEP não encontrado
          return {'error': 'CEP não encontrado'};
        }

        return data;
      } else {
        // Erro na requisição
        return {'error': 'Erro na requisição'};
      }
    } else {
      return {'': ''};
    }
  }
}
