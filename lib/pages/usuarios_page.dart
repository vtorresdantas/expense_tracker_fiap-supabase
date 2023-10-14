import 'package:expense_tracker/components/usuario_item.dart';
import 'package:expense_tracker/models/usuario.dart';
import 'package:expense_tracker/pages/usuario_cadastro_page.dart';
import 'package:expense_tracker/repository/usuario_repository.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({Key? key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final usuariosRepo = UsuarioRepository();

  late Future<List<Usuario>> futureUsuarios;

  @override
  void initState() {
    futureUsuarios = usuariosRepo.listarUsuarios();
    super.initState();
  }

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
              child: Text("Nenhum contato encontrado"),
            );
          } else {
            final usuarios = snapshot.data!;
            return ListView.separated(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                final usuario = usuarios[index];
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UsuarioCadastroPage(
                                usuarioParaEdicao: usuario,
                              ),
                            ),
                          ) as bool?;

                          if (result == true) {
                            setState(() {
                              futureUsuarios = usuariosRepo.listarUsuarios();
                            });
                          }
                        },
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Editar',
                      ),
                      SlidableAction(
                        onPressed: (context) async {
                          await usuariosRepo.excluirUsuario(usuario.id);
                          setState(() {
                            usuarios.removeAt(index);
                          });
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Remover',
                      ),
                    ],
                  ),
                  child: UsuarioItem(
                    usuario: usuario,
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "usuario-cadastro",
        onPressed: () async {
          final result =
              await Navigator.pushNamed(context, '/usuario-cadastro') as bool?;

          if (result == true) {
            setState(() {
              futureUsuarios = usuariosRepo.listarUsuarios();
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
