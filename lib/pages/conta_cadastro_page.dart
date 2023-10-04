import 'package:expense_tracker/pages/bancos_select_page.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../components/banco_select.dart';
import '../models/banco.dart';
import '../models/conta.dart';

class ContaCadastroPage extends StatefulWidget {
  const ContaCadastroPage({super.key});

  @override
  State<ContaCadastroPage> createState() => _ContaCadastroPageState();
}

class _ContaCadastroPageState extends State<ContaCadastroPage> {
  final descricaoController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Banco? bancoSelecionado;
  TipoConta tipoContaSelecionada = TipoConta.contaCorrente;

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
        onPressed: () {
          final isValid = _formKey.currentState!.validate();
          if (isValid) {}
        },
        child: const Text('Cadastrar'),
      ),
    );
  }
}
