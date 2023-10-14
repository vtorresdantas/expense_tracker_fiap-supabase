import 'package:expense_tracker/models/usuario.dart';
import 'package:expense_tracker/repository/usuario_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';

class UsuarioCadastroPage extends StatefulWidget {
  final Usuario? usuarioParaEdicao;

  const UsuarioCadastroPage({super.key, this.usuarioParaEdicao});

  @override
  State<UsuarioCadastroPage> createState() => _UsuarioCadastroPageState();
}

class _UsuarioCadastroPageState extends State<UsuarioCadastroPage> {
  final usuariosRepo = UsuarioRepository();
  final _formKey = GlobalKey<FormState>();
  late Usuario usuario;
  final nomeController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Usuário'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNome(),
                const SizedBox(height: 30),
                _buildEmail(),
                const SizedBox(height: 30),
                _buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildNome() {
    return TextFormField(
      controller: nomeController,
      decoration: const InputDecoration(
        hintText: 'Informe o nome',
        labelText: 'Nome',
        prefixIcon: Icon(Ionicons.text_outline),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe um nome de usuário';
        }
        if (value.length < 3 || value.length > 30) {
          return 'O nome deve possuir acima de 3 letras';
        }
        return null;
      },
    );
  }

  TextFormField _buildEmail() {
    return TextFormField(
      controller: emailController,
      decoration: const InputDecoration(
        hintText: 'Informe o e-mail',
        labelText: 'E-mail',
        prefixIcon: Icon(Ionicons.text_outline),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe um e-mail válido';
        }
        if (value.length < 8 || value.length > 30) {
          return 'O e-mail deve possuir acima de 8 letras';
        }
        return null;
      },
    );
  }

  SizedBox _buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          final isValid = _formKey.currentState!.validate();
          if (isValid) {
            _cadastrarUsuario(
              Usuario(
                id: 0, // O id será gerado automaticamente pelo banco de dados
                nome: nomeController.text,
                email: emailController.text,
              ),
            );
          }
        },
        child: const Text('Cadastrar'),
      ),
    );
  }

  Future<void> _cadastrarUsuario(Usuario usuario) async {
    final scaffold = ScaffoldMessenger.of(context);
    await usuariosRepo.cadastrarUsuario(usuario).then((_) {
      // Mensagem de Sucesso
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Usuário ${nomeController.text} cadastrada com sucesso',
        ),
      ));
      Navigator.of(context).pop(true);
    }).catchError((error) {
      // Mensagem de Erro
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Erro ao cadastrar o usuário ${nomeController.text}',
        ),
      ));

      Navigator.of(context).pop(false);
    });
  }

  Future<void> _alterarUsuario(Usuario usuario) async {
    final scaffold = ScaffoldMessenger.of(context);
    await usuariosRepo.alterarUsuario(usuario).then((_) {
      // Mensagem de Sucesso
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Usuário ${nomeController.text} alterado com sucesso',
        ),
      ));
      Navigator.of(context).pop(true);
    }).catchError((error) {
      // Mensagem de Erro
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Erro ao alterar o usuário ${nomeController.text}',
        ),
      ));

      Navigator.of(context).pop(false);
    });
  }
}
