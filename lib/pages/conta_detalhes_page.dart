import 'package:expense_tracker/models/conta.dart';
import 'package:flutter/material.dart';

class ContaDetalhesPage extends StatefulWidget {
  const ContaDetalhesPage({super.key});

  @override
  State<ContaDetalhesPage> createState() => _ContaDetalhesPageState();
}

class _ContaDetalhesPageState extends State<ContaDetalhesPage> {
  @override
  Widget build(BuildContext context) {
    final conta = ModalRoute.of(context)!.settings.arguments as Conta;

    return Scaffold();
  }
}
