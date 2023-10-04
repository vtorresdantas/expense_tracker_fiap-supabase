import 'package:expense_tracker/components/conta_item.dart';
import 'package:expense_tracker/models/transacao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/tipo_transacao.dart';

class TransacaoDetalhesPage extends StatefulWidget {
  const TransacaoDetalhesPage({super.key});

  @override
  State<TransacaoDetalhesPage> createState() => _TransacaoDetalhesPageState();
}

class _TransacaoDetalhesPageState extends State<TransacaoDetalhesPage> {
  @override
  Widget build(BuildContext context) {
    final transacao = ModalRoute.of(context)!.settings.arguments as Transacao;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: transacao.tipoTransacao == TipoTransacao.despesa
            ? Colors.redAccent
            : Colors.greenAccent,
        title: Text(transacao.descricao),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ContaItem(conta: transacao.conta),
            ListTile(
              title: const Text('Tipo de Lançamento'),
              subtitle: Text(transacao.tipoTransacao == TipoTransacao.despesa
                  ? 'Despesa'
                  : 'Receita'),
            ),
            ListTile(
              title: const Text('Valor'),
              subtitle: Text(NumberFormat.simpleCurrency(locale: 'pt_BR')
                  .format(transacao.valor)),
            ),
            ListTile(
              title: const Text('Categoria'),
              subtitle: Text(transacao.categoria.descricao),
            ),
            ListTile(
              title: const Text('Data do Lançamento'),
              subtitle: Text(DateFormat('MM/dd/yyyy').format(transacao.data)),
            ),
            ListTile(
              title: const Text('Observação'),
              subtitle:
                  Text(transacao.detalhes.isEmpty ? '-' : transacao.detalhes),
            ),
          ],
        ),
      ),
    );
  }
}
