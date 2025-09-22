import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';
import '../models/item.dart';

class CidadesPage extends StatefulWidget {
  const CidadesPage({super.key});

  @override
  State<CidadesPage> createState() => _CidadesPageState();
}

class _CidadesPageState extends State<CidadesPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cidade'),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: Consumer<GameState>(
        builder: (context, gameState, child) {
          return Column(
            children: [
              // Header da cidade
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade100, Colors.green.shade50],
                  ),
                ),
                child: Row(
                  children: [
                    const Text(
                      '🏰',
                      style: TextStyle(fontSize: 40),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vila dos Heróis',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Centro comercial e de serviços'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Menu de navegação da cidade
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    _buildTabButton('🏪 Loja', 0),
                    _buildTabButton('⛑️ Curandeiro', 1),
                    _buildTabButton('🔮 Magias', 2),
                  ],
                ),
              ),
              
              // Conteúdo baseado na aba selecionada
              Expanded(
                child: _buildTabContent(gameState),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedIndex = index),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green.shade600 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(GameState gameState) {
    switch (_selectedIndex) {
      case 0:
        return _buildLoja(gameState);
      case 1:
        return _buildCurandeiro(gameState);
      case 2:
        return _buildMagias(gameState);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildLoja(GameState gameState) {
    final itensLoja = [
      {'item': Item(nome: 'Poção de Vida Pequena', tipo: TipoItem.cura, valor: 25), 'preco': 50},
      {'item': Item(nome: 'Poção de Mana Pequena', tipo: TipoItem.mana, valor: 20), 'preco': 40},
      {'item': Item(nome: 'Poção de Vida Grande', tipo: TipoItem.cura, valor: 50), 'preco': 100},
      {'item': Item(nome: 'Poção de Mana Grande', tipo: TipoItem.mana, valor: 40), 'preco': 80},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '🏪 Loja do Alquimista',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.monetization_on, color: Colors.amber.shade700, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '1000 Moedas', // Placeholder - você pode implementar sistema de moedas
                      style: TextStyle(
                        color: Colors.amber.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: itensLoja.length,
              itemBuilder: (context, index) {
                final itemData = itensLoja[index];
                final item = itemData['item'] as Item;
                final preco = itemData['preco'] as int;

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(item.icone, style: const TextStyle(fontSize: 24)),
                      ),
                    ),
                    title: Text(item.nome),
                    subtitle: Text(item.descricaoCompleta),
                    trailing: ElevatedButton(
                      onPressed: () {
                        gameState.adicionarItem(item);
                        gameState.adicionarHistorico('Comprou ${item.nome} por $preco moedas');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${item.nome} comprado!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('$preco 🪙'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurandeiro(GameState gameState) {
    final personagem = gameState.personagemAtivo;
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            '⛑️ Casa de Cura',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          if (personagem == null)
            const Expanded(
              child: Center(
                child: Text(
                  'Selecione um personagem primeiro',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            )
          else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                children: [
                  Text(
                    'Estado de ${personagem.nome}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatusCard(
                          'Vida',
                          '${personagem.hp}/${personagem.hpMax}',
                          Icons.favorite,
                          Colors.red,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatusCard(
                          'Mana',
                          '${personagem.mana}/${personagem.manaMax}',
                          Icons.flash_on,
                          Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: personagem.hp < personagem.hpMax
                      ? () {
                          final cura = personagem.hpMax - personagem.hp;
                          personagem.curar(cura);
                          gameState.adicionarHistorico('Curou completamente no curandeiro');
                          setState(() {}); // Força atualização da UI
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Vida completamente restaurada!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      : null,
                    icon: const Icon(Icons.healing),
                    label: const Text('Cura Completa'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: personagem.mana < personagem.manaMax
                      ? () {
                          final restauracao = personagem.manaMax - personagem.mana;
                          personagem.recuperarMana(restauracao);
                          gameState.adicionarHistorico('Restaurou mana no curandeiro');
                          setState(() {}); // Força atualização da UI
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Mana completamente restaurada!'),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        }
                      : null,
                    icon: const Icon(Icons.flash_on),
                    label: const Text('Restaurar Mana'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: (personagem.hp < personagem.hpMax || personagem.mana < personagem.manaMax)
                  ? () {
                      final curaTotal = personagem.hpMax - personagem.hp;
                      final manaTotal = personagem.manaMax - personagem.mana;
                      personagem.curar(curaTotal);
                      personagem.recuperarMana(manaTotal);
                      gameState.adicionarHistorico('Recuperação completa no curandeiro');
                      setState(() {}); // Força atualização da UI
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Recuperação completa realizada!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  : null,
                icon: const Icon(Icons.spa),
                label: const Text('Recuperação Completa'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMagias(GameState gameState) {
    final personagem = gameState.personagemAtivo;
    
    final magias = [
      {'nome': 'Bola de Fogo', 'custo': 20, 'multiplicador': 2, 'icone': '🔥'},
      {'nome': 'Raio Congelante', 'custo': 25, 'multiplicador': 3, 'icone': '❄️'},
      {'nome': 'Raio', 'custo': 30, 'multiplicador': 4, 'icone': '⚡'},
      {'nome': 'Cura Mágica', 'custo': 15, 'multiplicador': 0, 'icone': '✨'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🔮 Academia de Magia',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          if (personagem == null)
            const Expanded(
              child: Center(
                child: Text(
                  'Selecione um personagem primeiro',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ),
            )
          else ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.flash_on, color: Colors.blue.shade600),
                  const SizedBox(width: 8),
                  Text('Mana: ${personagem.mana}/${personagem.manaMax}'),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            Expanded(
              child: ListView.builder(
                itemCount: magias.length,
                itemBuilder: (context, index) {
                  final magia = magias[index];
                  final nome = magia['nome'] as String;
                  final custo = magia['custo'] as int;
                  final multiplicador = magia['multiplicador'] as int;
                  final icone = magia['icone'] as String;
                  final podeUsar = personagem.podeUsarMagia(custo);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: podeUsar 
                            ? Colors.purple.shade100 
                            : Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(icone, style: const TextStyle(fontSize: 24)),
                        ),
                      ),
                      title: Text(nome),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Custo: $custo Mana'),
                          if (multiplicador > 0)
                            Text('Dano: ${personagem.ataque}x$multiplicador = ${personagem.ataque * multiplicador}'),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: podeUsar && !gameState.emCombate
                          ? () {
                              if (nome == 'Cura Mágica') {
                                personagem.gastarMana(custo);
                                personagem.curar(personagem.ataque * 2);
                                gameState.adicionarHistorico('Usou $nome e curou ${personagem.ataque * 2} HP');
                              } else {
                                personagem.gastarMana(custo);
                                gameState.adicionarHistorico('Praticou $nome (gastou $custo mana)');
                              }
                              setState(() {}); // Força atualização da UI
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('$nome executada!'),
                                  backgroundColor: Colors.purple,
                                ),
                              );
                            }
                          : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade600,
                          foregroundColor: Colors.white,
                        ),
                        child: gameState.emCombate 
                          ? const Text('Em Combate')
                          : const Text('Usar'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}