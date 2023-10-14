import 'package:expense_tracker/models/usuario.dart';
import 'package:flutter/material.dart';

class UsuarioSelectPage extends StatelessWidget {
  const UsuarioSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usuarios = usuarioMap.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários'),
      ),
      body: ListView.separated(
        itemCount: usuarios.length,
        itemBuilder: (context, index) {
          final usuario = usuarios[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('images/${usuario.logo}'),
            ),
            title: Text(usuario.nome),
            onTap: () {
              Navigator.of(context).pop(usuario);
            },
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}
