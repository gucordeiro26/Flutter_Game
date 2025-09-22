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

  String get tipoString {
    switch (tipo) {
      case TipoItem.cura:
        return 'Poção de Cura';
      case TipoItem.mana:
        return 'Poção de Mana';
      case TipoItem.equipamento:
        return 'Equipamento';
    }
  }

  String get descricaoCompleta {
    if (descricao.isNotEmpty) return descricao;
    
    switch (tipo) {
      case TipoItem.cura:
        return 'Restaura $valor pontos de vida';
      case TipoItem.mana:
        return 'Restaura $valor pontos de mana';
      case TipoItem.equipamento:
        return 'Aumenta ataque em $valor';
    }
  }
}