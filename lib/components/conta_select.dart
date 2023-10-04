import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../models/banco.dart';
import '../models/conta.dart';

class ContaSelect extends StatelessWidget {
  final Conta? conta;
  final void Function()? onTap;
  const ContaSelect({super.key, this.conta, this.onTap});

  @override
  Widget build(BuildContext context) {
    final circleAvatar = conta == null
        ? CircleAvatar(
            backgroundColor: Colors.grey.shade400,
            child: const Icon(
              Ionicons.wallet_outline,
              color: Colors.white,
            ),
          )
        : CircleAvatar(
            backgroundImage:
                AssetImage('images/${bancosMap[conta!.bancoId]?.logo}'),
          );

    return ListTile(
      leading: circleAvatar,
      title: Text(conta?.descricao ?? 'Selecione uma conta'),
      trailing: const Icon(Ionicons.chevron_forward_outline),
      onTap: onTap,
    );
  }
}
