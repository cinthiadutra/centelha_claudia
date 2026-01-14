# 🚀 Guia de Expansão - Adicionando Novos Módulos

Este guia mostra como adicionar novos módulos (microserviços) à aplicação.

## 📋 Template para Novo Módulo

### Exemplo: Módulo de Vendas

## 1️⃣ Estrutura de Pastas

```bash
lib/modules/vendas/
├── data/
│   ├── datasources/
│   │   └── venda_datasource.dart
│   ├── models/
│   │   └── venda_model.dart
│   └── repositories/
│       └── venda_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── venda.dart
│   └── repositories/
│       └── venda_repository.dart
└── presentation/
    ├── bloc/
    │   ├── venda_bloc.dart
    │   ├── venda_event.dart
    │   └── venda_state.dart
    └── pages/
        ├── venda_list_page.dart
        └── venda_form_page.dart
```

## 2️⃣ Criar Entity (Domain)

```dart
// lib/modules/vendas/domain/entities/venda.dart

import 'package:equatable/equatable.dart';

class Venda extends Equatable {
  final String? id;
  final String clienteId;
  final List<ItemVenda> itens;
  final double total;
  final DateTime dataVenda;
  final String status; // 'pendente', 'aprovada', 'cancelada'

  const Venda({
    this.id,
    required this.clienteId,
    required this.itens,
    required this.total,
    required this.dataVenda,
    this.status = 'pendente',
  });

  Venda copyWith({
    String? id,
    String? clienteId,
    List<ItemVenda>? itens,
    double? total,
    DateTime? dataVenda,
    String? status,
  }) {
    return Venda(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      itens: itens ?? this.itens,
      total: total ?? this.total,
      dataVenda: dataVenda ?? this.dataVenda,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [id, clienteId, itens, total, dataVenda, status];
}

class ItemVenda extends Equatable {
  final String produtoId;
  final String nomeProduto;
  final int quantidade;
  final double precoUnitario;
  final double subtotal;

  const ItemVenda({
    required this.produtoId,
    required this.nomeProduto,
    required this.quantidade,
    required this.precoUnitario,
    required this.subtotal,
  });

  @override
  List<Object?> get props => [produtoId, nomeProduto, quantidade, precoUnitario, subtotal];
}
```

## 3️⃣ Criar Repository Interface (Domain)

```dart
// lib/modules/vendas/domain/repositories/venda_repository.dart

import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/venda.dart';

abstract class VendaRepository {
  Future<Either<Failure, List<Venda>>> getVendas();
  Future<Either<Failure, Venda>> getVendaById(String id);
  Future<Either<Failure, Venda>> createVenda(Venda venda);
  Future<Either<Failure, Venda>> updateVenda(Venda venda);
  Future<Either<Failure, void>> deleteVenda(String id);
  Future<Either<Failure, List<Venda>>> getVendasByCliente(String clienteId);
  Future<Either<Failure, List<Venda>>> getVendasByPeriodo(DateTime inicio, DateTime fim);
}
```

## 4️⃣ Criar Model (Data)

```dart
// lib/modules/vendas/data/models/venda_model.dart

import '../../domain/entities/venda.dart';

class VendaModel extends Venda {
  const VendaModel({
    super.id,
    required super.clienteId,
    required super.itens,
    required super.total,
    required super.dataVenda,
    super.status,
  });

  factory VendaModel.fromJson(Map<String, dynamic> json) {
    return VendaModel(
      id: json['id'],
      clienteId: json['clienteId'],
      itens: (json['itens'] as List)
          .map((item) => ItemVendaModel.fromJson(item))
          .toList(),
      total: json['total'].toDouble(),
      dataVenda: DateTime.parse(json['dataVenda']),
      status: json['status'] ?? 'pendente',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clienteId': clienteId,
      'itens': itens.map((item) => ItemVendaModel.fromEntity(item).toJson()).toList(),
      'total': total,
      'dataVenda': dataVenda.toIso8601String(),
      'status': status,
    };
  }

  factory VendaModel.fromEntity(Venda venda) {
    return VendaModel(
      id: venda.id,
      clienteId: venda.clienteId,
      itens: venda.itens,
      total: venda.total,
      dataVenda: venda.dataVenda,
      status: venda.status,
    );
  }
}

class ItemVendaModel extends ItemVenda {
  const ItemVendaModel({
    required super.produtoId,
    required super.nomeProduto,
    required super.quantidade,
    required super.precoUnitario,
    required super.subtotal,
  });

  factory ItemVendaModel.fromJson(Map<String, dynamic> json) {
    return ItemVendaModel(
      produtoId: json['produtoId'],
      nomeProduto: json['nomeProduto'],
      quantidade: json['quantidade'],
      precoUnitario: json['precoUnitario'].toDouble(),
      subtotal: json['subtotal'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'produtoId': produtoId,
      'nomeProduto': nomeProduto,
      'quantidade': quantidade,
      'precoUnitario': precoUnitario,
      'subtotal': subtotal,
    };
  }

  factory ItemVendaModel.fromEntity(ItemVenda item) {
    return ItemVendaModel(
      produtoId: item.produtoId,
      nomeProduto: item.nomeProduto,
      quantidade: item.quantidade,
      precoUnitario: item.precoUnitario,
      subtotal: item.subtotal,
    );
  }
}
```

