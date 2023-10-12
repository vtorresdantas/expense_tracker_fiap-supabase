import 'package:expense_tracker/models/conta.dart';

class Transferencia {
  int id;
  String userId;
  DateTime data;
  String descricao;
  Conta conta;
  double valor;

  Transferencia({
    required this.id,
    required this.data,
    required this.descricao,
    required this.conta,
    required this.userId,
    required this.valor,
  });

  factory Transferencia.fromMap(Map<String, dynamic> map) {
    return Transferencia(
      id: map['id'],
      userId: map['user_id'],
      data: DateTime.parse(map['data_transferencia']),
      descricao: map['descricao'],
      conta: Conta.fromMap(map['contas']),
      valor: map['valor'],
    );
  }
}
