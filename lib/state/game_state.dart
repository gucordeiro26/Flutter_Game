import 'package:flutter/foundation.dart';
import '../models/personagem.dart';
import '../models/inimigo.dart';
import '../models/item.dart';

class GameState extends ChangeNotifier {
  // Lista de personagens disponíveis
  final List<Personagem> _personagensDisponiveis = [
    Personagem(
      nome: 'Guerreiro',
      classe: ClassePersonagem.guerreiro,
      hp: 120, hpMax: 120,
      mana: 50, manaMax: 50,
      ataque: 15, defesa: 10,
      descricao: 'Forte em combate corpo a corpo',
    ),
    Personagem(
      nome: 'Mago',
      classe: ClassePersonagem.mago,
      hp: 80, hpMax: 80,
      mana: 150, manaMax: 150,
      ataque: 8, defesa: 5,
      descricao: 'Especialista em magias poderosas',
    ),
    Personagem(
      nome: 'Arqueiro',
      classe: ClassePersonagem.arqueiro,
      hp: 100, hpMax: 100,
      mana: 100, manaMax: 100,
      ataque: 12, defesa: 8,
      descricao: 'Ágil e preciso à distância',
    ),
  ];

  // Estado do jogo
  Personagem? _personagemAtivo;
  Inimigo? _inimigoAtual;
  List<Item> _inventario = [];
  List<String> _historicoGlobal = [];
  bool _emCombate = false;

  // Getters
  List<Personagem> get personagensDisponiveis => _personagensDisponiveis;
  Personagem? get personagemAtivo => _personagemAtivo;
  Inimigo? get inimigoAtual => _inimigoAtual;
  List<Item> get inventario => _inventario;
  List<String> get historicoGlobal => _historicoGlobal;
  bool get emCombate => _emCombate;

  // Seleção de personagem
  void selecionarPersonagem(int index) {
    if (index >= 0 && index < _personagensDisponiveis.length) {
      _personagemAtivo = _personagensDisponiveis[index];
      adicionarHistorico('${_personagemAtivo!.nome} foi selecionado!');
      notifyListeners();
    }
  }

  // Sistema de combate
  void iniciarCombate() {
    if (_personagemAtivo == null) return;
    
    _inimigoAtual = _gerarInimigoAleatorio();
    _emCombate = true;
    adicionarHistorico('Combate iniciado contra ${_inimigoAtual!.nome}!');
    notifyListeners();
  }

  void atacar() {
    if (!_podeAtacar()) return;

    int dano = _calcularDano(_personagemAtivo!.ataque, _inimigoAtual!.defesa);
    _inimigoAtual!.receberDano(dano);
    
    adicionarHistorico('${_personagemAtivo!.nome} atacou ${_inimigoAtual!.nome} causando $dano de dano!');

    if (_inimigoAtual!.estaMorto) {
      _finalizarCombate(vitoria: true);
    } else {
      _inimigoAtacar();
    }
    
    notifyListeners();
  }

  void lancarMagia(String nomeMagia, int custoMana, int multiplicador) {
    if (!_podeUsarMagia(custoMana)) return;

    _personagemAtivo!.gastarMana(custoMana);
    int dano = _calcularDano(_personagemAtivo!.ataque * multiplicador, _inimigoAtual!.defesa);
    _inimigoAtual!.receberDano(dano);
    
    adicionarHistorico('${_personagemAtivo!.nome} lançou $nomeMagia causando $dano de dano!');

    if (_inimigoAtual!.estaMorto) {
      _finalizarCombate(vitoria: true);
    } else {
      _inimigoAtacar();
    }
    
    notifyListeners();
  }

