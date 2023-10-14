import 'package:expense_tracker/models/conta.dart';
import 'package:expense_tracker/models/tipo_transferencia.dart';
import 'package:expense_tracker/models/usuario.dart';

class Transferencia {
  int id;
  String userId;
  DateTime data;
  String descricao;
  TipoTransferencia tipoTransferencia;
  Usuario usuario;
  Conta conta;
  double valor;

  Transferencia({
    required this.id,
    required this.data,
    required this.descricao,
    required this.tipoTransferencia,
    required this.conta,
    required this.userId,
    required this.usuario,
    required this.valor,
  });

  factory Transferencia.fromMap(Map<String, dynamic> map) {
    return Transferencia(
      id: map['id'],
      userId: map['user_id'],
      data: DateTime.parse(map['data_transferencia']),
      tipoTransferencia: TipoTransferencia.values[map['tipo_transferencia']],
      descricao: map['descricao'],
      usuario: Usuario.fromMap(map['usuarios']),
      conta: Conta.fromMap(map['contas']),
      valor: map['valor'],
    );
  }
}
