import '../../../../core/utils/string_utils.dart';
import '../../domain/entities/membro.dart';

/// Model para serialização/deserialização do Membro
class MembroModel extends Membro {
  const MembroModel({
    required super.id,
    required super.numeroCadastro,
    required super.cpf,
    required super.nome,
    required super.nucleo,
    required super.status,
    required super.funcao,
    required super.classificacao,
    required super.diaSessao,
    super.primeiroContatoEmergencia,
    super.segundoContatoEmergencia,
    super.inicioPrimeiroEstagio,
    super.desistenciaPrimeiroEstagio,
    super.primeiroRitoPassagem,
    super.dataPrimeiroDesligamento,
    super.justificativaPrimeiroDesligamento,
    super.condicaoSegundoEstagio,
    super.inicioSegundoEstagio,
    super.desistenciaSegundoEstagio,
    super.segundoRitoPassagem,
    super.dataSegundoDesligamento,
    super.justificativaSegundoDesligamento,
    super.condicaoTerceiroEstagio,
    super.inicioTerceiroEstagio,
    super.desistenciaTerceiroEstagio,
    super.terceiroRitoPassagem,
    super.dataTerceiroDesligamento,
    super.justificativaTerceiroDesligamento,
    super.condicaoQuartoEstagio,
    super.inicioQuartoEstagio,
    super.desistenciaQuartoEstagio,
    super.quartoRitoPassagem,
    super.dataQuartoDesligamento,
    super.justificativaQuartoDesligamento,
    super.dataBatizado,
    super.padrinhoBatismo,
    super.madrinhaBatismo,
    super.dataJogoOrixa,
    super.primeiraCamarinha,
    super.segundaCamarinha,
    super.terceiraCamarinha,
    super.dataCoroacaoSacerdote,
    super.atividadeEspiritual,
    super.grupoTrabalhoEspiritual,
    super.primeiroOrixa,
    super.adjuntoPrimeiroOrixa,
    super.segundoOrixa,
    super.adjuntoSegundoOrixa,
    super.terceiroOrixa,
    super.quartoOrixa,
    super.observacoesOrixa,
    super.dataCriacao,
    super.dataUltimaAlteracao,
  });

  factory MembroModel.fromEntity(Membro membro) {
    return MembroModel(
      id: membro.id,
      numeroCadastro: membro.numeroCadastro,
      cpf: membro.cpf,
      nome: membro.nome,
      nucleo: membro.nucleo,
      status: membro.status,
      funcao: membro.funcao,
      classificacao: membro.classificacao,
      diaSessao: membro.diaSessao,
      primeiroContatoEmergencia: membro.primeiroContatoEmergencia,
      segundoContatoEmergencia: membro.segundoContatoEmergencia,
      inicioPrimeiroEstagio: membro.inicioPrimeiroEstagio,
      desistenciaPrimeiroEstagio: membro.desistenciaPrimeiroEstagio,
      primeiroRitoPassagem: membro.primeiroRitoPassagem,
      dataPrimeiroDesligamento: membro.dataPrimeiroDesligamento,
      justificativaPrimeiroDesligamento:
          membro.justificativaPrimeiroDesligamento,
      condicaoSegundoEstagio: membro.condicaoSegundoEstagio,
      inicioSegundoEstagio: membro.inicioSegundoEstagio,
      desistenciaSegundoEstagio: membro.desistenciaSegundoEstagio,
      segundoRitoPassagem: membro.segundoRitoPassagem,
      dataSegundoDesligamento: membro.dataSegundoDesligamento,
      justificativaSegundoDesligamento: membro.justificativaSegundoDesligamento,
      condicaoTerceiroEstagio: membro.condicaoTerceiroEstagio,
      inicioTerceiroEstagio: membro.inicioTerceiroEstagio,
      desistenciaTerceiroEstagio: membro.desistenciaTerceiroEstagio,
      terceiroRitoPassagem: membro.terceiroRitoPassagem,
      dataTerceiroDesligamento: membro.dataTerceiroDesligamento,
      justificativaTerceiroDesligamento:
          membro.justificativaTerceiroDesligamento,
      condicaoQuartoEstagio: membro.condicaoQuartoEstagio,
      inicioQuartoEstagio: membro.inicioQuartoEstagio,
      desistenciaQuartoEstagio: membro.desistenciaQuartoEstagio,
      quartoRitoPassagem: membro.quartoRitoPassagem,
      dataQuartoDesligamento: membro.dataQuartoDesligamento,
      justificativaQuartoDesligamento: membro.justificativaQuartoDesligamento,
      dataBatizado: membro.dataBatizado,
      padrinhoBatismo: membro.padrinhoBatismo,
      madrinhaBatismo: membro.madrinhaBatismo,
      dataJogoOrixa: membro.dataJogoOrixa,
      primeiraCamarinha: membro.primeiraCamarinha,
      segundaCamarinha: membro.segundaCamarinha,
      terceiraCamarinha: membro.terceiraCamarinha,
      dataCoroacaoSacerdote: membro.dataCoroacaoSacerdote,
      atividadeEspiritual: membro.atividadeEspiritual,
      grupoTrabalhoEspiritual: membro.grupoTrabalhoEspiritual,
      primeiroOrixa: membro.primeiroOrixa,
      adjuntoPrimeiroOrixa: membro.adjuntoPrimeiroOrixa,
      segundoOrixa: membro.segundoOrixa,
      adjuntoSegundoOrixa: membro.adjuntoSegundoOrixa,
      terceiroOrixa: membro.terceiroOrixa,
      quartoOrixa: membro.quartoOrixa,
      observacoesOrixa: membro.observacoesOrixa,
      dataCriacao: membro.dataCriacao,
      dataUltimaAlteracao: membro.dataUltimaAlteracao,
    );
  }

