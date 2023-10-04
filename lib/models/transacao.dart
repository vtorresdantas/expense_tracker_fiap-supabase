import 'package:expense_tracker/models/categoria.dart';
import 'package:expense_tracker/models/conta.dart';
import 'package:expense_tracker/models/tipo_transacao.dart';

class Transacao {
  int id;
  String userId;
  String descricao;
  TipoTransacao tipoTransacao;
  double valor;
  DateTime data;
  String detalhes = '';
  Categoria categoria;
  Conta conta;

  Transacao({
    required this.id,
    required this.userId,
    required this.descricao,
    required this.tipoTransacao,
    required this.valor,
    required this.data,
    required this.categoria,
    required this.conta,
    this.detalhes = '',
  });

  factory Transacao.fromMap(Map<String, dynamic> map) {
    return Transacao(
      id: map['id'],
      userId: map['user_id'],
      descricao: map['descricao'],
      tipoTransacao: TipoTransacao.values[map['tipo_transacao']],
      valor: map['valor'],
      data: DateTime.parse(map['data_transacao']),
      detalhes: map['detalhes'] ?? '',
      categoria: Categoria.fromMap(map['categorias']),
      conta: Conta.fromMap(map['contas']),
    );
  }
}
