import 'package:expense_tracker/models/tipo_transferencia.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/transferencia_item.dart';
import '../models/transferencia.dart';
import '../pages/transferencia_cadastro_page.dart';
import '../repository/transferencias_repository.dart';

class TransferenciasPage extends StatefulWidget {
  const TransferenciasPage({super.key});

  @override
  State<TransferenciasPage> createState() => _TransferenciasPageState();
}

class _TransferenciasPageState extends State<TransferenciasPage> {
  final transferenciasRepo = TransferenciasRepository();
  late Future<List<Transferencia>> futureTransferencias;
  User? user;

  @override
  void initState() {
    user = Supabase.instance.client.auth.currentUser;
    futureTransferencias =
        transferenciasRepo.listarTransferencias(userId: user?.id ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferências'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: const Text('Todas'),
                  onTap: () {
                    setState(() {
                      futureTransferencias = transferenciasRepo
                          .listarTransferencias(userId: user?.id ?? '');
                    });
                  },
                ),
                PopupMenuItem(
                  child: const Text('Enviadas'),
                  onTap: () {
                    setState(() {
                      futureTransferencias =
                          transferenciasRepo.listarTransferencias(
                        userId: user?.id ?? '',
                        tipoTransferencia: TipoTransferencia.enviada,
                      );
                    });
                  },
                ),
                PopupMenuItem(
                  child: const Text('Recebidas'),
                  onTap: () {
                    setState(() {
                      futureTransferencias =
                          transferenciasRepo.listarTransferencias(
                        userId: user?.id ?? '',
                        tipoTransferencia: TipoTransferencia.recebida,
                      );
                    });
                  },
                ),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Transferencia>>(
        future: futureTransferencias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Erro ao carregar transferências"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Nenhuma transferência encontrada"),
            );
          } else {
            final transferencias = snapshot.data!;
            double totalEnviadas = 0;
            double totalRecebidas = 0;

            for (var transferencia in transferencias) {
              if (transferencia.tipoTransferencia ==
                  TipoTransferencia.enviada) {
                totalEnviadas += transferencia.valor;
              } else if (transferencia.tipoTransferencia ==
                  TipoTransferencia.recebida) {
                totalRecebidas += transferencia.valor;
              }
            }

            double saldoFinal = totalRecebidas - totalEnviadas;

            return Column(
              children: [
                Text('Saldo Final: $saldoFinal'),
                Expanded(
                  child: ListView.separated(
                    itemCount: transferencias.length,
                    itemBuilder: (context, index) {
                      final transferencia = transferencias[index];
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        TransferenciaCadastroPage(
                                      transferenciaParaEdicao: transferencia,
                                    ),
                                  ),
                                ) as bool?;

                                if (result == true) {
                                  setState(() {
                                    futureTransferencias =
                                        transferenciasRepo.listarTransferencias(
                                            userId: user?.id ?? '');
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
                                await transferenciasRepo
                                    .excluirTransferencia(transferencia.id);

                                setState(() {
                                  transferencias.removeAt(index);
                                });
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Remover',
                            ),
                          ],
                        ),
                        child: TransferenciaItem(
                          transferencia: transferencia,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/transferencia-detalhes',
                              arguments: transferencia,
                            );
                          },
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "transferencia-cadastro",
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            '/transferencia-cadastro',
          ) as bool?;

          if (result == true) {
            setState(() {
              futureTransferencias = transferenciasRepo.listarTransferencias(
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
