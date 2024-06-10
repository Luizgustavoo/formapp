import 'dart:io';

import 'package:ucif/app/data/database_helper.dart';
import 'package:ucif/app/data/models/people_model.dart';
import 'package:ucif/app/data/models/user_model.dart';
import 'package:ucif/app/data/provider/people_provider.dart';
import 'package:ucif/app/utils/connection_service.dart';
import 'package:ucif/app/utils/error_handler.dart';

class PeopleRepository {
  final PeopleApiClient apiClient = PeopleApiClient();

  getAll(String token, {int? page, String? search}) async {
    List<People> list = <People>[];

    var responseLocal = await getPeoplesOffline();

    for (People peopleLocal in responseLocal) {
      peopleLocal.peopleLocal = true;
      list.add(peopleLocal);
    }

    if (await ConnectionStatus.verifyConnection()) {
      var response = await apiClient.getAll(token, page: page, search: search);
      List<People> newPeoples = [];
      response['data'].forEach((e) {
        People p = People.fromJson(e);
        p.peopleLocal = false;
        newPeoples.add(p);
      });
      // if (page == 1) {
      //   list.clear();
      // }
      for (var family in newPeoples) {
        if (!list.contains(family)) {
          list.add(family);
        }
      }
    }
    return list;
  }

  getAllMember(String token, int? familiaId) async {
    List<People> list = <People>[];
    if (await ConnectionStatus.verifyConnection()) {
      var response = await apiClient.getAllMember(token, familiaId);
      response.forEach((e) {
        People p = People.fromJson(e);
        list.add(p);
      });
    }
    return list;
  }

  getAllFilter(String token, User user, {int? page}) async {
    if (await ConnectionStatus.verifyConnection()) {
      var response =
          await apiClient.getAllFilter(token, user: user, page: page);
      return response;
    }
  }

  insertPeople(String token, People pessoa, File imageFile, bool peopleLocal,
      List? saude, List? medicamento) async {
    try {
      var response = await apiClient.insertPeople(
          token, pessoa, imageFile, peopleLocal, saude, medicamento);

      return response;
    } catch (e) {
      ErrorHandler.showError(e);
    }
  }

  updatePeople(
      String token,
      People pessoa,
      File imageFile,
      String? oldImagePath,
      bool peopleLocal,
      List? saude,
      List? medicamento) async {
    try {
      var response = await apiClient.updatePeople(token, pessoa, imageFile,
          oldImagePath, peopleLocal, saude, medicamento);

      return response;
    } catch (e) {
      ErrorHandler.showError(e);
    }
  }

  changePeopleFamily(String token, People pessoa) async {
    try {
      var response = await apiClient.changePeopleFamily(token, pessoa);

      return response;
    } catch (e) {
      ErrorHandler.showError(e);
    }
  }

  Future<List<People>> getPeoplesOffline() async {
    final dbHelper = DatabaseHelper();
    final result = await dbHelper.getPeoplesOffline();

    List<People> peoples = [];
    // int? currentFamilyId;
    // People? currentPeople;

    for (final row in result) {
      final idPeople = row['id_people'] as int?;
      final nomePeople = row['nome_people'] as String?;
      final fotoPeople = row['foto_people'] as String?;
      final sexoPeople = row['sexo_people'] as String?;
      final cpfPeople = row['cpf_people'] as String?;
      final dataNascimentoPeople = row['data_nascimento_people'] as String?;
      final estadocivilIdPeople = row['estadocivil_id_people'] as int?;
      final tituloEleitorPeople = row['titulo_eleitor_people'] as String?;
      final zonaEleitoralPeople = row['zona_eleitoral_people'] as String?;
      final telefonePeople = row['telefone_people'] as String?;
      final redeSocialPeople = row['rede_social_people'] as String?;
      final provedorCasaPeople = row['provedor_casa_people'] as String?;
      final igrejaIdPeople = row['igreja_id_people'] as String?;
      final localTrabalhoPeople = row['local_trabalho_people'] as String?;
      final cargoTrabalhoPeople = row['cargo_trabalho_people'] as String?;
      final religiaoIdPeople = row['religiao_id_people'] as int?;
      final funcaoIgrejaPeople = row['funcao_igreja_people'] as String?;
      final usuarioIdPeople = row['usuario_id_people'] as int?;
      final statusPeople = row['status_people'] as String?;
      final dataCadastroPeople = row['data_cadastro_people'] as String?;
      final dataUpdatePeople = row['data_update_people'] as String?;
      final parentescoPeople = row['parentesco_people'] as String?;
      final medicamentosOffline = row['medicamentosOffline'] as String?;
      final acometimentosOffline = row['acometimentosOffline'] as String?;

      if (idPeople != null && nomePeople != null) {
        peoples.add(People(
            id: idPeople,
            nome: nomePeople,
            foto: fotoPeople,
            sexo: sexoPeople,
            cpf: cpfPeople,
            dataNascimento: dataNascimentoPeople,
            estadoCivilId: estadocivilIdPeople,
            tituloEleitor: tituloEleitorPeople,
            zonaEleitoral: zonaEleitoralPeople,
            telefone: telefonePeople,
            redeSocial: redeSocialPeople,
            provedorCasa: provedorCasaPeople,
            igrejaId: igrejaIdPeople,
            localTrabalho: localTrabalhoPeople,
            cargoTrabalho: cargoTrabalhoPeople,
            religiaoId: religiaoIdPeople,
            funcaoIgreja: funcaoIgrejaPeople,
            usuarioId: usuarioIdPeople,
            status: int.parse(statusPeople.toString()),
            dataCadastro: dataCadastroPeople,
            dataUpdate: dataUpdatePeople,
            parentesco: parentescoPeople,
            acometimentosOffline: acometimentosOffline,
            medicamentosOffline: medicamentosOffline));
      }
    }

    return peoples;
  }

  insertPeopleLocalToApi(
      String token, People people, List? saude, List? medicamento) async {
    try {
      var response = await apiClient.insertPeople(
          token, people, File(''), false, saude, medicamento);

      return response;
    } catch (e) {
      ErrorHandler.showError(e);
    }
  }

  deletePeople(String token, People people, bool peopleLocal) async {
    try {
      var response = await apiClient.deletePeople(token, people, peopleLocal);

      return response;
    } catch (e) {
      ErrorHandler.showError(e);
    }
  }

  deletePeopleLocal(People people) async {
    try {
      var response = await apiClient.deletePeopleLocal(people);

      return response;
    } catch (e) {
      ErrorHandler.showError(e);
    }
  }
}
