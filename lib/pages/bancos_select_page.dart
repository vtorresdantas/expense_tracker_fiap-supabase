import 'package:flutter/material.dart';

import '../models/banco.dart';

class BancosSelectPage extends StatelessWidget {
  const BancosSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bancos = bancosMap.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bancos'),
      ),
      body: ListView.separated(
        itemCount: bancos.length,
        itemBuilder: (context, index) {
          final banco = bancos[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('images/${banco.logo}'),
            ),
            title: Text(banco.nome),
            onTap: () {
              Navigator.of(context).pop(banco);
            },
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}
