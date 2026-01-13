# Configuração da Injeção de Dependências para Sistema de Ponto

Este arquivo mostra como configurar a injeção de dependências no app principal para usar o package `sistema_ponto`.

## 1. No arquivo `lib/core/di/injection_container.dart`

```dart
import 'package:sistema_ponto/sistema_ponto.dart';

Future<void> init() async {
  // ... outros registros ...

  // Sistema de Ponto - Datasource
  sl.registerLazySingleton<PontoDatasource>(
    () => SupabasePontoDatasource(sl<SupabaseService>().client),
  );

  // Sistema de Ponto - Repository
  sl.registerLazySingleton<PontoRepository>(
    () => PontoRepositoryImpl(sl<PontoDatasource>()),
  );

  // Sistema de Ponto - UseCases
  sl.registerLazySingleton(() => RegistrarPontoUseCase(sl<PontoRepository>()));
  sl.registerLazySingleton(() => ObterHistoricoPontoUseCase(sl<PontoRepository>()));

  // Sistema de Ponto - BLoC
  sl.registerFactory(
    () => PontoBloc(
      registrarPontoUseCase: sl<RegistrarPontoUseCase>(),
      obterHistoricoUseCase: sl<ObterHistoricoPontoUseCase>(),
      repository: sl<PontoRepository>(),
    ),
  );
}
```

## 2. No arquivo `lib/main.dart`

Adicione as rotas para o sistema de ponto:

```dart
import 'package:sistema_ponto/sistema_ponto.dart';

// Nas rotas GetX
getPages: [
  // ... outras rotas ...

  // Rotas do Sistema de Ponto
  GetPage(
    name: '/ponto/registrar',
    page: () => BlocProvider(
      create: (_) => sl<PontoBloc>(),
      child: const RegistrarPontoPage(),
    ),
  ),
  GetPage(
    name: '/ponto/historico',
    page: () => BlocProvider(
      create: (_) => sl<PontoBloc>(),
      child: const HistoricoPontoPage(),
    ),
  ),
],
```

## 3. Uso nas telas

### Registrar ponto:

```dart
Get.toNamed(
  '/ponto/registrar',
  arguments: {
    'membroId': 'uuid-do-membro',
    'membroNome': 'Nome do Membro',
  },
);
```

### Ver histórico:

```dart
Get.toNamed(
  '/ponto/historico',
  arguments: {
    'membroId': 'uuid-do-membro',
    'membroNome': 'Nome do Membro',
  },
);
```
