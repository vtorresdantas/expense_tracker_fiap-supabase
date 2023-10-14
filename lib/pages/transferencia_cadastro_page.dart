import 'package:expense_tracker/components/conta_select.dart';
import 'package:expense_tracker/components/usuario_select.dart';

import 'package:expense_tracker/models/conta.dart';
import 'package:expense_tracker/models/tipo_transferencia.dart';
import 'package:expense_tracker/models/transferencia.dart';
import 'package:expense_tracker/models/usuario.dart';

import 'package:expense_tracker/pages/contas_select_page.dart';
import 'package:expense_tracker/pages/usuario_select_page.dart';
import 'package:expense_tracker/repository/transferencias_repository.dart';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransferenciaCadastroPage extends StatefulWidget {
  final Transferencia? transferenciaParaEdicao;

  const TransferenciaCadastroPage({super.key, this.transferenciaParaEdicao});

  @override
  State<TransferenciaCadastroPage> createState() =>
      _TransferenciaCadastroPageState();
}

class _TransferenciaCadastroPageState extends State<TransferenciaCadastroPage> {
  User? user;
  final transferenciaRepo = TransferenciasRepository();
  final descricaoController = TextEditingController();
  final dataController = TextEditingController();
  final valorController = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$');
  Conta? contaSelecionada;
  Usuario? usuarioSelecionado;
  final _formKey = GlobalKey<FormState>();
  final detalhesController = TextEditingController();
  TipoTransferencia tipoTransferenciaSelecionada = TipoTransferencia.enviada;

  @override
  void initState() {
    user = Supabase.instance.client.auth.currentUser;

    final transferencia = widget.transferenciaParaEdicao;

    if (transferencia != null) {
      contaSelecionada = transferencia.conta;

      usuarioSelecionado = transferencia.usuario;

      descricaoController.text = transferencia.descricao;

      tipoTransferenciaSelecionada = transferencia.tipoTransferencia;

      valorController.text = NumberFormat.simpleCurrency(locale: 'pt_BR')
          .format(transferencia.valor);

      dataController.text = DateFormat('MM/dd/yyyy').format(transferencia.data);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Transferência'),
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
                _buildTipoTransferencia(),
                const SizedBox(height: 30),
                _buildContaSelect(),
                const SizedBox(height: 30),
                _buildUsuarioSelect(),
                const SizedBox(height: 30),
                _buildValor(),
                const SizedBox(height: 30),
                _buildData(),
                const SizedBox(height: 30),
                _buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ContaSelect _buildContaSelect() {
    return ContaSelect(
      conta: contaSelecionada,
      onTap: () async {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ContasSelectPage(),
          ),
        ) as Conta?;

        if (result != null) {
          setState(() {
            contaSelecionada = result;
          });
        }
      },
    );
  }

  UsuarioSelect _buildUsuarioSelect() {
    return UsuarioSelect(
      usuario: usuarioSelecionado,
      onTap: () async {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const UsuarioSelectPage(),
          ),
        ) as Usuario?;

        if (result != null) {
          setState(() {
            usuarioSelecionado = result;
          });
        }
      },
    );
  }

  TextFormField _buildData() {
    return TextFormField(
      controller: dataController,
      keyboardType: TextInputType.none,
      decoration: const InputDecoration(
        hintText: 'Informe uma Data',
        labelText: 'Data',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Ionicons.calendar_outline),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe uma Data';
        }

        try {
          DateFormat('dd/MM/yyyy').parse(value);
        } on FormatException {
          return 'Formato de data inválida';
        }

        return null;
      },
      onTap: () async {
        //FocusScope.of(context).requestFocus(FocusNode());

        DateTime? dataSelecionada = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (dataSelecionada != null) {
          dataController.text =
              DateFormat('dd/MM/yyyy').format(dataSelecionada);
        }
      },
    );
  }

  DropdownMenu<TipoTransferencia> _buildTipoTransferencia() {
    return DropdownMenu<TipoTransferencia>(
      width: MediaQuery.of(context).size.width - 16,
      initialSelection: tipoTransferenciaSelecionada,
      label: const Text('Tipo de Transferência'),
      dropdownMenuEntries: const [
        DropdownMenuEntry(
          value: TipoTransferencia.enviada,
          label: "Enviada",
        ),
        DropdownMenuEntry(
          value: TipoTransferencia.recebida,
          label: "Recebida",
        ),
      ],
      onSelected: (value) {
        tipoTransferenciaSelecionada = value!;
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

  TextFormField _buildValor() {
    return TextFormField(
      controller: valorController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        hintText: 'Informe o valor',
        labelText: 'Valor',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Ionicons.cash_outline),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe um Valor';
        }
        final valor = NumberFormat.currency(locale: 'pt_BR')
            .parse(valorController.text.replaceAll('R\$', ''));
        if (valor <= 0) {
          return 'Informe um valor maior que zero';
        }

        return null;
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
            // Data
            final data = DateFormat('dd/MM/yyyy').parse(dataController.text);
            // Descricao
            final descricao = descricaoController.text;
            // Valor
            final valor = NumberFormat.currency(locale: 'pt_BR')
                .parse(valorController.text.replaceAll('R\$', ''));

            final userId = user?.id ?? '';

            // ignore: non_constant_identifier_names
            final transferencia = Transferencia(
                id: 0,
                userId: userId,
                descricao: descricao,
                tipoTransferencia: tipoTransferenciaSelecionada,
                usuario: usuarioSelecionado!,
                valor: valor.toDouble(),
                data: data,
                conta: contaSelecionada!);

            if (widget.transferenciaParaEdicao == null) {
              await _cadastrarTransferencia(transferencia);
            } else {
              transferencia.id = widget.transferenciaParaEdicao!.id;
              await _alterarTransferencia(transferencia);
            }
          }
        },
        child: const Text('Cadastrar'),
      ),
    );
  }

  Future<void> _cadastrarTransferencia(Transferencia transferencia) async {
    final Scaffold = ScaffoldMessenger.of(context);
    await transferenciaRepo.cadastrarTransferencia(transferencia).then((_) {
      Scaffold.showSnackBar(SnackBar(
        content: Text(
            'Transferência ${transferencia.tipoTransferencia == TipoTransferencia.enviada ? 'Enviada' : 'Despesa'} cadastrada com sucesso'),
      ));
      Navigator.of(context).pop(true);
    }).catchError((error) {
      Scaffold.showSnackBar(SnackBar(
        content: Text(
            'Erro ao cadastrar transferência ${transferencia.tipoTransferencia == TipoTransferencia.enviada ? 'Enviada' : 'Despesa'}'),
      ));

      Navigator.of(context).pop(false);
    });
  }

  Future<void> _alterarTransferencia(Transferencia transferencia) async {
    final Scaffold = ScaffoldMessenger.of(context);
    await transferenciaRepo.alterarTransferencia(transferencia).then((_) {
      Scaffold.showSnackBar(SnackBar(
        content: Text(
            'Transferência ${transferencia.tipoTransferencia == TipoTransferencia.enviada ? 'Enviada' : 'Despesa'} alterada com sucesso'),
      ));
      Navigator.of(context).pop(true);
    }).catchError((error) {
      Scaffold.showSnackBar(SnackBar(
        content: Text(
            'Erro ao alterar transferência ${transferencia.tipoTransferencia == TipoTransferencia.enviada ? 'Enviada' : 'Despesa'}'),
      ));

      Navigator.of(context).pop(false);
    });
  }
}
