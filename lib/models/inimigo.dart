import 'package:flutter/material.dart';

class Inimigo {
  String nome;
  int hp;
  int hpMax;
  int ataque;
  int defesa;
  int xpRecompensa;

  Inimigo({
    required this.nome,
    required this.hp,
    required this.ataque,
    required this.defesa,
    required this.xpRecompensa,
  }) : hpMax = hp;

  void receberDano(int valor) {
    hp = (hp - valor).clamp(0, hpMax);
  }

  bool get estaMorto => hp <= 0;
  double get hpPercentage => hp / hpMax;
  
  String get icone {
    switch (nome) {
      case 'Goblin':
        return '👺';
      case 'Orc':
        return '👹';
      case 'Troll':
        return '👿';
      case 'Dragão Menor':
        return '🐉';
      case 'Esqueleto':
        return '💀';
      case 'Lobo':
        return '🐺';
      case 'Bandido':
        return '🏴‍☠️';
      case 'Aranha Gigante':
        return '🕷️';
      default:
        return '👾';
    }
  }

  String get descricao {
    switch (nome) {
      case 'Goblin':
        return 'Uma criatura pequena e maliciosa';
      case 'Orc':
        return 'Guerreiro brutamontes e selvagem';
      case 'Troll':
        return 'Gigante regenerativo e resistente';
      case 'Dragão Menor':
        return 'Jovem dragão com sopro de fogo';
      case 'Esqueleto':
        return 'Morto-vivo animado por magia sombria';
      case 'Lobo':
        return 'Predador ágil e feroz';
      case 'Bandido':
        return 'Criminoso perigoso e experiente';
      case 'Aranha Gigante':
        return 'Aracnídeo venenoso de tamanho anormal';
      default:
        return 'Criatura misteriosa';
    }
  }

  String get dificuldade {
    int poder = ataque + defesa + (hpMax ~/ 10);
    if (poder <= 15) return 'Fácil';
    if (poder <= 25) return 'Médio';
    if (poder <= 35) return 'Difícil';
    return 'Épico';
  }

  Color get corDificuldade {
    switch (dificuldade) {
      case 'Fácil':
        return Colors.green;
      case 'Médio':
        return Colors.orange;
      case 'Difícil':
        return Colors.red;
      case 'Épico':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // Método para criar inimigos pré-definidos
  static List<Inimigo> get inimigosPadrao {
    return [
      Inimigo(
        nome: 'Goblin',
        hp: 40,
        ataque: 8,
        defesa: 2,
        xpRecompensa: 15,
      ),
      Inimigo(
        nome: 'Orc',
        hp: 60,
        ataque: 12,
        defesa: 5,
        xpRecompensa: 25,
      ),
      Inimigo(
        nome: 'Esqueleto',
        hp: 50,
        ataque: 10,
        defesa: 3,
        xpRecompensa: 20,
      ),
      Inimigo(
        nome: 'Lobo',
        hp: 45,
        ataque: 14,
        defesa: 4,
        xpRecompensa: 18,
      ),
      Inimigo(
        nome: 'Bandido',
        hp: 70,
        ataque: 13,
        defesa: 6,
        xpRecompensa: 30,
      ),
      Inimigo(
        nome: 'Aranha Gigante',
        hp: 55,
        ataque: 16,
        defesa: 4,
        xpRecompensa: 28,
      ),
      Inimigo(
        nome: 'Troll',
        hp: 100,
        ataque: 15,
        defesa: 8,
        xpRecompensa: 40,
      ),
      Inimigo(
        nome: 'Dragão Menor',
        hp: 80,
        ataque: 18,
        defesa: 6,
        xpRecompensa: 35,
      ),
    ];
  }

  // Método para gerar inimigo aleatório
  static Inimigo gerarAleatorio() {
    final inimigos = inimigosPadrao;
    final index = DateTime.now().millisecond % inimigos.length;
    final inimigoBase = inimigos[index];
    
    // Retorna uma cópia do inimigo (para não alterar o original)
    return Inimigo(
      nome: inimigoBase.nome,
      hp: inimigoBase.hp,
      ataque: inimigoBase.ataque,
      defesa: inimigoBase.defesa,
      xpRecompensa: inimigoBase.xpRecompensa,
    );
  }

  // Método para gerar inimigo baseado no nível do jogador
  static Inimigo gerarPorNivel(int nivelJogador) {
    final inimigos = inimigosPadrao;
    
    // Filtra inimigos adequados para o nível
    List<Inimigo> inimigosFiltrados = [];
    
    if (nivelJogador <= 2) {
      // Nível baixo: inimigos mais fracos
      inimigosFiltrados = inimigos.where((i) => i.hp <= 50).toList();
    } else if (nivelJogador <= 5) {
      // Nível médio: inimigos intermediários
      inimigosFiltrados = inimigos.where((i) => i.hp <= 70).toList();
    } else {
      // Nível alto: todos os inimigos
      inimigosFiltrados = inimigos;
    }
    
    if (inimigosFiltrados.isEmpty) {
      inimigosFiltrados = [inimigos.first]; // Fallback
    }
    
    final index = DateTime.now().millisecond % inimigosFiltrados.length;
    final inimigoBase = inimigosFiltrados[index];
    
    return Inimigo(
      nome: inimigoBase.nome,
      hp: inimigoBase.hp,
      ataque: inimigoBase.ataque,
      defesa: inimigoBase.defesa,
      xpRecompensa: inimigoBase.xpRecompensa,
    );
  }

  @override
  String toString() {
    return '$nome (HP: $hp/$hpMax, ATK: $ataque, DEF: $defesa)';
  }
}