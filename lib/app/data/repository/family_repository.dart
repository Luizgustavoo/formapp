import 'package:formapp/app/data/database_helper.dart';
import 'package:formapp/app/data/models/family_model.dart';
import 'package:formapp/app/data/models/people_model.dart';
import 'package:formapp/app/data/provider/family_provider.dart';
import 'package:formapp/app/utils/connection_service.dart';

class FamilyRepository {
  final FamilyApiClient apiClient = FamilyApiClient();
  final DatabaseHelper localDatabase = DatabaseHelper();

  getAll(String token) async {
    List<Family> list = <Family>[];

    var responseLocal = await getFamiliesWithPeopleLocal();

    for (Family familyLocal in responseLocal) {
      familyLocal.familyLocal = true;

      list.add(familyLocal);
    }

    if (await ConnectionStatus.verifyConnection()) {
      var response = await apiClient.getAll(token);
      response.forEach((e) {
        Family f = Family.fromJson(e);
        f.familyLocal = false;
        list.add(f);
      });
    }
    return list;
  }

  insertFamily(String token, Family family) async {
    try {
      var response = await apiClient.insertFamily(token, family);

      return response;
    } catch (e) {
      print('Erro ao inserir a família: $e');
      rethrow;
    }
  }

  updateFamily(String token, Family family) async {
    try {
      var response = await apiClient.updateFamily(token, family);

      return response;
    } catch (e) {
      print('Erro ao atualizar a família: $e');
      rethrow;
    }
  }

  deleteFamily(String token, Family family) async {
    try {
      var response = await apiClient.deleteFamily(token, family);

      return response;
    } catch (e) {
      print('Erro ao atualizar a família: $e');
      rethrow;
    }
  }

  Future<List<Family>> getFamiliesWithPeopleLocal() async {
    final dbHelper = DatabaseHelper();
    final result = await dbHelper.getFamiliesWithPeople();

    List<Family> families = [];
    int? currentFamilyId;
    Family? currentFamily;

    for (final row in result) {
      final idFamilia = row['id_familia'] as int?;
      final nomeFamilia = row['nome_familia'] as String?;
      final enderecoFamilia = row['endereco_familia'] as String?;
      final numeroCasaFamilia = row['numero_casa_familia'] as String?;
      final bairroFamilia = row['bairro_familia'] as String?;
      final cidadeFamilia = row['cidade_familia'] as String?;
      final ufFamilia = row['uf_familia'] as String?;
      final complementoFamilia = row['complemento_familia'] as String?;
      final residenciaPropriaFamilia =
          row['residencia_propria_familia'] as String?;
      final usuarioIdFamilia = row['usuario_id_familia'] as int?;
      final statusFamilia = row['status_familia'] as int?;
      final dataCadastroFamilia = row['data_cadastro_familia'] as String?;
      final dataUpdateFamilia = row['data_update_familia'] as String?;
      final cepFamilia = row['cep_familia'] as String?;

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
      final familiaIdPeople = row['familia_id_people'] as int?;
      final parentescoPeople = row['parentesco_people'] as String?;

      if (currentFamilyId != idFamilia) {
        currentFamily = Family(
          id: idFamilia,
          nome: nomeFamilia,
          endereco: enderecoFamilia,
          numeroCasa: numeroCasaFamilia,
          bairro: bairroFamilia,
          cidade: cidadeFamilia,
          uf: ufFamilia,
          complemento: complementoFamilia,
          residenciaPropria: residenciaPropriaFamilia,
          usuarioId: usuarioIdFamilia,
          status: statusFamilia,
          dataCadastro: dataCadastroFamilia,
          dataUpdate: dataUpdateFamilia,
          cep: cepFamilia,
          pessoas: [],
        );

        if (idPeople != null && nomePeople != null) {
          currentFamily.pessoas?.add(People(
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
            familiaId: idFamilia,
            parentesco: parentescoPeople,
          ));
        }
        families.add(currentFamily);
        currentFamilyId = idFamilia;
      }
    }

    return families;
  }
}
