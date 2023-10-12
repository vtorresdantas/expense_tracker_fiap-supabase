import 'package:expense_tracker/models/conta.dart';
import 'package:expense_tracker/models/transferencia.dart';
import 'package:expense_tracker/repository/transferencias_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransferenciaCadastroPage extends StatefulWidget {
  final Transferencia? transferenciaParaEdicao;

  const TransferenciaCadastroPage({Key? key, this.transferenciaParaEdicao});

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

  @override
  void initState() {
    user = Supabase.instance.client.auth.currentUser;

    final transferencia = widget.transferenciaParaEdicao;

    if (transferencia != null) {
      contaSelecionada = transferencia.conta;

      descricaoController.text = transferencia.descricao;

      valorController.text = NumberFormat.simpleCurrency(locale: 'pt_BR')
          .format(transferencia.valor);

      dataController.text = DateFormat('MM/dd/yyyy').format(transferencia.data);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
