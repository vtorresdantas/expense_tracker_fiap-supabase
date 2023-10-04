import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../models/banco.dart';

class BancoSelect extends StatelessWidget {
  final Banco? banco;
  final void Function()? onTap;
  const BancoSelect({super.key, this.banco, this.onTap});

  @override
  Widget build(BuildContext context) {
    final circleAvatar = banco == null
        ? CircleAvatar(
            backgroundColor: Colors.grey.shade400,
            child: const Icon(
              Ionicons.wallet_outline,
              color: Colors.white,
            ),
          )
        : CircleAvatar(
            backgroundImage: AssetImage('images/${banco!.logo}'),
          );

    return ListTile(
      leading: circleAvatar,
      title: Text(banco?.nome ?? 'Selecione um banco'),
      trailing: const Icon(Ionicons.chevron_forward_outline),
      onTap: onTap,
    );
  }
}
