import 'package:expense_tracker/models/usuario.dart';
import 'package:flutter/material.dart';

class UsuarioSelect extends StatelessWidget {
  final Usuario? usuario;
  final void Function()? onTap;

  const UsuarioSelect({Key? key, this.usuario, this.onTap});

  @override
  Widget build(BuildContext context) {
    final circleAvatar = usuario == null
        ? CircleAvatar(
            backgroundColor: Colors.grey.shade400,
            child: Icon(
              Icons.person_outline,
              color: Colors.white,
            ),
          )
        : CircleAvatar(
            backgroundImage: AssetImage('images/${usuario!.logo}'),
          );

    return ListTile(
      leading: circleAvatar,
      title: Text(usuario?.nome ?? 'Selecione um usuário'),
      subtitle: Text(usuario?.nome ?? ''),
      onTap: onTap,
    );
  }
}
