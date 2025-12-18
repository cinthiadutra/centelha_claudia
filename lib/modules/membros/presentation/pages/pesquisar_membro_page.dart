import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../domain/entities/membro.dart';
import '../controllers/membro_controller.dart';

/// Página para pesquisar membros da CENTELHA
/// Disponível para todos os níveis de acesso
class PesquisarMembroPage extends StatefulWidget {
  const PesquisarMembroPage({super.key});

  @override
  State<PesquisarMembroPage> createState() => _PesquisarMembroPageState();
}

class _PesquisarMembroPageState extends State<PesquisarMembroPage> {
  final membroController = Get.find<MembroController>();
  final searchController = TextEditingController();
  final cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  String tipoBusca = 'numero'; // numero, cpf, nome
  List<Membro> resultados = [];
  bool buscaRealizada = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _buscar() {
    setState(() {
      buscaRealizada = true;
      
      if (searchController.text.isEmpty) {
        resultados = [];
        return;
      }

      switch (tipoBusca) {
        case 'numero':
          final membro = membroController.buscarPorNumero(searchController.text);
          resultados = membro != null ? [membro] : [];
          break;
        case 'cpf':
          final cpfLimpo = searchController.text.replaceAll(RegExp(r'[^\d]'), '');
          final membro = membroController.buscarPorCpf(cpfLimpo);
          resultados = membro != null ? [membro] : [];
          break;
        case 'nome':
          resultados = membroController.pesquisarPorNome(searchController.text);
          break;
      }
    });
  }

  void _limpar() {
    setState(() {
      searchController.clear();
      resultados = [];
      buscaRealizada = false;
    });
  }

