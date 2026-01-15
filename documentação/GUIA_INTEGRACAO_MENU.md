# Guia: Integrar Páginas de Lançamento de Notas ao App

Este guia mostra como adicionar as 4 novas páginas ao menu/navegação principal do aplicativo.

## 📋 Páginas a Integrar

1. `LancarConceitosPage` - Notas C e D (Conceitos de Grupo)
2. `GerenciarEscalasPage` - Notas F e G (Escalas)
3. `GerenciarMensalidadesPage` - Nota H (Mensalidades)
4. `LancarConceitosEspeciaisPage` - Notas I e J (Conceitos Especiais)

## 🎯 Opção 1: Menu Drawer Lateral

Adicionar as páginas a um menu drawer lateral é a opção mais organizada.

### Passo 1: Criar o Drawer

Crie um arquivo `lib/core/widgets/main_drawer.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:sistema_ponto/sistema_ponto.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purple],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.star, size: 48, color: Colors.white),
                SizedBox(height: 8),
                Text(
                  'Sistema de Pontos',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // VISUALIZAÇÃO
          _buildSectionHeader('VISUALIZAÇÃO'),
          ListTile(
            leading: const Icon(Icons.emoji_events),
            title: const Text('Ranking Mensal'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RankingMensalPage(),
                ),
              );
            },
          ),

          const Divider(),

          // LANÇAMENTO DE NOTAS
          _buildSectionHeader('LANÇAMENTO DE NOTAS'),
          ListTile(
            leading: const Icon(Icons.group_work),
            title: const Text('Conceitos de Grupo'),
            subtitle: const Text('Notas C e D'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LancarConceitosPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.family_restroom),
            title: const Text('Conceitos Especiais'),
            subtitle: const Text('Notas I e J'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LancarConceitosEspeciaisPage(),
                ),
              );
            },
          ),

          const Divider(),

          // GESTÃO
          _buildSectionHeader('GESTÃO'),
          ListTile(
            leading: const Icon(Icons.calendar_month),
            title: const Text('Gerenciar Escalas'),
            subtitle: const Text('Notas F e G'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const GerenciarEscalasPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.payments),
            title: const Text('Gerenciar Mensalidades'),
            subtitle: const Text('Nota H'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const GerenciarMensalidadesPage(),
                ),
              );
            },
          ),

          const Divider(),

          // IMPORTAÇÃO
          _buildSectionHeader('IMPORTAÇÃO'),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Importar Presenças'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ImportarPresencaPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Importar Calendário'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ImportarCalendarioPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  static Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}
```

### Passo 2: Adicionar Drawer à HomePage

No `lib/main.dart` ou onde está sua página principal:

