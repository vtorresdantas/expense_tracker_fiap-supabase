import 'package:expense_tracker/models/usuario.dart';
import 'package:flutter/material.dart';

class UsuarioItem extends StatelessWidget {
  final Usuario usuario;
  const UsuarioItem({Key? key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.person, // Corrigido para usar o ícone de usuário
          size: 20,
          color: Colors.black,
        ),
      ),
      title: Text(
        usuario.nome,
      ),
      subtitle: Text(
        usuario.email,
      ),
    );
  }
}
