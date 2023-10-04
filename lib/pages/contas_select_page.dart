import 'package:flutter/material.dart';

import '../models/banco.dart';
import '../models/conta.dart';
import '../repository/contas_repository.dart';

class ContasSelectPage extends StatefulWidget {
  const ContasSelectPage({super.key});

  @override
  State<ContasSelectPage> createState() => _ContasSelectPageState();
}

class _ContasSelectPageState extends State<ContasSelectPage> {
  final contasRepository = ContasRepository();
  late Future<List<Conta>> contasFuture;

  @override
  void initState() {
    contasFuture = contasRepository.listarContas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contas'),
      ),
      body: FutureBuilder<List<Conta>>(
          future: contasFuture,
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
              final contas = snapshot.data!;
              return ListView.separated(
                itemCount: contas.length,
                itemBuilder: (context, index) {
                  final conta = contas[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(
                          'images/${bancosMap[conta.bancoId]?.logo}'),
                    ),
                    title: Text(conta.descricao),
                    subtitle: Text(bancosMap[conta.bancoId]?.nome ?? ''),
                    onTap: () {
                      Navigator.of(context).pop(conta);
                    },
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              );
            }
          }),
    );
  }
}
