import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';
import '../models/item.dart';

class ItensPage extends StatefulWidget {
  const ItensPage({super.key});

  @override
  State<ItensPage> createState() => _ItensPageState();
}

class _ItensPageState extends State<ItensPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventário'),
        centerTitle: true,
        backgroundColor: Colors.amber.shade700,
        foregroundColor: Colors.white,
      ),
      body: Consumer<GameState>(
        builder: (context, gameState, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header do inventário
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.backpack,
                        size: 40,
                        color: Colors.amber.shade700,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Seu Inventário',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${gameState.inventario.length} itens',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Lista de itens ou mensagem vazia
                Expanded(
                  child: gameState.inventario.isEmpty
                    ? _buildEmptyInventory()
                    : _buildInventoryList(gameState),
                ),
                
                // Botões de ação
                const Divider(),
                _buildActionButtons(gameState),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyInventory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Inventário Vazio',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Vença batalhas para conseguir itens!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryList(GameState gameState) {
    return ListView.builder(
      itemCount: gameState.inventario.length,
      itemBuilder: (context, index) {
        final item = gameState.inventario[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Card(
            elevation: 2,
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getItemColor(item.tipo).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    item.icone,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              title: Text(
                item.nome,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.tipoString),
                  const SizedBox(height: 4),
                  Text(
                    item.descricaoCompleta,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              trailing: gameState.personagemAtivo != null
                ? ElevatedButton(
                    onPressed: () => gameState.usarItem(item),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getItemColor(item.tipo),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Text('Usar'),
                  )
                : null,
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(GameState gameState) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _adicionarItemTeste(gameState),
            icon: const Icon(Icons.add),
            label: const Text('Adicionar Item Teste'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: gameState.inventario.isNotEmpty
              ? () => _limparInventario(gameState)
              : null,
            icon: const Icon(Icons.clear_all),
            label: const Text('Limpar Tudo'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void _adicionarItemTeste(GameState gameState) {
    final itensTest = [
      Item(nome: 'Poção de Vida Pequena', tipo: TipoItem.cura, valor: 25),
      Item(nome: 'Poção de Mana Pequena', tipo: TipoItem.mana, valor: 20),
      Item(nome: 'Poção de Vida Grande', tipo: TipoItem.cura, valor: 50),
      Item(nome: 'Poção de Mana Grande', tipo: TipoItem.mana, valor: 40),
    ];
    
    final itemAleatorio = itensTest[DateTime.now().millisecond % itensTest.length];
    gameState.adicionarItem(itemAleatorio);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${itemAleatorio.nome} adicionado ao inventário!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _limparInventario(GameState gameState) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Limpar Inventário'),
          content: const Text('Tem certeza que deseja remover todos os itens?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                gameState.inventario.clear();
                gameState.adicionarHistorico('Inventário limpo');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Inventário limpo!'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  Color _getItemColor(TipoItem tipo) {
    switch (tipo) {
      case TipoItem.cura:
        return Colors.red;
      case TipoItem.mana:
        return Colors.blue;
      case TipoItem.equipamento:
        return Colors.orange;
    }
  }
}