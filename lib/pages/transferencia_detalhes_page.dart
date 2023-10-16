import 'package:expense_tracker/components/conta_item.dart';

import 'package:expense_tracker/models/tipo_transferencia.dart';
import 'package:expense_tracker/models/transferencia.dart';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class TransferenciaDetalhesPage extends StatefulWidget {
  const TransferenciaDetalhesPage({super.key});

  @override
  State<TransferenciaDetalhesPage> createState() =>
      _TransferenciaDetalhesPageState();
}

class _TransferenciaDetalhesPageState extends State<TransferenciaDetalhesPage> {
  @override
  Widget build(BuildContext context) {
    final transferencia =
        ModalRoute.of(context)!.settings.arguments as Transferencia;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            transferencia.tipoTransferencia == TipoTransferencia.enviada
                ? Colors.redAccent
                : Colors.greenAccent,
        title: Text(transferencia.descricao),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //UsuarioItem(usuario: transferencia.userId),
            ContaItem(conta: transferencia.conta),
            ListTile(
              title: const Text('Tipo de Transferência'),
              subtitle: Text(
                  transferencia.tipoTransferencia == TipoTransferencia.enviada
                      ? 'Enviada'
                      : 'Recebida'),
            ),
            ListTile(
              title: const Text('Valor'),
              subtitle: Text(NumberFormat.simpleCurrency(locale: 'pt_BR')
                  .format(transferencia.valor)),
            ),
            ListTile(
              title: const Text('Usuário'),
              subtitle: Text(transferencia.usuario.nome),
            ),
            ListTile(
              title: const Text('Data do Lançamento'),
              subtitle:
                  Text(DateFormat('MM/dd/yyyy').format(transferencia.data)),
            ),
          ],
        ),
      ),
    );
  }
}
