import 'package:expense_tracker/models/usuario.dart';
import 'package:expense_tracker/repository/usuario_repository.dart';
import 'package:flutter/material.dart';

class UsuarioSelectPage extends StatefulWidget {
  const UsuarioSelectPage({Key? key}) : super(key: key);

  @override
  State<UsuarioSelectPage> createState() => _UsuarioSelectPageState();
}

class _UsuarioSelectPageState extends State<UsuarioSelectPage> {
  late final Future<List<Usuario>> _futureUsuarios;

  @override
  void initState() {
    super.initState();
    _futureUsuarios = UsuarioRepository().listarUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecionar usuário')),
      body: FutureBuilder<List<Usuario>>(
        future: _futureUsuarios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Erro ao carregar contas"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Nenhuma conta encontrada"),
            );
          } else {
            if (snapshot.connectionState == ConnectionState.done) {
              final usuarios = snapshot.data ?? [];
              return ListView.builder(
                itemCount: usuarios.length,
                itemBuilder: (context, index) {
                  final usuario = usuarios[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.person,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(usuario.nome),
                    onTap: () {
                      Navigator.of(context).pop(usuario);
                    },
                  );
                },
              );
            }
          }

          return Container();
        },
      ),
    );
  }
}