## 5️⃣ Criar Datasource Mockado (Data)

```dart
// lib/modules/vendas/data/datasources/venda_datasource.dart

import '../models/venda_model.dart';

abstract class VendaDatasource {
  Future<List<VendaModel>> getVendas();
  Future<VendaModel> getVendaById(String id);
  Future<VendaModel> createVenda(VendaModel venda);
  Future<VendaModel> updateVenda(VendaModel venda);
  Future<void> deleteVenda(String id);
}

class VendaDatasourceMock implements VendaDatasource {
  final List<VendaModel> _vendas = [
    VendaModel(
      id: '1',
      clienteId: '1',
      itens: const [
        ItemVendaModel(
          produtoId: '1',
          nomeProduto: 'Produto A',
          quantidade: 2,
          precoUnitario: 50.0,
          subtotal: 100.0,
        ),
        ItemVendaModel(
          produtoId: '2',
          nomeProduto: 'Produto B',
          quantidade: 1,
          precoUnitario: 30.0,
          subtotal: 30.0,
        ),
      ],
      total: 130.0,
      dataVenda: DateTime(2024, 12, 1),
      status: 'aprovada',
    ),
  ];

  @override
  Future<List<VendaModel>> getVendas() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_vendas);
  }

  @override
  Future<VendaModel> getVendaById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _vendas.firstWhere((v) => v.id == id);
    } catch (e) {
      throw Exception('Venda não encontrada');
    }
  }

  @override
  Future<VendaModel> createVenda(VendaModel venda) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final novaVenda = VendaModel(
      id: (_vendas.length + 1).toString(),
      clienteId: venda.clienteId,
      itens: venda.itens,
      total: venda.total,
      dataVenda: venda.dataVenda,
      status: venda.status,
    );

    _vendas.add(novaVenda);
    return novaVenda;
  }

  @override
  Future<VendaModel> updateVenda(VendaModel venda) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _vendas.indexWhere((v) => v.id == venda.id);
    if (index == -1) {
      throw Exception('Venda não encontrada');
    }

    _vendas[index] = venda;
    return venda;
  }

  @override
  Future<void> deleteVenda(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _vendas.removeWhere((v) => v.id == id);
  }
}
```

## 6️⃣ Criar Repository Implementation (Data)

```dart
// lib/modules/vendas/data/repositories/venda_repository_impl.dart

import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../domain/entities/venda.dart';
import '../../domain/repositories/venda_repository.dart';
import '../datasources/venda_datasource.dart';
import '../models/venda_model.dart';

class VendaRepositoryImpl implements VendaRepository {
  final VendaDatasource datasource;

  VendaRepositoryImpl({required this.datasource});

  @override
  Future<Either<Failure, List<Venda>>> getVendas() async {
    try {
      final vendas = await datasource.getVendas();
      return Either.right(vendas);
    } catch (e) {
      return Either.left(ServerFailure('Erro ao buscar vendas: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Venda>> getVendaById(String id) async {
    try {
      final venda = await datasource.getVendaById(id);
      return Either.right(venda);
    } catch (e) {
      return Either.left(ServerFailure('Erro ao buscar venda: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Venda>> createVenda(Venda venda) async {
    try {
      if (venda.itens.isEmpty) {
        return const Either.left(ValidationFailure('A venda deve ter pelo menos um item'));
      }

      final model = VendaModel.fromEntity(venda);
      final resultado = await datasource.createVenda(model);
      return Either.right(resultado);
    } catch (e) {
      return Either.left(ServerFailure('Erro ao criar venda: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Venda>> updateVenda(Venda venda) async {
    try {
      final model = VendaModel.fromEntity(venda);
      final resultado = await datasource.updateVenda(model);
      return Either.right(resultado);
    } catch (e) {
      return Either.left(ServerFailure('Erro ao atualizar venda: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteVenda(String id) async {
    try {
      await datasource.deleteVenda(id);
      return const Either.right(null);
    } catch (e) {
      return Either.left(ServerFailure('Erro ao deletar venda: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Venda>>> getVendasByCliente(String clienteId) async {
    try {
      final vendas = await datasource.getVendas();
      final filtered = vendas.where((v) => v.clienteId == clienteId).toList();
      return Either.right(filtered);
    } catch (e) {
      return Either.left(ServerFailure('Erro ao buscar vendas do cliente: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Venda>>> getVendasByPeriodo(
    DateTime inicio,
    DateTime fim,
  ) async {
    try {
      final vendas = await datasource.getVendas();
      final filtered = vendas.where((v) {
        return v.dataVenda.isAfter(inicio) && v.dataVenda.isBefore(fim);
      }).toList();
      return Either.right(filtered);
    } catch (e) {
      return Either.left(ServerFailure('Erro ao buscar vendas por período: ${e.toString()}'));
    }
  }
}
```

