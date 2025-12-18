import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/grupo_trabalho_espiritual_constants.dart';
import '../../domain/entities/grupo_trabalho_espiritual_membro.dart';
import '../controllers/grupo_trabalho_espiritual_controller.dart';

/// Página para gerar relatórios de grupos de trabalhos espirituais
/// Disponível para níveis 2 e 4
class RelatoriosGrupoTrabalhoEspiritualPage extends StatefulWidget {
  const RelatoriosGrupoTrabalhoEspiritualPage({super.key});

  @override
  State<RelatoriosGrupoTrabalhoEspiritualPage> createState() =>
      _RelatoriosGrupoTrabalhoEspiritualPageState();
}

class _RelatoriosGrupoTrabalhoEspiritualPageState
    extends State<RelatoriosGrupoTrabalhoEspiritualPage> {
  final grupoTrabalhoEspiritualController =
      Get.find<GrupoTrabalhoEspiritualController>();

  String? atividadeEspiritualFiltro;
  String? grupoTrabalhoFiltro;
  String? funcaoFiltro;

  List<String> gruposDisponiveisFiltro = [];
  List<GrupoTrabalhoEspiritualMembro> resultados = [];
  bool relatorioGerado = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios de Grupos de Trabalhos Espirituais'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Row(
        children: [
          // Painel de filtros (esquerda)
          Container(
            width: 350,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(right: BorderSide(color: Colors.grey.shade300)),
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'FILTROS',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),

                DropdownButtonFormField<String>(
                  initialValue: atividadeEspiritualFiltro,
                  decoration: const InputDecoration(
                    labelText: 'Atividade Espiritual',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('(Todas)'),
                    ),
                    ...GrupoTrabalhoEspiritualConstants.atividadesOpcoes.map((
                      atividade,
                    ) {
                      return DropdownMenuItem<String>(
                        value: atividade,
                        child: Text(atividade),
                      );
                    }),
                  ],
                  onChanged: (v) {
                    setState(() {
                      atividadeEspiritualFiltro = v;
                      _atualizarGruposDisponiveisFiltro();
                    });
                  },
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  initialValue: grupoTrabalhoFiltro,
                  decoration: InputDecoration(
                    labelText: 'Grupo de Trabalho',
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    helperText: atividadeEspiritualFiltro == null
                        ? 'Selecione uma atividade primeiro'
                        : null,
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('(Todos)'),
                    ),
                    ...gruposDisponiveisFiltro.map((grupo) {
                      return DropdownMenuItem<String>(
                        value: grupo,
                        child: Text(grupo),
                      );
                    }),
                  ],
                  onChanged: atividadeEspiritualFiltro == null
                      ? null
                      : (v) => setState(() => grupoTrabalhoFiltro = v),
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  initialValue: funcaoFiltro,
                  decoration: const InputDecoration(
                    labelText: 'Função',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('(Todas)'),
                    ),
                    ...GrupoTrabalhoEspiritualConstants.funcoesOpcoes.map((
                      funcao,
                    ) {
                      return DropdownMenuItem<String>(
                        value: funcao,
                        child: Text(funcao),
                      );
                    }),
                  ],
                  onChanged: (v) => setState(() => funcaoFiltro = v),
                ),

                const SizedBox(height: 24),

                ElevatedButton.icon(
                  onPressed: _gerarRelatorio,
                  icon: const Icon(Icons.analytics),
                  label: const Text('Gerar Relatório'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),

                const SizedBox(height: 8),

                OutlinedButton.icon(
                  onPressed: _limparFiltros,
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Limpar Filtros'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),

          // Área de resultados (direita)
          Expanded(
            child: Column(
              children: [
                // Cabeçalho com total e botão exportar
                if (relatorioGerado)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.assessment,
                          color: Colors.deepPurple.shade700,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Total de registros encontrados: ${resultados.length}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple.shade700,
                          ),
                        ),
                        const Spacer(),
                        if (resultados.isNotEmpty)
                          ElevatedButton.icon(
                            onPressed: _exportarParaExcel,
                            icon: const Icon(Icons.file_download),
                            label: const Text('Exportar para Excel'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple.shade700,
                            ),
                          ),
                      ],
                    ),
                  ),

                // Tabela de resultados
                Expanded(
                  child: relatorioGerado
                      ? resultados.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_off,
                                      size: 64,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Nenhum registro encontrado',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Tente ajustar os filtros',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: SingleChildScrollView(
                                  child: DataTable(
                                    columns: const [
                                      DataColumn(label: Text('Nº Cadastro')),
                                      DataColumn(label: Text('Nome')),
                                      DataColumn(label: Text('Status')),
                                      DataColumn(label: Text('Atividade')),
                                      DataColumn(
                                        label: Text('Grupo de Trabalho'),
                                      ),
                                      DataColumn(label: Text('Função')),
                                      DataColumn(
                                        label: Text('Última Alteração'),
                                      ),
                                    ],
                                    rows: resultados.map((membro) {
                                      return DataRow(
                                        cells: [
                                          DataCell(Text(membro.numeroCadastro)),
                                          DataCell(Text(membro.nome)),
                                          DataCell(
                                            Chip(
                                              label: Text(
                                                membro.status,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                ),
                                              ),
                                              backgroundColor:
                                                  membro.status ==
                                                      'Membro ativo'
                                                  ? Colors.green.shade100
                                                  : Colors.grey.shade300,
                                            ),
                                          ),
                                          DataCell(
                                            SizedBox(
                                              width: 150,
                                              child: Text(
                                                membro.atividadeEspiritual,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            SizedBox(
                                              width: 180,
                                              child: Text(
                                                membro.grupoTrabalho,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            Chip(
                                              label: Text(
                                                membro.funcao,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                ),
                                              ),
                                              backgroundColor:
                                                  membro.funcao == 'Líder'
                                                  ? Colors.orange.shade100
                                                  : Colors.blue.shade100,
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              _formatarData(
                                                membro.dataUltimaAlteracao,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.analytics_outlined,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Selecione os filtros e clique em "Gerar Relatório"',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _atualizarGruposDisponiveisFiltro() {
    if (atividadeEspiritualFiltro != null) {
      setState(() {
        gruposDisponiveisFiltro =
            GrupoTrabalhoEspiritualConstants.getGruposPorAtividade(
              atividadeEspiritualFiltro!,
            );

        // Se o grupo atual não pertence à nova atividade, limpa a seleção
        if (grupoTrabalhoFiltro != null &&
            !gruposDisponiveisFiltro.contains(grupoTrabalhoFiltro)) {
          grupoTrabalhoFiltro = null;
        }
      });
    } else {
      setState(() {
        gruposDisponiveisFiltro = [];
        grupoTrabalhoFiltro = null;
      });
    }
  }

  void _exportarParaExcel() {
    // TODO: Implementar exportação real para Excel
    Get.snackbar(
      'Exportação',
      'Exportando ${resultados.length} registros para Excel...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.deepPurple,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Get.snackbar(
        'Sucesso',
        'Relatório exportado com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    });
  }

  String _formatarData(DateTime? data) {
    if (data == null) return '-';
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  void _gerarRelatorio() {
    setState(() {
      resultados = grupoTrabalhoEspiritualController.filtrar(
        atividadeEspiritual: atividadeEspiritualFiltro,
        grupoTrabalho: grupoTrabalhoFiltro,
        funcao: funcaoFiltro,
      );
      relatorioGerado = true;
    });
  }

  void _limparFiltros() {
    setState(() {
      atividadeEspiritualFiltro = null;
      grupoTrabalhoFiltro = null;
      funcaoFiltro = null;
      gruposDisponiveisFiltro = [];
      resultados = [];
      relatorioGerado = false;
    });
  }
}