  void _verDetalhes(Membro membro) {
    showDialog(
      context: context,
      builder: (context) => _DetalheMembroDialog(membro: membro),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesquisar Dados de Membro'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tipo de busca
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tipo de Busca',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 16,
                      children: [
                        ChoiceChip(
                          label: const Text('Número de Cadastro'),
                          selected: tipoBusca == 'numero',
                          onSelected: (selected) {
                            setState(() {
                              tipoBusca = 'numero';
                              searchController.clear();
                              resultados = [];
                              buscaRealizada = false;
                            });
                          },
                        ),
                        ChoiceChip(
                          label: const Text('CPF'),
                          selected: tipoBusca == 'cpf',
                          onSelected: (selected) {
                            setState(() {
                              tipoBusca = 'cpf';
                              searchController.clear();
                              resultados = [];
                              buscaRealizada = false;
                            });
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Nome'),
                          selected: tipoBusca == 'nome',
                          onSelected: (selected) {
                            setState(() {
                              tipoBusca = 'nome';
                              searchController.clear();
                              resultados = [];
                              buscaRealizada = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Campo de busca
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: searchController,
                    inputFormatters: tipoBusca == 'cpf' ? [cpfMask] : null,
                    keyboardType: tipoBusca == 'numero' || tipoBusca == 'cpf'
                        ? TextInputType.number
                        : TextInputType.text,
                    decoration: InputDecoration(
                      labelText: tipoBusca == 'numero'
                          ? 'Digite o número de cadastro'
                          : tipoBusca == 'cpf'
                              ? 'Digite o CPF'
                              : 'Digite o nome',
                      prefixIcon: Icon(
                        tipoBusca == 'numero'
                            ? Icons.numbers
                            : tipoBusca == 'cpf'
                                ? Icons.credit_card
                                : Icons.person_search,
                      ),
                      border: const OutlineInputBorder(),
                      hintText: tipoBusca == 'cpf' ? '000.000.000-00' : null,
                    ),
                    onFieldSubmitted: (_) => _buscar(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _buscar,
                  icon: const Icon(Icons.search),
                  label: const Text('Buscar'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: _limpar,
                  icon: const Icon(Icons.clear),
                  label: const Text('Limpar'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Resultados
            if (buscaRealizada) ...[
              Text(
                'Resultados: ${resultados.length} ${resultados.length == 1 ? 'membro encontrado' : 'membros encontrados'}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Lista de resultados
            Expanded(
              child: resultados.isEmpty && buscaRealizada
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
                            'Nenhum membro encontrado',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: resultados.length,
                      itemBuilder: (context, index) {
                        final membro = resultados[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.purple,
                              child: Text(
                                membro.nome[0].toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              membro.nome,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Cadastro: ${membro.numeroCadastro}'),
                                Text('Núcleo: ${membro.nucleo}'),
                                Text('Status: ${membro.status}'),
                                Text('Função: ${membro.funcao}'),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Chip(
                                  label: Text(
                                    membro.status,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  backgroundColor: membro.status == 'Membro ativo'
                                      ? Colors.green.shade100
                                      : membro.status == 'Estagiário'
                                          ? Colors.blue.shade100
                                          : Colors.red.shade100,
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.visibility),
                                  onPressed: () => _verDetalhes(membro),
                                  tooltip: 'Ver detalhes',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetalheMembroDialog extends StatelessWidget {
  final Membro membro;

  const _DetalheMembroDialog({required this.membro});

  String _formatarData(DateTime? data) {
    if (data == null) return '-';
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  String _formatarCPF(String cpf) {
    if (cpf.length != 11) return cpf;
    return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9)}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 800,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Detalhes do Membro',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSecao('IDENTIFICAÇÃO'),
                  _buildInfo('Número de Cadastro', membro.numeroCadastro),
                  _buildInfo('Nome', membro.nome),
                  _buildInfo('CPF', _formatarCPF(membro.cpf)),
                  
                  const Divider(height: 32),
                  _buildSecao('INFORMAÇÕES ORGANIZACIONAIS'),
                  _buildInfo('Núcleo', membro.nucleo),
                  _buildInfo('Status', membro.status),
                  _buildInfo('Função', membro.funcao),
                  _buildInfo('Classificação', membro.classificacao),
                  _buildInfo('Dia de Sessão', membro.diaSessao),
                  _buildInfo('1º Contato Emergência', membro.primeiroContatoEmergencia ?? '-'),
                  _buildInfo('2º Contato Emergência', membro.segundoContatoEmergencia ?? '-'),
                  
                  const Divider(height: 32),
                  _buildSecao('HISTÓRICO ESPIRITUAL'),
                  _buildInfo('Data do Batizado', _formatarData(membro.dataBatizado)),
                  _buildInfo('Padrinho', membro.padrinhoBatismo ?? '-'),
                  _buildInfo('Madrinha', membro.madrinhaBatismo ?? '-'),
                  _buildInfo('Data Jogo de Orixá', _formatarData(membro.dataJogoOrixa)),
                  _buildInfo('1ª Camarinha', _formatarData(membro.primeiraCamarinha)),
                  _buildInfo('2ª Camarinha', _formatarData(membro.segundaCamarinha)),
                  _buildInfo('3ª Camarinha', _formatarData(membro.terceiraCamarinha)),
                  _buildInfo('Data Coroação Sacerdotal', _formatarData(membro.dataCoroacaoSacerdote)),
                  _buildInfo('Atividade Espiritual', membro.atividadeEspiritual ?? '-'),
                  _buildInfo('Grupo de Trabalho', membro.grupoTrabalhoEspiritual ?? '-'),
                  
                  const Divider(height: 32),
                  _buildSecao('ORIXÁS'),
                  _buildInfo('1º Orixá', membro.primeiroOrixa ?? '-'),
                  _buildInfo('Adjuntó do 1º', membro.adjuntoPrimeiroOrixa ?? '-'),
                  _buildInfo('2º Orixá', membro.segundoOrixa ?? '-'),
                  _buildInfo('Adjuntó do 2º', membro.adjuntoSegundoOrixa ?? '-'),
                  _buildInfo('3º Orixá', membro.terceiroOrixa ?? '-'),
                  _buildInfo('4º Orixá', membro.quartoOrixa ?? '-'),
                  if (membro.observacoesOrixa != null)
                    _buildInfo('Observações', membro.observacoesOrixa!),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Fechar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecao(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Text(
        titulo,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.purple,
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