## 7️⃣ Atualizar Dependency Injection

```dart
// lib/core/di/injection_container.dart

import 'package:get_it/get_it.dart';

// Cadastro
import '../../modules/cadastro/data/datasources/usuario_datasource.dart';
import '../../modules/cadastro/data/repositories/usuario_repository_impl.dart';
import '../../modules/cadastro/domain/repositories/usuario_repository.dart';
import '../../modules/cadastro/presentation/bloc/usuario_bloc.dart';

// Vendas - NOVO
import '../../modules/vendas/data/datasources/venda_datasource.dart';
import '../../modules/vendas/data/repositories/venda_repository_impl.dart';
import '../../modules/vendas/domain/repositories/venda_repository.dart';
import '../../modules/vendas/presentation/bloc/venda_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ============ CADASTRO ============
  // Bloc
  sl.registerFactory(() => UsuarioBloc(repository: sl()));
  // Repository
  sl.registerLazySingleton<UsuarioRepository>(
    () => UsuarioRepositoryImpl(datasource: sl()),
  );
  // Datasource
  sl.registerLazySingleton<UsuarioDatasource>(
    () => UsuarioDatasourceMock(),
  );

  // ============ VENDAS - NOVO ============
  // Bloc
  sl.registerFactory(() => VendaBloc(repository: sl()));
  // Repository
  sl.registerLazySingleton<VendaRepository>(
    () => VendaRepositoryImpl(datasource: sl()),
  );
  // Datasource
  sl.registerLazySingleton<VendaDatasource>(
    () => VendaDatasourceMock(),
  );
}
```

## 8️⃣ Criar BLoC (Presentation)

Copie e adapte os arquivos de BLoC do módulo de cadastro:

- `venda_event.dart`
- `venda_state.dart`
- `venda_bloc.dart`

## 9️⃣ Criar Pages (Presentation)

Adapte as páginas do módulo de cadastro para vendas:

- `venda_list_page.dart`
- `venda_form_page.dart`

## 🔟 Adicionar Navegação

```dart
// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'modules/cadastro/presentation/bloc/usuario_bloc.dart';
import 'modules/cadastro/presentation/pages/usuario_list_page.dart';
import 'modules/vendas/presentation/bloc/venda_bloc.dart';
import 'modules/vendas/presentation/pages/venda_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Centelha Claudia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Centelha Claudia'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _ModuleCard(
            title: 'Cadastro',
            icon: Icons.people,
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => di.sl<UsuarioBloc>(),
                    child: const UsuarioListPage(),
                  ),
                ),
              );
            },
          ),
          _ModuleCard(
            title: 'Vendas',
            icon: Icons.shopping_cart,
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => di.sl<VendaBloc>(),
                    child: const VendaListPage(),
                  ),
                ),
              );
            },
          ),
          // Adicione mais módulos aqui...
        ],
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ModuleCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: color),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## ✅ Checklist para Novo Módulo

- [ ] Criar entity no `domain/entities/`
- [ ] Criar repository interface no `domain/repositories/`
- [ ] Criar model no `data/models/`
- [ ] Criar datasource mockado no `data/datasources/`
- [ ] Criar repository implementation no `data/repositories/`
- [ ] Criar events no `presentation/bloc/`
- [ ] Criar states no `presentation/bloc/`
- [ ] Criar bloc no `presentation/bloc/`
- [ ] Criar páginas no `presentation/pages/`
- [ ] Registrar dependências no `injection_container.dart`
- [ ] Adicionar navegação no `main.dart`
- [ ] Testar todas as funcionalidades

## 🎯 Próximos Módulos Sugeridos

1. **Produtos/Estoque**

   - Cadastro de produtos
   - Controle de estoque
   - Categorias

2. **Relatórios**

   - Vendas por período
   - Produtos mais vendidos
   - Gráficos e dashboards

3. **Financeiro**
   - Contas a pagar
   - Contas a receber
   - Fluxo de caixa

---

**Siga este template e mantenha a consistência em todos os módulos! 🎯**
