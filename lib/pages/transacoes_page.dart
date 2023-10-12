import 'package:expense_tracker/components/transacao_item.dart';
import 'package:expense_tracker/models/tipo_transacao.dart';
import 'package:expense_tracker/models/transacao.dart';
import 'package:expense_tracker/pages/transacao_cadastro_page.dart';

import 'package:expense_tracker/repository/transacoes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransacoesPage extends StatefulWidget {
  const TransacoesPage({super.key});

  @override
  State<TransacoesPage> createState() => _TransacoesPageState();
}

class _TransacoesPageState extends State<TransacoesPage> {
  // Repositório para operações relacionadas a transações
  final transacoesRepo = TransacoesReepository();

  // Lista de transações que será carregada de forma assíncrona
  late Future<List<Transacao>> futureTransacoes;

  // Usuário autenticado
  User? user;

  @override
  void initState() {
    // Obtendo o usuário autenticado
    user = Supabase.instance.client.auth.currentUser;

    // Inicializando a lista de transações
    futureTransacoes = transacoesRepo.listarTransacoes(userId: user?.id ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transações'),
        actions: [
          // Menu pop-up para filtrar as transações
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
            // Indicador de carregamento enquanto as transações estão sendo carregadas
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Exibindo uma mensagem em caso de erro
            return const Center(
              child: Text("Erro ao carregar as transações"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Exibindo uma mensagem se não houver transações ou se a lista estiver vazia
            return const Center(
              child: Text("Nenhuma transação cadastrada"),
            );
          } else {
            // Construindo a lista de transações
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
                            // Atualizando a lista de transações após a edição
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
                          // Excluindo a transação
                          await transacoesRepo.excluirTransacao(transacao.id);

                          // Atualizando a lista de transações após a exclusão
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
          // Navegando para a página de cadastro de transação
          final result =
              await Navigator.pushNamed(context, '/transacao-cadastro')
                  as bool?;

          if (result == true) {
            // Atualizando a lista de transações após a adição de uma nova transação
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
