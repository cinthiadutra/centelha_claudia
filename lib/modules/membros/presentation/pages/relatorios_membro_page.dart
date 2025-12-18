import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/membro.dart';
import '../controllers/membro_controller.dart';
import '../../../../core/constants/membro_constants.dart';

/// Página para gerar relatórios de membros da CENTELHA
/// Disponível para níveis 2 e 4
class RelatoriosMembroPage extends StatefulWidget {
  const RelatoriosMembroPage({super.key});

  @override
  State<RelatoriosMembroPage> createState() => _RelatoriosMembroPageState();
}

class _RelatoriosMembroPageState extends State<RelatoriosMembroPage> {
  final membroController = Get.find<MembroController>();

  // Filtros
  String? statusFiltro;
  String? funcaoFiltro;
  String? classificacaoFiltro;
  String? diaSessaoFiltro;
  bool? temJogoOrixa;
  bool? temBatizado;
  bool? temCamarinha;
  String? atividadeEspiritualFiltro;
  String? grupoTrabalhoFiltro;
  String? orixaFiltro;

  List<Membro> resultados = [];
  bool relatorioGerado = false;

  void _gerarRelatorio() {
    setState(() {
      resultados = membroController.filtrarParaRelatorio(
        status: statusFiltro,
        funcao: funcaoFiltro,
        classificacao: classificacaoFiltro,
        diaSessao: diaSessaoFiltro,
        temJogoOrixa: temJogoOrixa,
        temBatizado: temBatizado,
        temCamarinha: temCamarinha,
        atividadeEspiritual: atividadeEspiritualFiltro,
        grupoTrabalho: grupoTrabalhoFiltro,
        orixa: orixaFiltro,
      );
      relatorioGerado = true;
    });
  }

  void _limparFiltros() {
    setState(() {
      statusFiltro = null;
      funcaoFiltro = null;
      classificacaoFiltro = null;
      diaSessaoFiltro = null;
      temJogoOrixa = null;
      temBatizado = null;
      temCamarinha = null;
      atividadeEspiritualFiltro = null;
      grupoTrabalhoFiltro = null;
      orixaFiltro = null;
      resultados = [];
      relatorioGerado = false;
    });
  }

  void _exportarParaExcel() {
    // TODO: Implementar exportação real para Excel
    Get.snackbar(
      'Exportação',
      'Exportando ${resultados.length} registros para Excel...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
    
    // Simular exportação
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerar Relatórios de Membros'),
        backgroundColor: Colors.purple,
      ),
      body: Row(
        children: [
          // Painel de filtros (esquerda)
          Container(
            width: 350,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(
                right: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'FILTROS',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(),
                
                _buildDropdownFiltro(
                  label: 'Status',
                  value: statusFiltro,
                  items: MembroConstants.statusOpcoes,
                  onChanged: (v) => setState(() => statusFiltro = v),
                ),
                
                _buildDropdownFiltro(
                  label: 'Função',
                  value: funcaoFiltro,
                  items: MembroConstants.funcaoOpcoes,
                  onChanged: (v) => setState(() => funcaoFiltro = v),
                ),
                
                _buildDropdownFiltro(
                  label: 'Classificação',
                  value: classificacaoFiltro,
                  items: MembroConstants.classificacaoOpcoes,
                  onChanged: (v) => setState(() => classificacaoFiltro = v),
                ),
                
                _buildDropdownFiltro(
                  label: 'Dia de Sessão',
                  value: diaSessaoFiltro,
                  items: MembroConstants.diaSessaoOpcoes,
                  onChanged: (v) => setState(() => diaSessaoFiltro = v),
                ),
                
                _buildDropdownFiltro(
                  label: 'Orixá',
                  value: orixaFiltro,
                  items: MembroConstants.orixaOpcoes,
                  onChanged: (v) => setState(() => orixaFiltro = v),
                ),

                const SizedBox(height: 16),
                const Text(
                  'Filtros Booleanos',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                
                CheckboxListTile(
                  title: const Text('Possui Jogo de Orixá'),
                  value: temJogoOrixa ?? false,
                  tristate: true,
                  onChanged: (v) => setState(() => temJogoOrixa = v),
                  dense: true,
                ),
                
                CheckboxListTile(
                  title: const Text('Possui Batizado'),
                  value: temBatizado ?? false,
                  tristate: true,
                  onChanged: (v) => setState(() => temBatizado = v),
                  dense: true,
                ),
                
                CheckboxListTile(
                  title: const Text('Possui Camarinha'),
                  value: temCamarinha ?? false,
                  tristate: true,
                  onChanged: (v) => setState(() => temCamarinha = v),
                  dense: true,
                ),

                const SizedBox(height: 24),
                
                ElevatedButton.icon(
                  onPressed: _gerarRelatorio,
                  icon: const Icon(Icons.analytics),
                  label: const Text('Gerar Relatório'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
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
                      color: Colors.purple.shade50,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.assessment, color: Colors.purple.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Total de registros encontrados: ${resultados.length}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple.shade700,
                          ),
                        ),
                        const Spacer(),
                        if (resultados.isNotEmpty)
                          ElevatedButton.icon(
                            onPressed: _exportarParaExcel,
                            icon: const Icon(Icons.file_download),
                            label: const Text('Exportar para Excel'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
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
                                    DataColumn(label: Text('Núcleo')),
                                    DataColumn(label: Text('Status')),
                                    DataColumn(label: Text('Função')),
                                    DataColumn(label: Text('Classificação')),
                                    DataColumn(label: Text('Dia Sessão')),
                                    DataColumn(label: Text('1º Orixá')),
                                    DataColumn(label: Text('Batizado')),
                                    DataColumn(label: Text('Jogo Orixá')),
                                  ],
                                  rows: resultados.map((membro) {
                                    return DataRow(
                                      cells: [
                                        DataCell(Text(membro.numeroCadastro)),
                                        DataCell(Text(membro.nome)),
                                        DataCell(Text(membro.nucleo)),
                                        DataCell(
                                          Chip(
                                            label: Text(
                                              membro.status,
                                              style: const TextStyle(fontSize: 11),
                                            ),
                                            backgroundColor: membro.status == 'Membro ativo'
                                                ? Colors.green.shade100
                                                : membro.status == 'Estagiário'
                                                    ? Colors.blue.shade100
                                                    : Colors.red.shade100,
                                          ),
                                        ),
                                        DataCell(Text(membro.funcao)),
                                        DataCell(Text(membro.classificacao)),
                                        DataCell(Text(membro.diaSessao)),
                                        DataCell(Text(membro.primeiroOrixa ?? '-')),
                                        DataCell(
                                          Icon(
                                            membro.dataBatizado != null
                                                ? Icons.check_circle
                                                : Icons.cancel,
                                            color: membro.dataBatizado != null
                                                ? Colors.green
                                                : Colors.red,
                                            size: 20,
                                          ),
                                        ),
                                        DataCell(
                                          Icon(
                                            membro.dataJogoOrixa != null
                                                ? Icons.check_circle
                                                : Icons.cancel,
                                            color: membro.dataJogoOrixa != null
                                                ? Colors.green
                                                : Colors.red,
                                            size: 20,
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

  Widget _buildDropdownFiltro({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
        items: [
          const DropdownMenuItem<String>(
            value: null,
            child: Text('(Todos)'),
          ),
          ...items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
