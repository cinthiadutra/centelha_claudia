# 🔌 Guia de Integração com API

Este documento descreve como migrar dos datasources mockados para uma API real.

## 📋 Estrutura da API Esperada

### Endpoints do Módulo de Cadastro

```
Base URL: https://api.centelha.com/v1
```

#### Usuários

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/usuarios` | Lista todos os usuários |
| GET | `/usuarios/{id}` | Busca usuário por ID |
| POST | `/usuarios` | Cria novo usuário |
| PUT | `/usuarios/{id}` | Atualiza usuário |
| DELETE | `/usuarios/{id}` | Remove usuário |

### Formato dos Dados

#### Usuario

**Request (POST/PUT):**
```json
{
  "nome": "João Silva",
  "email": "joao@email.com",
  "telefone": "11999999999",
  "cpf": "12345678900",
  "ativo": true
}
```

**Response:**
```json
{
  "id": "uuid-gerado-pelo-backend",
  "nome": "João Silva",
  "email": "joao@email.com",
  "telefone": "11999999999",
  "cpf": "12345678900",
  "dataCadastro": "2024-12-18T10:30:00Z",
  "ativo": true
}
```

**Response (Lista):**
```json
{
  "data": [
    {
      "id": "uuid-1",
      "nome": "João Silva",
      "email": "joao@email.com",
      ...
    },
    {
      "id": "uuid-2",
      "nome": "Maria Santos",
      "email": "maria@email.com",
      ...
    }
  ],
  "total": 2,
  "page": 1,
  "pageSize": 10
}
```

## 🔧 Implementação do Datasource Remoto

### 1. Criar classe de datasource remoto

```dart
// lib/modules/cadastro/data/datasources/usuario_datasource_remote.dart

import 'package:dio/dio.dart';
import '../models/usuario_model.dart';
import 'usuario_datasource.dart';

class UsuarioDatasourceRemote implements UsuarioDatasource {
  final Dio dio;

  UsuarioDatasourceRemote({required this.dio});