  void usarItem(Item item) {
    if (!_inventario.contains(item) || _personagemAtivo == null) return;

    switch (item.tipo) {
      case TipoItem.cura:
        _personagemAtivo!.curar(item.valor);
        adicionarHistorico('${_personagemAtivo!.nome} usou ${item.nome} e curou ${item.valor} HP!');
        break;
      case TipoItem.mana:
        _personagemAtivo!.recuperarMana(item.valor);
        adicionarHistorico('${_personagemAtivo!.nome} usou ${item.nome} e recuperou ${item.valor} Mana!');
        break;
    }
    
    _inventario.remove(item);
    notifyListeners();
  }

  void adicionarItem(Item item) {
    _inventario.add(item);
    notifyListeners();
  }

  void adicionarHistorico(String acao) {
    _historicoGlobal.insert(0, '${DateTime.now().toString().substring(11, 19)} - $acao');
    if (_historicoGlobal.length > 50) {
      _historicoGlobal.removeLast();
    }
  }

  void limparHistorico() {
    _historicoGlobal.clear();
    notifyListeners();
  }

  // Métodos privados
  bool _podeAtacar() {
    return _personagemAtivo != null && 
           _inimigoAtual != null && 
           _emCombate && 
           !_personagemAtivo!.estaMorto;
  }

  bool _podeUsarMagia(int custo) {
    return _podeAtacar() && _personagemAtivo!.podeUsarMagia(custo);
  }

  int _calcularDano(int ataque, int defesa) {
    int dano = (ataque - defesa).clamp(1, ataque);
    // Adiciona um pouco de aleatoriedade (80% a 120% do dano)
    double multiplicador = 0.8 + (0.4 * (DateTime.now().millisecond / 1000));
    return (dano * multiplicador).round();
  }

  void _inimigoAtacar() {
    if (_inimigoAtual == null || _personagemAtivo == null) return;

    int dano = _calcularDano(_inimigoAtual!.ataque, _personagemAtivo!.defesa);
    _personagemAtivo!.receberDano(dano);
    
    adicionarHistorico('${_inimigoAtual!.nome} atacou ${_personagemAtivo!.nome} causando $dano de dano!');

    if (_personagemAtivo!.estaMorto) {
      _finalizarCombate(vitoria: false);
    }
  }

  void _finalizarCombate({required bool vitoria}) {
    if (vitoria) {
      int xpGanho = _inimigoAtual!.xpRecompensa;
      _personagemAtivo!.ganharXP(xpGanho);
      adicionarHistorico('Vitória! Ganhou $xpGanho XP!');
      
      // Chance de ganhar item
      if (DateTime.now().millisecond % 3 == 0) {
        Item itemGanho = _gerarItemAleatorio();
        adicionarItem(itemGanho);
        adicionarHistorico('Encontrou um ${itemGanho.nome}!');
      }
    } else {
      adicionarHistorico('Derrota! ${_personagemAtivo!.nome} foi derrotado!');
    }
    
    _emCombate = false;
    _inimigoAtual = null;
  }

  Inimigo _gerarInimigoAleatorio() {
    final inimigos = [
      Inimigo(nome: 'Goblin', hp: 40, ataque: 8, defesa: 2, xpRecompensa: 15),
      Inimigo(nome: 'Orc', hp: 60, ataque: 12, defesa: 5, xpRecompensa: 25),
      Inimigo(nome: 'Troll', hp: 100, ataque: 15, defesa: 8, xpRecompensa: 40),
      Inimigo(nome: 'Dragão Menor', hp: 80, ataque: 18, defesa: 6, xpRecompensa: 35),
    ];
    
    int index = DateTime.now().millisecond % inimigos.length;
    return inimigos[index];
  }

  Item _gerarItemAleatorio() {
    final itens = [
      Item(nome: 'Poção de Vida', tipo: TipoItem.cura, valor: 30),
      Item(nome: 'Poção de Mana', tipo: TipoItem.mana, valor: 25),
      Item(nome: 'Poção Grande de Vida', tipo: TipoItem.cura, valor: 50),
    ];
    
    int index = DateTime.now().millisecond % itens.length;
    return itens[index];
  }
}