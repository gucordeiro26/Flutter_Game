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

  String get nomeClasse {
    switch (classe) {
      case ClassePersonagem.guerreiro:
        return 'Guerreiro';
      case ClassePersonagem.mago:
        return 'Mago';
      case ClassePersonagem.arqueiro:
        return 'Arqueiro';
    }
  }

  List<String> get habilidadesDisponiveis {
    switch (classe) {
      case ClassePersonagem.guerreiro:
        return ['Golpe Poderoso', 'Defesa Férrea', 'Fúria Berserker'];
      case ClassePersonagem.mago:
        return ['Bola de Fogo', 'Raio Congelante', 'Cura Mágica'];
      case ClassePersonagem.arqueiro:
        return ['Tiro Certeiro', 'Chuva de Flechas', 'Tiro Perfurante'];
    }
  }

  @override
  String toString() {
    return '$nome ($nomeClasse) - Nível $level';
  }
}