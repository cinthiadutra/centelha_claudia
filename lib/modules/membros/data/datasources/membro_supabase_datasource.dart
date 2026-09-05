import 'dart:developer';

import '../../../../core/error/exceptions.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/utils/string_utils.dart';
import '../models/membro_model.dart';
import 'membro_datasource.dart';

/// Datasource para operações com membros usando Supabase
/// NOTA: Esta implementação é temporária e usa sincronização forçada.
/// Em uma implementação ideal, toda a arquitetura deveria ser async.
class MembroSupabaseDatasource implements MembroDatasource {
  final SupabaseService _supabaseService;

  // Cache local para simular operações síncronas
  final List<MembroModel> _cache = [];
  bool _cacheCarregado = false;

  MembroSupabaseDatasource(this._supabaseService);

  @override
  void adicionarMembro(MembroModel membro) {
    // Operação assíncrona em background
    final data = membro.toJson();
    data.remove('id');
    data.remove('data_criacao');
    data.remove('data_ultima_alteracao');

    _garantirCacheCarregado()
        .then((_) {
          return _supabaseService.client.from('membros_historico').insert(data);
        })
        .then((_) {
          _cache.add(membro);
        })
        .catchError((error) {
          throw ServerException('Erro ao adicionar membro: $error');
        });
  }

  @override
  void atualizarMembro(MembroModel membro) {
    if (membro.id == null) {
      throw ServerException('ID é obrigatório para atualização');
    }

    final data = membro.toJson();
    data.remove('data_criacao');

    _supabaseService.client
        .from('membros_historico')
        .update(data)
        .eq('id', membro.id!)
        .then((_) {
          final index = _cache.indexWhere((m) => m.id == membro.id);
          if (index != -1) {
            _cache[index] = membro;
          }
        })
        .catchError((error) {
          throw ServerException('Erro ao atualizar membro: $error');
        });
  }

  @override
  Future<void> garantirDadosCarregados() async {
    await _garantirCacheCarregado();
  }

  @override
  MembroModel? getMembroPorCpf(String cpf) {
    return _cache.cast<MembroModel?>().firstWhere(
      (m) => m?.cpf == cpf,
      orElse: () => null,
    );
  }

  @override
  MembroModel? getMembroPorNumero(String numero) {
    log('🔍 [MEMBROS DATASOURCE] Buscando membro por número: "$numero"');
    log('📊 [MEMBROS DATASOURCE] Cache tem ${_cache.length} membros');

    final resultado = _cache.cast<MembroModel?>().firstWhere(
      (m) {
        final match = m?.numeroCadastro == numero;
        if (match) {
          log(
            '✅ [MEMBROS DATASOURCE] Encontrado: ${m?.nome} (${m?.numeroCadastro})',
          );
        }
        return match;
      },
      orElse: () {
        log('⚠️ [MEMBROS DATASOURCE] Membro não encontrado no cache');
        log('   Exemplos de números no cache:');
        _cache.take(5).forEach((m) {
          log('   - ${m.numeroCadastro} (${m.nome})');
        });
        return null;
      },
    );

    return resultado;
  }

  @override
  List<MembroModel> getMembros() {
    return List.from(_cache);
  }

  @override
  List<MembroModel> pesquisarPorNome(String nome) {
    final nomeNormalizado = normalizarParaBusca(nome);
    return _cache
        .where((m) => normalizarParaBusca(m.nome).contains(nomeNormalizado))
        .toList();
  }

  @override
  void removerMembro(String numero) {
    _supabaseService.client
        .from('membros_historico')
        .delete()
        .eq('cadastro', numero)
        .then((_) {
          _cache.removeWhere((m) => m.numeroCadastro == numero);
        })
        .catchError((error) {
          throw ServerException('Erro ao remover membro: $error');
        });
  }

  /// Carrega cache inicial
  Future<void> _carregarCache() async {
    if (_cacheCarregado) return;

    try {
      log('🔍 [MEMBROS DATASOURCE] Consultando tabela membros_historico...');
      final response = await _supabaseService.client
          .from('membros_historico')
          .select()
          .order('nome', ascending: true);

      _cache.clear();
      _cache.addAll(
        (response as List).map((json) => MembroModel.fromJson(json)).toList(),
      );
      _cacheCarregado = true;
      log(
        '✅ [MEMBROS DATASOURCE] ${_cache.length} membros carregados do Supabase',
      );
    } catch (e) {
      log('❌ [MEMBROS DATASOURCE] Erro ao carregar: $e');
      // Cache não carregado, retornará lista vazia
    }
  }

  /// Garante que o cache está carregado antes de qualquer operação
  Future<void> _garantirCacheCarregado() async {
    if (_cacheCarregado) return;
    await _carregarCache();
  }
}
