import 'package:expense_tracker/pages/transacao_cadastro_page.dart';
import 'package:expense_tracker/repository/transacoes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/transacao_item.dart';
import '../models/tipo_transacao.dart';
import '../models/transacao.dart';

class TransacoesPage extends StatefulWidget {
  const TransacoesPage({super.key});

  @override
  State<TransacoesPage> createState() => _TransacoesPageState();
}

class _TransacoesPageState extends State<TransacoesPage> {
  final transacoesRepo = TransacoesReepository();
  late Future<List<Transacao>> futureTransacoes;
  User? user;

  @override
  void initState() {
    user = Supabase.instance.client.auth.currentUser;
    futureTransacoes = transacoesRepo.listarTransacoes(userId: user?.id ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transações'),
        actions: [
          // create a filter menu action
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: const Text('Todas'),
                  onTap: () {
                    setState(() {
                      futureTransacoes = transacoesRepo.listarTransacoes(
                          userId: user?.id ?? '');
                    });
                  },
                ),
                PopupMenuItem(
                  child: const Text('Receitas'),
                  onTap: () {
                    setState(() {
                      futureTransacoes = transacoesRepo.listarTransacoes(
                          userId: user?.id ?? '',
                          tipoTransacao: TipoTransacao.receita);
                    });
                  },
                ),
                PopupMenuItem(
                  child: const Text('Despesas'),
                  onTap: () {
                    setState(() {
                      futureTransacoes = transacoesRepo.listarTransacoes(
                          userId: user?.id ?? '',
                          tipoTransacao: TipoTransacao.despesa);
                    });
                  },
                ),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Transacao>>(
        future: futureTransacoes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Erro ao carregar as transações"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Nenhuma transação cadastrada"),
            );
          } else {
            final transacoes = snapshot.data!;
            return ListView.separated(
              itemCount: transacoes.length,
              itemBuilder: (context, index) {
                final transacao = transacoes[index];
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransacaoCadastroPage(
                                transacaoParaEdicao: transacao,
                              ),
                            ),
                          ) as bool?;

                          if (result == true) {
                            setState(() {
                              futureTransacoes =
                                  transacoesRepo.listarTransacoes(
                                userId: user?.id ?? '',
                              );
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
                          await transacoesRepo.excluirTransacao(transacao.id);

                          setState(() {
                            transacoes.removeAt(index);
                          });
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Remover',
                      ),
                    ],
                  ),
                  child: TransacaoItem(
                    transacao: transacao,
                    onTap: () {
                      Navigator.pushNamed(context, '/transacao-detalhes',
                          arguments: transacao);
                    },
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
        heroTag: "transacao-cadastro",
        onPressed: () async {
          final result =
              await Navigator.pushNamed(context, '/transacao-cadastro')
                  as bool?;

          if (result == true) {
            setState(() {
              futureTransacoes = transacoesRepo.listarTransacoes(
                userId: user?.id ?? '',
              );
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
