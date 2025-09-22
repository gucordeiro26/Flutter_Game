// models/personagem.dart
enum ClassePersonagem { guerreiro, mago, arqueiro }

class Personagem {
  String nome;
  ClassePersonagem classe;
  String descricao;
  
  int hp;
  int hpMax;
  int mana;
  int manaMax;
  int ataque;
  int defesa;
  int xp;
  int level;
  
  List<String> habilidades;

  Personagem({
    required this.nome,
    required this.classe,
    this.descricao = '',
    this.hp = 100,
    this.hpMax = 100,
    this.mana = 100,
    this.manaMax = 100,
    this.ataque = 10,
    this.defesa = 5,
    this.xp = 0,
    this.level = 1,
    List<String>? habilidades,
  }) : habilidades = habilidades ?? [];

  // Métodos de ação
  void curar(int valor) {
    hp = (hp + valor).clamp(0, hpMax);
  }

  void receberDano(int valor) {
    hp = (hp - valor).clamp(0, hpMax);
  }

  void gastarMana(int valor) {
    mana = (mana - valor).clamp(0, manaMax);
  }

  void recuperarMana(int valor) {
    mana = (mana + valor).clamp(0, manaMax);
  }

  void ganharXP(int valor) {
    xp += valor;
    _verificarNivel();
  }

  void _verificarNivel() {
    int xpNecessario = level * 100;
    if (xp >= xpNecessario) {
      level++;
      xp -= xpNecessario;
      _aumentarStats();
    }
  }

  void _aumentarStats() {
    // Aumenta stats baseado na classe
    switch (classe) {
      case ClassePersonagem.guerreiro:
        hpMax += 15;
        hp += 15;
        ataque += 3;
        defesa += 2;
        break;
      case ClassePersonagem.mago:
        hpMax += 8;
        hp += 8;
        manaMax += 20;
        mana += 20;
        ataque += 2;
        break;
      case ClassePersonagem.arqueiro:
        hpMax += 12;
        hp += 12;
        manaMax += 10;
        mana += 10;
        ataque += 4;
        defesa += 1;
        break;
    }
  }

  // Getters úteis
  bool get estaMorto => hp <= 0;
  bool podeUsarMagia(int custo) => mana >= custo;
  double get hpPercentage => hp / hpMax;
  double get manaPercentage => mana / manaMax;
  
  String get iconeClasse {
    switch (classe) {
      case ClassePersonagem.guerreiro:
        return '⚔️';
      case ClassePersonagem.mago:
        return '🔮';
      case ClassePersonagem.arqueiro:
        return '🏹';
    }
  }
}

// models/inimigo.dart
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
      default:
        return '👾';
    }
  }
}

// models/item.dart
enum TipoItem { cura, mana, equipamento }

class Item {
  String nome;
  TipoItem tipo;
  int valor;
  String descricao;

  Item({
    required this.nome,
    required this.tipo,
    required this.valor,
    this.descricao = '',
  });

  String get icone {
    switch (tipo) {
      case TipoItem.cura:
        return '🧪';
      case TipoItem.mana:
        return '💙';
      case TipoItem.equipamento:
        return '⚔️';
    }
  }
}