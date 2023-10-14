import 'package:expense_tracker/components/Usuario_item.dart';
import 'package:expense_tracker/models/usuario.dart';
import 'package:expense_tracker/repository/Usuario_repository.dart';
import 'package:flutter/material.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final futureUsuarios = UsuarioRepository().listarUsuarios();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Contatos'),
        ),
        body: FutureBuilder<List<Usuario>>(
            future: futureUsuarios,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text("Erro ao carregar os contatos"),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("Nenhum contatos encontrado"),
                );
              } else {
                final usuarios = snapshot.data!;
                return ListView.separated(
                  itemCount: usuarios.length,
                  itemBuilder: (context, index) {
                    final usuario = usuarios[index];
                    return UsuarioItem(usuario: usuario);
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                );
              }
            }));
  }
}
