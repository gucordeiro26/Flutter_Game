import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';
import '../widgets/status_bar.dart';
import '../models/item.dart';

class MissoesPage extends StatefulWidget {
  const MissoesPage({super.key});

  @override
  State<MissoesPage> createState() => _MissoesPageState();
}

class _MissoesPageState extends State<MissoesPage>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late AnimationController _attackController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _attackAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _attackController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
    _attackAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _attackController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _attackController.dispose();
    super.dispose();
  }

  void _animateAttack() {
    _attackController.forward().then((_) {
      _attackController.reverse();
    });
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arena de Combate'),
        centerTitle: true,
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: Consumer<GameState>(
        builder: (context, gameState, child) {
          if (gameState.personagemAtivo == null) {
            return _buildNoPersonagemSelected();
          }

          return Column(
            children: [
              // Status do personagem
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.indigo.shade50,
                child: _buildPersonagemStatus(gameState),
              ),

              // Arena de combate
              Expanded(
                child: gameState.emCombate
                    ? _buildCombatArena(gameState)
                    : _buildPreCombat(gameState),
              ),

              // Ações disponíveis
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey.shade100,
                child: _buildActionButtons(gameState),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNoPersonagemSelected() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_off, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 20),
          Text(
            'Nenhum personagem selecionado',
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Vá para a página Personagens e selecione um herói',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Voltar ao Menu'),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonagemStatus(GameState gameState) {
    final personagem = gameState.personagemAtivo!;

    return Row(
      children: [
        // Avatar do personagem
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.indigo.shade200,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              personagem.iconeClasse,
              style: const TextStyle(fontSize: 30),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Status bars
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${personagem.nome} - Nível ${personagem.level}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              StatusBar(
                label: 'HP',
                value: personagem.hp,
                maxValue: personagem.hpMax,
                icon: Icons.favorite,
                color: Colors.red,
              ),
              const SizedBox(height: 4),
              StatusBar(
                label: 'Mana',
                value: personagem.mana,
                maxValue: personagem.manaMax,
                icon: Icons.flash_on,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreCombat(GameState gameState) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          const Text(
            'Procurando por inimigos...',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 200,
            height: 60,
            child: ElevatedButton(
              onPressed: gameState.personagemAtivo!.estaMorto
                  ? null
                  : () => gameState.iniciarCombate(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'BUSCAR COMBATE',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCombatArena(GameState gameState) {
    final inimigo = gameState.inimigoAtual!;
    final personagem = gameState.personagemAtivo!;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Inimigo
          Expanded(
            child: AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_shakeAnimation.value, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.red.shade300, width: 3),
                        ),
                        child: Center(
                          child: Text(
                            inimigo.icone,
                            style: const TextStyle(fontSize: 60),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        inimigo.nome,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 200,
                        child: StatusBar(
                          label: 'HP',
                          value: inimigo.hp,
                          maxValue: inimigo.hpMax,
                          icon: Icons.favorite,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ATK: ${inimigo.ataque} | DEF: ${inimigo.defesa}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // VS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'VS',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // Personagem
          Expanded(
            child: AnimatedBuilder(
              animation: _attackAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _attackAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ATK: ${personagem.ataque} | DEF: ${personagem.defesa}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade100,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.indigo.shade300, width: 3),
                        ),
                        child: Center(
                          child: Text(
                            personagem.iconeClasse,
                            style: const TextStyle(fontSize: 50),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        personagem.nome,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(GameState gameState) {
    final personagem = gameState.personagemAtivo;
    if (personagem == null) return const SizedBox.shrink();

    if (!gameState.emCombate) {
      return _buildInventoryAndHealing(gameState);
    }

    return Column(
      children: [
        // Ações de combate
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: personagem.estaMorto
                    ? null
                    : () {
                        _animateAttack();
                        gameState.atacar();
                      },
                icon: const Icon(Icons.sports_martial_arts),
                label: const Text('ATACAR'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: personagem.estaMorto || !personagem.podeUsarMagia(20)
                    ? null
                    : () {
                        _animateAttack();
                        gameState.lancarMagia('Bola de Fogo', 20, 2);
                      },
                icon: const Icon(Icons.local_fire_department),
                label: const Text('MAGIA'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Itens utilizáveis
        if (gameState.inventario.isNotEmpty)
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: gameState.inventario.length,
              itemBuilder: (context, index) {
                final item = gameState.inventario[index];
                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    onPressed: personagem.estaMorto
                        ? null
                        : () => gameState.usarItem(item),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item.icone, style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 2),
                        Text(
                          item.nome.split(' ').first,
                          style: const TextStyle(fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildInventoryAndHealing(GameState gameState) {
    return Column(
      children: [
        // Ações de recuperação
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: gameState.personagemAtivo!.hp <
                        gameState.personagemAtivo!.hpMax
                    ? () {
                        gameState.personagemAtivo!.curar(30);
                        gameState
                            .adicionarHistorico('Descansou e recuperou 30 HP');
                      }
                    : null,
                icon: const Icon(Icons.healing),
                label: const Text('DESCANSAR'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: gameState.personagemAtivo!.mana <
                        gameState.personagemAtivo!.manaMax
                    ? () {
                        gameState.personagemAtivo!.recuperarMana(40);
                        gameState
                            .adicionarHistorico('Meditou e recuperou 40 Mana');
                      }
                    : null,
                icon: const Icon(Icons.self_improvement),
                label: const Text('MEDITAR'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),

        // Inventário
        if (gameState.inventario.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text(
            'Inventário',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: gameState.inventario.length,
              itemBuilder: (context, index) {
                final item = gameState.inventario[index];
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    onPressed: () => gameState.usarItem(item),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade600,
                      foregroundColor: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item.icone, style: const TextStyle(fontSize: 20)),
                        Text(
                          item.nome.split(' ').first,
                          style: const TextStyle(fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
