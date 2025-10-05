import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';

class LogPage extends StatelessWidget {
  const LogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Ações'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade700,
        foregroundColor: Colors.white,
      ),
      body: Consumer<GameState>(
        builder: (context, gameState, child) {
          if (gameState.historicoGlobal.isEmpty) {
            return const Center(
              child: Text(
                'Nenhuma ação registrada ainda.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            reverse: true, // Mostra os itens mais novos primeiro
            padding: const EdgeInsets.all(8.0),
            itemCount: gameState.historicoGlobal.length,
            itemBuilder: (context, index) {
              final logEntry = gameState.historicoGlobal[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.blueGrey),
                  title: Text(logEntry),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Ação para limpar o histórico
          Provider.of<GameState>(context, listen: false).limparHistorico();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Histórico limpo!'),
              backgroundColor: Colors.orange,
            ),
          );
        },
        label: const Text('Limpar Histórico'),
        icon: const Icon(Icons.delete_sweep),
        backgroundColor: Colors.blueGrey.shade800,
        foregroundColor: Colors.white,
      ),
    );
  }
}