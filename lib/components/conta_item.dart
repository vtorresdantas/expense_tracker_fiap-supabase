import 'package:flutter/material.dart';

import '../models/banco.dart';
import '../models/conta.dart';

class ContaItem extends StatelessWidget {
  final Conta conta;
  final void Function()? onTap;
  const ContaItem({super.key, required this.conta, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('images/${bancosMap[conta.bancoId]?.logo}'),
      ),
      title: Text(conta.descricao),
      subtitle: Text(bancosMap[conta.bancoId]?.nome ?? ''),
      onTap: onTap,
    );
  }
}
