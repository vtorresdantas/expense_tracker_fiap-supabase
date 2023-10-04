import 'package:expense_tracker/models/tipo_transacao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transacao.dart';

class TransacaoItem extends StatelessWidget {
  final Transacao transacao;
  final void Function()? onTap;
  const TransacaoItem({Key? key, required this.transacao, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: transacao.categoria.cor,
        child: Icon(
          transacao.categoria.icone,
          size: 20,
          color: Colors.white,
        ),
      ),
      title: Text(transacao.descricao),
      subtitle: Text(DateFormat('MM/dd/yyyy').format(transacao.data)),
      trailing: Text(
        NumberFormat.simpleCurrency(locale: 'pt_BR').format(transacao.valor),
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: transacao.tipoTransacao == TipoTransacao.despesa
                ? Colors.pink
                : Colors.green),
      ),
      onTap: onTap,
    );
  }
}