  factory MembroModel.fromJson(Map<String, dynamic> json) {
    return MembroModel(
      id: json['id'] as String,
      numeroCadastro: json['numeroCadastro'] as String,
      cpf: json['cpf'] as String,
      nome: json['nome'] as String,
      nucleo: json['nucleo'] as String,
      status: json['status'] as String,
      funcao: json['funcao'] as String,
      classificacao: json['classificacao'] as String,
      diaSessao: json['diaSessao'] as String,
      primeiroContatoEmergencia: json['primeiroContatoEmergencia'] as String?,
      segundoContatoEmergencia: json['segundoContatoEmergencia'] as String?,
      inicioPrimeiroEstagio: json['inicioPrimeiroEstagio'] != null
          ? DateTime.parse(json['inicioPrimeiroEstagio'] as String)
          : null,
      desistenciaPrimeiroEstagio: json['desistenciaPrimeiroEstagio'] != null
          ? DateTime.parse(json['desistenciaPrimeiroEstagio'] as String)
          : null,
      primeiroRitoPassagem: json['primeiroRitoPassagem'] != null
          ? DateTime.parse(json['primeiroRitoPassagem'] as String)
          : null,
      dataPrimeiroDesligamento: json['dataPrimeiroDesligamento'] != null
          ? DateTime.parse(json['dataPrimeiroDesligamento'] as String)
          : null,
      justificativaPrimeiroDesligamento:
          json['justificativaPrimeiroDesligamento'] as String?,
      condicaoSegundoEstagio: json['condicaoSegundoEstagio'] as String?,
      inicioSegundoEstagio: json['inicioSegundoEstagio'] != null
          ? DateTime.parse(json['inicioSegundoEstagio'] as String)
          : null,
      desistenciaSegundoEstagio: json['desistenciaSegundoEstagio'] != null
          ? DateTime.parse(json['desistenciaSegundoEstagio'] as String)
          : null,
      segundoRitoPassagem: json['segundoRitoPassagem'] != null
          ? DateTime.parse(json['segundoRitoPassagem'] as String)
          : null,
      dataSegundoDesligamento: json['dataSegundoDesligamento'] != null
          ? DateTime.parse(json['dataSegundoDesligamento'] as String)
          : null,
      justificativaSegundoDesligamento:
          json['justificativaSegundoDesligamento'] as String?,
      condicaoTerceiroEstagio: json['condicaoTerceiroEstagio'] as String?,
      inicioTerceiroEstagio: json['inicioTerceiroEstagio'] != null
          ? DateTime.parse(json['inicioTerceiroEstagio'] as String)
          : null,
      desistenciaTerceiroEstagio: json['desistenciaTerceiroEstagio'] != null
          ? DateTime.parse(json['desistenciaTerceiroEstagio'] as String)
          : null,
      terceiroRitoPassagem: json['terceiroRitoPassagem'] != null
          ? DateTime.parse(json['terceiroRitoPassagem'] as String)
          : null,
      dataTerceiroDesligamento: json['dataTerceiroDesligamento'] != null
          ? DateTime.parse(json['dataTerceiroDesligamento'] as String)
          : null,
      justificativaTerceiroDesligamento:
          json['justificativaTerceiroDesligamento'] as String?,
      condicaoQuartoEstagio: json['condicaoQuartoEstagio'] as String?,
      inicioQuartoEstagio: json['inicioQuartoEstagio'] != null
          ? DateTime.parse(json['inicioQuartoEstagio'] as String)
          : null,
      desistenciaQuartoEstagio: json['desistenciaQuartoEstagio'] != null
          ? DateTime.parse(json['desistenciaQuartoEstagio'] as String)
          : null,
      quartoRitoPassagem: json['quartoRitoPassagem'] != null
          ? DateTime.parse(json['quartoRitoPassagem'] as String)
          : null,
      dataQuartoDesligamento: json['dataQuartoDesligamento'] != null
          ? DateTime.parse(json['dataQuartoDesligamento'] as String)
          : null,
      justificativaQuartoDesligamento:
          json['justificativaQuartoDesligamento'] as String?,
      dataBatizado: json['dataBatizado'] != null
          ? DateTime.parse(json['dataBatizado'] as String)
          : null,
      padrinhoBatismo: json['padrinhoBatismo'] as String?,
      madrinhaBatismo: json['madrinhaBatismo'] as String?,
      dataJogoOrixa: json['dataJogoOrixa'] != null
          ? DateTime.parse(json['dataJogoOrixa'] as String)
          : null,
      primeiraCamarinha: json['primeiraCamarinha'] != null
          ? DateTime.parse(json['primeiraCamarinha'] as String)
          : null,
      segundaCamarinha: json['segundaCamarinha'] != null
          ? DateTime.parse(json['segundaCamarinha'] as String)
          : null,
      terceiraCamarinha: json['terceiraCamarinha'] != null
          ? DateTime.parse(json['terceiraCamarinha'] as String)
          : null,
      dataCoroacaoSacerdote: json['dataCoroacaoSacerdote'] != null
          ? DateTime.parse(json['dataCoroacaoSacerdote'] as String)
          : null,
      atividadeEspiritual: json['atividadeEspiritual'] as String?,
      grupoTrabalhoEspiritual: json['grupoTrabalhoEspiritual'] as String?,
      primeiroOrixa: json['primeiroOrixa'] as String?,
      adjuntoPrimeiroOrixa: json['adjuntoPrimeiroOrixa'] as String?,
      segundoOrixa: json['segundoOrixa'] as String?,
      adjuntoSegundoOrixa: json['adjuntoSegundoOrixa'] as String?,
      terceiroOrixa: json['terceiroOrixa'] as String?,
      quartoOrixa: json['quartoOrixa'] as String?,
      observacoesOrixa: json['observacoesOrixa'] as String?,
      dataCriacao: DateTime.parse(json['dataCriacao'] as String),
      dataUltimaAlteracao: DateTime.parse(
        json['dataUltimaAlteracao'] as String,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numeroCadastro': numeroCadastro,
      'cpf': cpf,
      'nome': toUpperCaseOrNull(nome) ?? nome,
      'nucleo': toUpperCaseOrNull(nucleo) ?? nucleo,
      'status': toUpperCaseOrNull(status) ?? status,
      'funcao': toUpperCaseOrNull(funcao) ?? funcao,
      'classificacao': toUpperCaseOrNull(classificacao) ?? classificacao,
      'diaSessao': toUpperCaseOrNull(diaSessao) ?? diaSessao,
      'primeiroContatoEmergencia': toUpperCaseOrNull(primeiroContatoEmergencia),
      'segundoContatoEmergencia': toUpperCaseOrNull(segundoContatoEmergencia),
      'inicioPrimeiroEstagio': inicioPrimeiroEstagio?.toIso8601String(),
      'desistenciaPrimeiroEstagio': desistenciaPrimeiroEstagio
          ?.toIso8601String(),
      'primeiroRitoPassagem': primeiroRitoPassagem?.toIso8601String(),
      'dataPrimeiroDesligamento': dataPrimeiroDesligamento?.toIso8601String(),
      'justificativaPrimeiroDesligamento': toUpperCaseOrNull(
        justificativaPrimeiroDesligamento,
      ),
      'condicaoSegundoEstagio': toUpperCaseOrNull(condicaoSegundoEstagio),
      'inicioSegundoEstagio': inicioSegundoEstagio?.toIso8601String(),
      'desistenciaSegundoEstagio': desistenciaSegundoEstagio?.toIso8601String(),
      'segundoRitoPassagem': segundoRitoPassagem?.toIso8601String(),
      'dataSegundoDesligamento': dataSegundoDesligamento?.toIso8601String(),
      'justificativaSegundoDesligamento': toUpperCaseOrNull(
        justificativaSegundoDesligamento,
      ),
      'condicaoTerceiroEstagio': toUpperCaseOrNull(condicaoTerceiroEstagio),
      'inicioTerceiroEstagio': inicioTerceiroEstagio?.toIso8601String(),
      'desistenciaTerceiroEstagio': desistenciaTerceiroEstagio
          ?.toIso8601String(),
      'terceiroRitoPassagem': terceiroRitoPassagem?.toIso8601String(),
      'dataTerceiroDesligamento': dataTerceiroDesligamento?.toIso8601String(),
      'justificativaTerceiroDesligamento': toUpperCaseOrNull(
        justificativaTerceiroDesligamento,
      ),
      'condicaoQuartoEstagio': toUpperCaseOrNull(condicaoQuartoEstagio),
      'inicioQuartoEstagio': inicioQuartoEstagio?.toIso8601String(),
      'desistenciaQuartoEstagio': desistenciaQuartoEstagio?.toIso8601String(),
      'quartoRitoPassagem': quartoRitoPassagem?.toIso8601String(),
      'dataQuartoDesligamento': dataQuartoDesligamento?.toIso8601String(),
      'justificativaQuartoDesligamento': toUpperCaseOrNull(
        justificativaQuartoDesligamento,
      ),
      'dataBatizado': dataBatizado?.toIso8601String(),
      'padrinhoBatismo': toUpperCaseOrNull(padrinhoBatismo),
      'madrinhaBatismo': toUpperCaseOrNull(madrinhaBatismo),
      'dataJogoOrixa': dataJogoOrixa?.toIso8601String(),
      'primeiraCamarinha': primeiraCamarinha?.toIso8601String(),
      'segundaCamarinha': segundaCamarinha?.toIso8601String(),
      'terceiraCamarinha': terceiraCamarinha?.toIso8601String(),
      'dataCoroacaoSacerdote': dataCoroacaoSacerdote?.toIso8601String(),
      'atividadeEspiritual': toUpperCaseOrNull(atividadeEspiritual),
      'grupoTrabalhoEspiritual': toUpperCaseOrNull(grupoTrabalhoEspiritual),
      'primeiroOrixa': toUpperCaseOrNull(primeiroOrixa),
      'adjuntoPrimeiroOrixa': toUpperCaseOrNull(adjuntoPrimeiroOrixa),
      'segundoOrixa': toUpperCaseOrNull(segundoOrixa),
      'adjuntoSegundoOrixa': toUpperCaseOrNull(adjuntoSegundoOrixa),
      'terceiroOrixa': toUpperCaseOrNull(terceiroOrixa),
      'quartoOrixa': toUpperCaseOrNull(quartoOrixa),
      'observacoesOrixa': toUpperCaseOrNull(observacoesOrixa),
      'dataCriacao': dataCriacao?.toIso8601String(),
      'dataUltimaAlteracao': dataUltimaAlteracao?.toIso8601String(),
    };
  }
}
