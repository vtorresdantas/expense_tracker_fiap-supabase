import 'package:expense_tracker/pages/bancos_select_page.dart';
import 'package:expense_tracker/repository/contas_repository.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/banco_select.dart';
import '../models/banco.dart';
import '../models/conta.dart';

class ContaCadastroPage extends StatefulWidget {
  final Conta? contaParaEdicao;

  const ContaCadastroPage({super.key, this.contaParaEdicao});

  @override
  State<ContaCadastroPage> createState() => _ContaCadastroPageState();
}

class _ContaCadastroPageState extends State<ContaCadastroPage> {
  final descricaoController = TextEditingController();
  User? user;
  final contasRepo = ContasRepository();

  final _formKey = GlobalKey<FormState>();

  Banco? bancoSelecionado;
  TipoConta tipoContaSelecionada = TipoConta.contaCorrente;

  @override
  void initState() {
    user = Supabase.instance.client.auth.currentUser;

    final conta = widget.contaParaEdicao;

    if (conta != null) {
      bancoSelecionado = conta.bancoId as Banco?;
      descricaoController.text = conta.descricao;
      tipoContaSelecionada = conta.tipoConta;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Conta'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDescricao(),
                const SizedBox(height: 30),
                _buildTipoConta(),
                const SizedBox(height: 30),
                _buildBancoSelect(),
                const SizedBox(height: 30),
                _buildButton(),
                const SizedBox(height: 30),
                _buildDetalhes(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BancoSelect _buildBancoSelect() {
    return BancoSelect(
      banco: bancoSelecionado,
      onTap: () async {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const BancosSelectPage(),
          ),
        ) as Banco?;

        if (result != null) {
          setState(() {
            bancoSelecionado = result;
          });
        }
      },
    );
  }

  TextFormField _buildDescricao() {
    return TextFormField(
      controller: descricaoController,
      decoration: const InputDecoration(
        hintText: 'Informe a descrição',
        labelText: 'Descrição',
        prefixIcon: Icon(Ionicons.text_outline),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe uma Descrição';
        }
        if (value.length < 5 || value.length > 30) {
          return 'A Descrição deve entre 5 e 30 caracteres';
        }
        return null;
      },
    );
  }

  DropdownMenu<TipoConta> _buildTipoConta() {
    return DropdownMenu<TipoConta>(
      width: MediaQuery.of(context).size.width - 16,
      initialSelection: tipoContaSelecionada,
      label: const Text('Tipo de Conta'),
      dropdownMenuEntries: const [
        DropdownMenuEntry(
          value: TipoConta.contaCorrente,
          label: "Conta Corrente",
        ),
        DropdownMenuEntry(
          value: TipoConta.contaInvestimento,
          label: "Conta Investimento",
        ),
        DropdownMenuEntry(
          value: TipoConta.contaPoupanca,
          label: "Conta Poupanca",
        ),
      ],
      onSelected: (value) {
        tipoContaSelecionada = value!;
      },
    );
  }

  SizedBox _buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final isValid = _formKey.currentState!.validate();
          if (isValid) {
            //descrição
            final descricao = descricaoController.text;

            final conta = Conta(
              bancoId: bancoSelecionado!,
              descricao: descricao,
              id: 0,
              tipoConta: tipoContaSelecionada,
            );

            if (widget.contaParaEdicao == null) {
              await _cadastrarConta(conta);
            } else {
              conta.id = widget.contaParaEdicao!.id;
              await _alterarConta(conta);
            }
          }
        },
        child: const Text('Cadastrar'),
      ),
    );
  }

  TextFormField _buildDetalhes() {
    return TextFormField(
      controller: descricaoController,
      decoration: const InputDecoration(
        hintText: 'Detalhes da conta',
        labelText: 'Detalhes',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.multiline,
      maxLines: 2,
    );
  }

  Future<void> _cadastrarConta(Conta conta) async {
    final scaffold = ScaffoldMessenger.of(context);
    await contasRepo.cadastrarConta(conta).then((_) {
      // Mensagem de Sucesso
      scaffold.showSnackBar(SnackBar(
        content: Text(
          '${conta.tipoConta == TipoConta.contaCorrente ? 'Conta Corrente' : 'Conta Poupança'} cadastrada com sucesso',
        ),
      ));
      Navigator.of(context).pop(true);
    }).catchError((error) {
      // Mensagem de Erro
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Erro ao cadastrar ${conta.tipoConta == TipoConta.contaCorrente ? 'Conta Corrente' : 'Conta Poupança'}',
        ),
      ));

      Navigator.of(context).pop(false);
    });
  }

  Future<void> _alterarConta(Conta conta) async {
    final scaffold = ScaffoldMessenger.of(context);
    await contasRepo.alterarConta(conta).then((_) {
      // Mensagem de Sucesso
      scaffold.showSnackBar(SnackBar(
        content: Text(
          '${conta.tipoConta == TipoConta.contaCorrente ? 'Conta Corrente' : 'Conta Poupança'} alterada com sucesso',
        ),
      ));
      Navigator.of(context).pop(true);
    }).catchError((error) {
      // Mensagem de Erro
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Erro ao alterar ${conta.tipoConta == TipoConta.contaCorrente ? 'Conta Corrente' : 'Conta Poupança'}',
        ),
      ));

      Navigator.of(context).pop(false);
    });
  }
}
