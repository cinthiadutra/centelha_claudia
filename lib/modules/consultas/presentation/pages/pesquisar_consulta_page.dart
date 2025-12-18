import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/consulta.dart';
import '../controllers/consulta_controller.dart';
import '../../../../modules/auth/presentation/bloc/auth_bloc.dart';
import '../../../../modules/auth/presentation/bloc/auth_state.dart';
import '../../../../core/constants/consulta_constants.dart';

/// Página para pesquisar consultas com filtros
/// Disponível para todos os níveis
class PesquisarConsultaPage extends StatefulWidget {
  const PesquisarConsultaPage({super.key});

  @override
  State<PesquisarConsultaPage> createState() => _PesquisarConsultaPageState();
}

class _PesquisarConsultaPageState extends State<PesquisarConsultaPage> {
  final consultaController = Get.find<ConsultaController>();

  final cadastroConsulenteController = TextEditingController();
  final cadastroMediumController = TextEditingController();
  String? entidadeSelecionada;

  List<Consulta> resultados = [];
  bool relatorioGerado = false;
  int? nivelUsuario;
  String? cadastroUsuario;

  @override
  void dispose() {
    cadastroConsulenteController.dispose();
    cadastroMediumController.dispose();
    super.dispose();
  }

  void _gerarRelatorio() {
    setState(() {
      resultados = consultaController.pesquisarConsultas(
        cadastroConsulente: cadastroConsulenteController.text.isNotEmpty
            ? cadastroConsulenteController.text
            : null,
        cadastroMedium: cadastroMediumController.text.isNotEmpty
            ? cadastroMediumController.text
            : null,
        nomeEntidade: entidadeSelecionada,
      );
      relatorioGerado = true;
    });
  }

  void _limpar() {
    setState(() {
      cadastroConsulenteController.clear();
      cadastroMediumController.clear();
      entidadeSelecionada = null;
      resultados = [];
      relatorioGerado = false;
    });
  }

  void _exportarExcel() {
    Get.snackbar(
      'Exportação',
      'Exportando ${resultados.length} registros para Excel...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          nivelUsuario = state.usuario.nivelAcesso.index + 1;
          // Para nível 1, usar o ID do usuário como cadastro
          cadastroUsuario = state.usuario.id;

          // Nível 1: preenche automaticamente com seu cadastro
          if (nivelUsuario == 1 && cadastroConsulenteController.text.isEmpty) {
            cadastroConsulenteController.text = cadastroUsuario!;
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Pesquisar Consultas'),
            backgroundColor: Colors.purple,
          ),
          body: Row(
            children: [
              // Painel de filtros
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

                    // Cadastro do consulente
                    TextFormField(
                      controller: cadastroConsulenteController,
                      readOnly: nivelUsuario == 1, // Nível 1 não pode editar
                      decoration: InputDecoration(
                        labelText: 'Cadastro do Consulente',
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: nivelUsuario == 1
                            ? Colors.grey.shade200
                            : Colors.white,
                        suffixIcon: nivelUsuario == 1
                            ? const Icon(Icons.lock, size: 16)
                            : null,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Cadastro do médium
                    TextFormField(
                      controller: cadastroMediumController,
                      decoration: const InputDecoration(
                        labelText: 'Cadastro do Médium',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Nome da entidade
                    DropdownButtonFormField<String>(
                      value: entidadeSelecionada,
                      decoration: const InputDecoration(
                        labelText: 'Nome da Entidade',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('(Todas)'),
                        ),
                        ...ConsultaConstants.entidadesOpcoes.map((e) {
                          return DropdownMenuItem(value: e, child: Text(e));
                        }),
                      ],
                      onChanged: (v) => setState(() => entidadeSelecionada = v),
                    ),

                    const SizedBox(height: 24),

                    ElevatedButton.icon(
                      onPressed: _gerarRelatorio,
                      icon: const Icon(Icons.search),
                      label: const Text('Pesquisar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),

                    const SizedBox(height: 8),

                    OutlinedButton.icon(
                      onPressed: _limpar,
                      icon: const Icon(Icons.clear_all),
                      label: const Text('Limpar'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ],
                ),
              ),

              // Área de resultados
              Expanded(
                child: Column(
                  children: [
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
                              'Total de registros: ${resultados.length}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple.shade700,
                              ),
                            ),
                            const Spacer(),
                            if (resultados.isNotEmpty)
                              ElevatedButton.icon(
                                onPressed: _exportarExcel,
                                icon: const Icon(Icons.file_download),
                                label: const Text('Exportar Excel'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                              ),
                          ],
                        ),
                      ),

                    Expanded(
                      child: relatorioGerado
                          ? resultados.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Nenhuma consulta encontrada',
                                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SingleChildScrollView(
                                    child: DataTable(
                                      columns: const [
                                        DataColumn(label: Text('Nº Consulta')),
                                        DataColumn(label: Text('Data')),
                                        DataColumn(label: Text('Consulente')),
                                        DataColumn(label: Text('Médium')),
                                        DataColumn(label: Text('Entidade')),
                                      ],
                                      rows: resultados.map((consulta) {
                                        return DataRow(
                                          cells: [
                                            DataCell(Text(consulta.numeroConsulta)),
                                            DataCell(Text(_formatarData(consulta.data))),
                                            DataCell(Text(consulta.nomeConsulente)),
                                            DataCell(Text(consulta.nomeMedium)),
                                            DataCell(Text(consulta.nomeEntidade)),
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
                                  Icon(Icons.search, size: 64, color: Colors.grey.shade400),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Selecione os filtros e clique em "Pesquisar"',
                                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
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
      },
    );
  }
}