  @override
  Future<List<UsuarioModel>> getUsuarios() async {
    try {
      final response = await dio.get('/usuarios');
      
      // Se a API retorna { data: [...], total: 10 }
      final List<dynamic> data = response.data['data'] ?? response.data;
      
      return data.map((json) => UsuarioModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<UsuarioModel> getUsuarioById(String id) async {
    try {
      final response = await dio.get('/usuarios/$id');
      return UsuarioModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<UsuarioModel> createUsuario(UsuarioModel usuario) async {
    try {
      final response = await dio.post(
        '/usuarios',
        data: usuario.toJson(),
      );
      return UsuarioModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<UsuarioModel> updateUsuario(UsuarioModel usuario) async {
    try {
      final response = await dio.put(
        '/usuarios/${usuario.id}',
        data: usuario.toJson(),
      );
      return UsuarioModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteUsuario(String id) async {
    try {
      await dio.delete('/usuarios/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return Exception('Timeout na conexão com o servidor');
      
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data['message'] ?? 'Erro no servidor';
        
        switch (statusCode) {
          case 400:
            return Exception('Requisição inválida: $message');
          case 401:
            return Exception('Não autorizado. Faça login novamente.');
          case 403:
            return Exception('Acesso negado');
          case 404:
            return Exception('Recurso não encontrado');
          case 500:
            return Exception('Erro interno do servidor');
          default:
            return Exception('Erro: $message');
        }
      
      case DioExceptionType.connectionError:
        return Exception('Sem conexão com a internet');
      
      default:
        return Exception('Erro desconhecido: ${e.message}');
    }
  }
}
```

### 2. Configurar Dio

```dart
// lib/core/network/dio_client.dart

import 'package:dio/dio.dart';

class DioClient {
  static Dio create({
    required String baseUrl,
    String? token,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Adicionar token de autenticação se existir
    if (token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }

    // Interceptor para logs (apenas em debug)
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );

    // Interceptor para refresh token (se necessário)
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Pode adicionar lógica antes de cada request
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Pode processar resposta
          return handler.next(response);
        },
        onError: (error, handler) async {
          // Pode tratar erros globalmente
          // Ex: refresh token em caso de 401
          if (error.response?.statusCode == 401) {
            // Lógica de refresh token aqui
          }
          return handler.next(error);
        },
      ),
    );

    return dio;
  }
}
```

### 3. Atualizar Dependency Injection

```dart
// lib/core/di/injection_container.dart

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../../modules/cadastro/data/datasources/usuario_datasource.dart';
import '../../modules/cadastro/data/datasources/usuario_datasource_remote.dart';
import '../../modules/cadastro/data/repositories/usuario_repository_impl.dart';
import '../../modules/cadastro/domain/repositories/usuario_repository.dart';
import '../../modules/cadastro/presentation/bloc/usuario_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ============ CORE ============
  
  // Dio Client
  sl.registerLazySingleton<Dio>(
    () => DioClient.create(
      baseUrl: 'https://api.centelha.com/v1',
      // token: 'seu-token-aqui', // Pode vir de um storage seguro
    ),
  );

  // ============ CADASTRO ============
  
  // Bloc
  sl.registerFactory(
    () => UsuarioBloc(repository: sl()),
  );

  // Repository
  sl.registerLazySingleton<UsuarioRepository>(
    () => UsuarioRepositoryImpl(datasource: sl()),
  );

  // Datasource - MUDANÇA AQUI
  sl.registerLazySingleton<UsuarioDatasource>(
    () => UsuarioDatasourceRemote(dio: sl()), // <- Usar Remote em vez de Mock
    // () => UsuarioDatasourceMock(), // <- Comentar o mock
  );
}
```

### 4. Configuração Baseada em Ambiente

```dart
// lib/core/config/environment.dart

enum Environment {
  development,
  staging,
  production,
}

class EnvironmentConfig {
  static const Environment current = Environment.development;

  static String get apiBaseUrl {
    switch (current) {
      case Environment.development:
        return 'http://localhost:3000/api/v1';
      case Environment.staging:
        return 'https://staging-api.centelha.com/v1';
      case Environment.production:
        return 'https://api.centelha.com/v1';
    }
  }

  static bool get useMockData {
    return current == Environment.development;
  }

  static Duration get requestTimeout {
    return const Duration(seconds: 30);
  }
}
```

### 5. Dependency Injection com Ambiente

```dart
// lib/core/di/injection_container.dart

import '../config/environment.dart';

Future<void> init() async {
  // Dio Client
  sl.registerLazySingleton<Dio>(
    () => DioClient.create(
      baseUrl: EnvironmentConfig.apiBaseUrl,
    ),
  );

  // Datasource - Escolhe baseado no ambiente
  sl.registerLazySingleton<UsuarioDatasource>(
    () => EnvironmentConfig.useMockData
        ? UsuarioDatasourceMock()
        : UsuarioDatasourceRemote(dio: sl()),
  );
}
```

## 🔒 Autenticação

### Implementar interceptor para token

```dart
// lib/core/network/auth_interceptor.dart

import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Buscar token do storage
    // final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString('auth_token');
    
    final token = 'seu-token-aqui'; // Temporário
    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token expirado - tentar refresh
      // final refreshed = await _refreshToken();
      // if (refreshed) {
      //   return handler.resolve(await _retry(err.requestOptions));
      // }
    }
    
    return handler.next(err);
  }
}
```

## 📊 Tratamento de Paginação

Se a API usar paginação:

```dart
// lib/modules/cadastro/data/datasources/usuario_datasource.dart

abstract class UsuarioDatasource {
  Future<PaginatedResponse<UsuarioModel>> getUsuarios({
    int page = 1,
    int pageSize = 10,
  });
  // ... outros métodos
}

class PaginatedResponse<T> {
  final List<T> data;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  PaginatedResponse({
    required this.data,
    required this.total,
    required this.page,
    required this.pageSize,
  }) : totalPages = (total / pageSize).ceil();
}
```

## 🧪 Testes com API

### Criar testes de integração

```dart
// test/modules/cadastro/data/datasources/usuario_datasource_remote_test.dart

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  late UsuarioDatasourceRemote datasource;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    datasource = UsuarioDatasourceRemote(dio: mockDio);
  });

  group('getUsuarios', () {
    test('deve retornar lista de usuários quando bem-sucedido', () async {
      // Arrange
      when(mockDio.get('/usuarios')).thenAnswer(
        (_) async => Response(
          data: {
            'data': [
              {'id': '1', 'nome': 'João', 'email': 'joao@email.com'},
            ],
          },
          statusCode: 200,
          requestOptions: RequestOptions(path: '/usuarios'),
        ),
      );

      // Act
      final result = await datasource.getUsuarios();

      // Assert
      expect(result, isA<List<UsuarioModel>>());
      expect(result.length, 1);
    });
  });
}
```

## ✅ Checklist de Migração

- [ ] Definir URLs da API (dev, staging, prod)
- [ ] Criar `usuario_datasource_remote.dart`
- [ ] Configurar Dio com interceptors
- [ ] Implementar tratamento de erros
- [ ] Adicionar autenticação (se necessário)
- [ ] Configurar ambientes
- [ ] Atualizar `injection_container.dart`
- [ ] Testar todos os endpoints
- [ ] Adicionar logs para debug
- [ ] Implementar retry logic (opcional)
- [ ] Adicionar cache (opcional)
- [ ] Documentar APIs no Swagger/OpenAPI

## 🚀 Próximos Passos

1. **Ambiente de Desenvolvimento**: Use mock enquanto API está sendo desenvolvida
2. **Ambiente de Staging**: Teste com API de homologação
3. **Ambiente de Produção**: Deploy com API real

---

**A estrutura já está preparada! Basta trocar o datasource quando a API estiver pronta! 🎯**
