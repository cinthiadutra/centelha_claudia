import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AssistentePage extends StatefulWidget {
  const AssistentePage({super.key});

  @override
  State<AssistentePage> createState() => _AssistentePageState();
}

class _AssistentePageState extends State<AssistentePage> {
  final _mensagemController = TextEditingController();
  final _scrollController = ScrollController();
  final List<_Mensagem> _mensagens = [
    const _Mensagem(
      texto:
          'Olá! Sou a Claudia. Posso ajudar com informações sobre o sistema e, conforme seu acesso, sobre membros.',
      enviadaPeloUsuario: false,
    ),
  ];
  bool _carregando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.psychology_outlined),
            SizedBox(width: 10),
            Text('Assistente Claudia'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  itemCount: _mensagens.length + (_carregando ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_carregando && index == _mensagens.length) {
                      return const _IndicadorDigitacao();
                    }
                    return _BolhaMensagem(mensagem: _mensagens[index]);
                  },
                ),
              ),
            ),
          ),
          _compositor(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mensagemController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _adicionarErro() {
    if (!mounted) return;
    setState(() {
      _mensagens.add(
        const _Mensagem(
          texto: 'Não consegui responder agora. Tente novamente em instantes.',
          enviadaPeloUsuario: false,
        ),
      );
    });
  }

  Widget _compositor() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _mensagemController,
                      minLines: 1,
                      maxLines: 5,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _enviarMensagem(),
                      decoration: const InputDecoration(
                        hintText: 'Pergunte sobre o sistema ou um membro',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    tooltip: 'Enviar pergunta',
                    onPressed: _carregando ? null : _enviarMensagem,
                    icon: const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _enviarMensagem() async {
    final pergunta = _mensagemController.text.trim();
    if (pergunta.isEmpty || _carregando) return;

    setState(() {
      _mensagens.add(_Mensagem(texto: pergunta, enviadaPeloUsuario: true));
      _carregando = true;
    });
    _mensagemController.clear();
    _rolarParaFim();

    try {
      final resposta = await Supabase.instance.client.functions.invoke(
        'claudia-assistant',
        body: {'message': pergunta},
      );
      final data = resposta.data;
      final texto = data is Map ? data['answer'] : null;
      if (texto is! String || texto.trim().isEmpty) {
        throw const FormatException('Resposta vazia do assistente');
      }
      if (!mounted) return;
      setState(() {
        _mensagens.add(_Mensagem(texto: texto, enviadaPeloUsuario: false));
      });
    } on FunctionException {
      _adicionarErro();
    } catch (_) {
      _adicionarErro();
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
        _rolarParaFim();
      }
    }
  }

  void _rolarParaFim() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

class _BolhaMensagem extends StatelessWidget {
  final _Mensagem mensagem;

  const _BolhaMensagem({required this.mensagem});

  @override
  Widget build(BuildContext context) {
    final alinhamento = mensagem.enviadaPeloUsuario
        ? Alignment.centerRight
        : Alignment.centerLeft;
    final cor = mensagem.enviadaPeloUsuario
        ? Theme.of(context).colorScheme.primaryContainer
        : Colors.white;

    return Align(
      alignment: alinhamento,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 680),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: cor,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: SelectableText(mensagem.texto),
      ),
    );
  }
}

class _IndicadorDigitacao extends StatelessWidget {
  const _IndicadorDigitacao();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: SizedBox.square(
          dimension: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

class _Mensagem {
  final String texto;

  final bool enviadaPeloUsuario;
  const _Mensagem({required this.texto, required this.enviadaPeloUsuario});
}
