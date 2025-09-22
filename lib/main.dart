import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/game_state.dart';
import 'pages/personagens_page.dart';
import 'pages/itens_page.dart';
import 'pages/missoes_page.dart';
import 'pages/cidades_page.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameState(),
      child: MaterialApp(
        title: 'Mini RPG Didático',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _abrir(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini RPG Didático'),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
      ),
      body: Consumer<GameState>(
        builder: (context, gameState, child) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Header com info do personagem ativo
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigo.shade100, Colors.indigo.shade50],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.indigo.shade200),
                  ),
                  child: gameState.personagemAtivo != null
                    ? Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                gameState.personagemAtivo!.iconeClasse,
                                style: const TextStyle(fontSize: 25),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${gameState.personagemAtivo!.nome} - Nível ${gameState.personagemAtivo!.level}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'HP: ${gameState.personagemAtivo!.hp}/${gameState.personagemAtivo!.hpMax} | '
                                  'Mana: ${gameState.personagemAtivo!.mana}/${gameState.personagemAtivo!.manaMax}',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : const Column(
                        children: [
                          Icon(Icons.person_search, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            'Nenhum personagem selecionado',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                ),
                
                const SizedBox(height: 30),
                
                // Logo/Título
                const Text(
                  '⚔️ Mini RPG Didático 🏰',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 30),
                
                // Menu de navegação
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMenuButton(
                        context: context,
                        title: '👤 Personagens',
                        subtitle: 'Escolha seu herói',
                        page: const PersonagensPage(),
                        color: Colors.indigo,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      _buildMenuButton(
                        context: context,
                        title: '⚔️ Missões',
                        subtitle: 'Arena de combate',
                        page: const MissoesPage(),
                        color: Colors.red,
                        enabled: gameState.personagemAtivo != null,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      _buildMenuButton(
                        context: context,
                        title: '🎒 Inventário',
                        subtitle: 'Gerencie seus itens',
                        page: const ItensPage(),
                        color: Colors.amber,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      _buildMenuButton(
                        context: context,
                        title: '🏘️ Cidades',
                        subtitle: 'Serviços e lojas',
                        page: const CidadesPage(),
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
                
                // Histórico recente
                if (gameState.historicoGlobal.isNotEmpty) ...[
                  const Divider(),
                  const Text(
                    'Última Ação:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    gameState.historicoGlobal.first,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required Widget page,
    required Color color,
    bool enabled = true,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: ElevatedButton(
        onPressed: enabled ? () => _abrir(context, page) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? color.shade600 : Colors.grey.shade400,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: enabled ? 4 : 1,
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.8),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}