import 'package:flutter/material.dart';

import '../models/Transferencia.dart';

class TransferenciaItem extends StatelessWidget {
  final Transferencia transferencia;
  final void Function()? onTap;
  const TransferenciaItem({Key? key, this.onTap, required this.transferencia})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(transferencia.descricao),
      subtitle: Text(transferencia.userId),
      onTap: onTap,
    );
  }
}
