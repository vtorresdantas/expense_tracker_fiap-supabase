import 'package:expense_tracker/models/tipo_transferencia.dart';
import 'package:expense_tracker/models/transferencia.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransferenciaItem extends StatelessWidget {
  final Transferencia transferencia;
  final void Function()? onTap;

  const TransferenciaItem({Key? key, this.onTap, required this.transferencia})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(transferencia.descricao),
      subtitle: Text(transferencia.usuario.nome),
      trailing: Text(
        NumberFormat.simpleCurrency(locale: 'pt_BR')
            .format(transferencia.valor),
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: transferencia.tipoTransferencia == TipoTransferencia.enviada
                ? Colors.pink
                : Colors.green),
      ),
      onTap: onTap,
    );
  }
}