```dart
import 'package:flutter/material.dart';
import 'core/widgets/main_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Centelha Claudia'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      drawer: const MainDrawer(), // ← Adicionar aqui
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, size: 100, color: Colors.deepPurple),
            const SizedBox(height: 24),
            const Text(
              'Sistema de Pontos',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RankingMensalPage(),
                  ),
                );
              },
              icon: const Icon(Icons.emoji_events),
              label: const Text('Ver Ranking'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🎯 Opção 2: Cards na HomePage

Se preferir cards na tela inicial em vez de drawer:

```dart
import 'package:flutter/material.dart';
import 'package:sistema_ponto/sistema_ponto.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Pontos'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildMenuCard(
            context,
            icon: Icons.emoji_events,
            title: 'Ranking',
            subtitle: 'Ver pontuação',
            color: Colors.amber,
            page: const RankingMensalPage(),
          ),
          _buildMenuCard(
            context,
            icon: Icons.group_work,
            title: 'Conceitos de Grupo',
            subtitle: 'Notas C e D',
            color: Colors.blue,
            page: const LancarConceitosPage(),
          ),
          _buildMenuCard(
            context,
            icon: Icons.calendar_month,
            title: 'Escalas',
            subtitle: 'Notas F e G',
            color: Colors.purple,
            page: const GerenciarEscalasPage(),
          ),
          _buildMenuCard(
            context,
            icon: Icons.payments,
            title: 'Mensalidades',
            subtitle: 'Nota H',
            color: Colors.green,
            page: const GerenciarMensalidadesPage(),
          ),
          _buildMenuCard(
            context,
            icon: Icons.family_restroom,
            title: 'Conceitos Especiais',
            subtitle: 'Notas I e J',
            color: Colors.deepPurple,
            page: const LancarConceitosEspeciaisPage(),
          ),
          _buildMenuCard(
            context,
            icon: Icons.upload_file,
            title: 'Importar Presenças',
            subtitle: 'Arquivo CSV',
            color: Colors.orange,
            page: const ImportarPresencaPage(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required Widget page,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🎯 Opção 3: Bottom Navigation Bar

Para navegação mais moderna com tabs na parte inferior:

```dart
import 'package:flutter/material.dart';
import 'package:sistema_ponto/sistema_ponto.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const RankingMensalPage(),
    const LancarConceitosPage(),
    const GerenciarEscalasPage(),
    const GerenciarMensalidadesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Colors.deepPurple,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Ranking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_work),
            label: 'Conceitos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Escalas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payments),
            label: 'Mensalidades',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Abrir menu com mais opções
          _showMoreOptionsBottomSheet(context);
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.more_horiz),
      ),
    );
  }

  void _showMoreOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.family_restroom),
            title: const Text('Conceitos Especiais (I e J)'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LancarConceitosEspeciaisPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Importar Presenças'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ImportarPresencaPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Importar Calendário'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ImportarCalendarioPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
```

---

## ✅ Checklist de Integração

- [ ] Escolher método de navegação (Drawer / Cards / Bottom Nav)
- [ ] Importar as páginas no arquivo principal
- [ ] Adicionar navegação para cada página
- [ ] Testar navegação entre páginas
- [ ] Garantir que o AppBar de cada página tem botão voltar
- [ ] Adicionar ícones adequados
- [ ] Revisar cores e tema
- [ ] Testar em diferentes tamanhos de tela

---

## 🎨 Personalização de Cores

As cores atuais das páginas:

| Página              | Cor Principal        |
| ------------------- | -------------------- |
| Ranking             | `Colors.deepPurple`  |
| Conceitos Grupo     | `Colors.deepPurple`  |
| Escalas             | `Colors.deepPurple`  |
| Mensalidades        | `Colors.green[700]`  |
| Conceitos Especiais | `Colors.purple[700]` |

Para manter consistência visual, você pode:

1. Usar a mesma cor em todas (`Colors.deepPurple`)
2. Ou criar categorias:
   - Visualização: Âmbar/Dourado
   - Lançamento: Azul/Roxo
   - Gestão: Verde
   - Especiais: Roxo escuro

---

## 🔐 Controle de Permissões (Futuro)

Quando implementar autenticação, você pode esconder opções baseado no papel do usuário:

```dart
// Exemplo no Drawer
if (userRole == 'lider') ...[
  ListTile(
    leading: const Icon(Icons.group_work),
    title: const Text('Conceitos de Grupo'),
    onTap: () => Navigator.push(...),
  ),
],

if (userRole == 'tesouraria') ...[
  ListTile(
    leading: const Icon(Icons.payments),
    title: const Text('Gerenciar Mensalidades'),
    onTap: () => Navigator.push(...),
  ),
],

if (userRole == 'tata' || userRole == 'pais_maes') ...[
  ListTile(
    leading: const Icon(Icons.family_restroom),
    title: const Text('Conceitos Especiais'),
    onTap: () => Navigator.push(...),
  ),
],
```

---

## 📱 Dica: Splash Screen

Para uma experiência mais profissional, considere adicionar uma splash screen que mostra enquanto o app carrega:

```dart
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, size: 100, color: Colors.white),
            const SizedBox(height: 24),
            const Text(
              'Centelha Claudia',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sistema de Pontos',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
```

---

## 💡 Recomendação

Para este projeto, recomendo a **Opção 1 (Drawer)** porque:

✅ Permite organizar muitas páginas sem poluir a interface
✅ É um padrão conhecido do Material Design
✅ Facilita adicionar mais páginas no futuro
✅ Permite criar categorias claras
✅ Funciona bem em mobile e tablet

Use a **Opção 2 (Cards)** se houver poucas funcionalidades principais e você quiser tudo visível de imediato.

Use a **Opção 3 (Bottom Nav)** se houver 3-5 páginas principais que o usuário precisa alternar frequentemente.
