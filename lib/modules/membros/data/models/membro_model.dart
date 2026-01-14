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
      id:
          json['id']?.toString() ??
          '', // Converte UUID para string, ou vazio se null
      numeroCadastro:
          json['cadastro']?.toString() ?? '', // Mapeia 'cadastro' do Supabase
      cpf: json['cpf']?.toString() ?? '',
      nome: json['nome']?.toString() ?? '',
      nucleo: json['nucleo']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      funcao: json['funcao']?.toString() ?? '',
      classificacao: json['classificacao']?.toString() ?? '',
      diaSessao:
          json['dia_sessao']?.toString() ??
          '', // Mapeia 'dia_sessao' do Supabase
      primeiroContatoEmergencia: json['primeiro_contato_emergencia'] as String?,
      segundoContatoEmergencia: json['segundo_contato_emergencia'] as String?,
      inicioPrimeiroEstagio: json['inicio_estagio'] != null
          ? DateTime.parse(json['inicio_estagio'] as String)
          : null,
      desistenciaPrimeiroEstagio: json['desistencia_estagio'] != null
          ? DateTime.parse(json['desistencia_estagio'] as String)
          : null,
      primeiroRitoPassagem: json['primeiro_rito_passagem'] != null
          ? DateTime.parse(json['primeiro_rito_passagem'] as String)
          : null,
      dataPrimeiroDesligamento: json['primeiro_desligamento'] != null
          ? DateTime.parse(json['primeiro_desligamento'] as String)
          : null,
      justificativaPrimeiroDesligamento:
          json['primeiro_desligamento_justificativa'] as String?,
      condicaoSegundoEstagio: json['condicao_segundo_estagio'] as String?,
      inicioSegundoEstagio: json['inicio_segundo_estagio'] != null
          ? DateTime.parse(json['inicio_segundo_estagio'] as String)
          : null,
      desistenciaSegundoEstagio: json['desistencia_segundo_estagio'] != null
          ? DateTime.parse(json['desistencia_segundo_estagio'] as String)
          : null,
      segundoRitoPassagem: json['segundo_rito_passagem'] != null
          ? DateTime.parse(json['segundo_rito_passagem'] as String)
          : null,
      dataSegundoDesligamento: json['segundo_desligamento'] != null
          ? DateTime.parse(json['segundo_desligamento'] as String)
          : null,
      justificativaSegundoDesligamento:
          json['segundo_desligamento_justificativa'] as String?,
      condicaoTerceiroEstagio: json['condicao_terceiro_estagio'] as String?,
      inicioTerceiroEstagio: json['inicio_terceiro_estagio'] != null
          ? DateTime.parse(json['inicio_terceiro_estagio'] as String)
          : null,
      desistenciaTerceiroEstagio: json['desistencia_terceiro_estagio'] != null
          ? DateTime.parse(json['desistencia_terceiro_estagio'] as String)
          : null,
      terceiroRitoPassagem: json['terceiro_rito_passagem'] != null
          ? DateTime.parse(json['terceiro_rito_passagem'] as String)
          : null,
      dataTerceiroDesligamento: json['terceiro_desligamento'] != null
          ? DateTime.parse(json['terceiro_desligamento'] as String)
          : null,
      justificativaTerceiroDesligamento:
          json['terceiro_desligamento_justificativa'] as String?,
      condicaoQuartoEstagio: json['condicao_quarto_estagio'] as String?,
      inicioQuartoEstagio: json['inicio_quarto_estagio'] != null
          ? DateTime.parse(json['inicio_quarto_estagio'] as String)
          : null,
      desistenciaQuartoEstagio: json['desistencia_quarto_estagio'] != null
          ? DateTime.parse(json['desistencia_quarto_estagio'] as String)
          : null,
      quartoRitoPassagem: json['quarto_rito_passagem'] != null
          ? DateTime.parse(json['quarto_rito_passagem'] as String)
          : null,
      dataQuartoDesligamento: json['quarto_desligamento'] != null
          ? DateTime.parse(json['quarto_desligamento'] as String)
          : null,
      justificativaQuartoDesligamento:
          json['quarto_desligamento_justificativa'] as String?,
      dataBatizado: json['ritual_batismo'] != null
          ? DateTime.parse(json['ritual_batismo'] as String)
          : null,
      padrinhoBatismo: json['padrinho_batismo'] as String?,
      madrinhaBatismo: json['madrinha_batismo'] as String?,
      dataJogoOrixa: json['jogo_orixa'] != null
          ? DateTime.parse(json['jogo_orixa'] as String)
          : null,
      primeiraCamarinha: json['primeira_camarinha'] != null
          ? DateTime.parse(json['primeira_camarinha'] as String)
          : null,
      segundaCamarinha: json['segunda_camarinha'] != null
          ? DateTime.parse(json['segunda_camarinha'] as String)
          : null,
      terceiraCamarinha: json['terceira_camarinha'] != null
          ? DateTime.parse(json['terceira_camarinha'] as String)
          : null,
      dataCoroacaoSacerdote: json['coroacao_sacerdote'] != null
          ? DateTime.parse(json['coroacao_sacerdote'] as String)
          : null,
      atividadeEspiritual: json['atividade_espiritual'] as String?,
      grupoTrabalhoEspiritual: json['grupo_trabalho_espiritual'] as String?,
      primeiroOrixa: json['primeiro_orixa'] as String?,
      adjuntoPrimeiroOrixa: json['adjunto_primeiro_orixa'] as String?,
      segundoOrixa: json['segundo_orixa'] as String?,
      adjuntoSegundoOrixa: json['adjunto_segundo_orixa'] as String?,
      terceiroOrixa: json['terceiro_quarto_orixa'] as String?,
      quartoOrixa: json['quarto_orixa'] as String?,
      observacoesOrixa: json['observacoes'] as String?,
      dataCriacao: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      dataUltimaAlteracao: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
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
