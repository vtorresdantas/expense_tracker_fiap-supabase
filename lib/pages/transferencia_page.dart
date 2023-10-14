// Importando pacotes e componentes necessários
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Importando componentes e modelos customizados
import '../components/transferencia_item.dart';
import '../models/transferencia.dart';
import '../pages/transferencia_cadastro_page.dart';
import '../repository/transferencias_repository.dart';

// Definindo uma classe para a página de transferências
class TransferenciasPage extends StatefulWidget {
  const TransferenciasPage({super.key});

  @override
  State<TransferenciasPage> createState() => _TransferenciasPageState();
}

// Estado associado à página de transferências
class _TransferenciasPageState extends State<TransferenciasPage> {
  // Inicializando o repositório e a Future para as transferências
  final transferenciasRepo = TransferenciasRepository();
  late Future<List<Transferencia>> futureTransferencias;
  User? user;

  @override
  void initState() {
    // Obtendo o usuário autenticado e iniciando a busca por transferências
    user = Supabase.instance.client.auth.currentUser;
    futureTransferencias =
        transferenciasRepo.listarTransferencias(userId: user?.id ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Construindo a interface da página
    return Scaffold(
      // Barra superior com o título "Transferências"
      appBar: AppBar(
        title: const Text('Transferências'),
      ),
      body: FutureBuilder<List<Transferencia>>(
        future: futureTransferencias,
        builder: (context, snapshot) {
          // Construindo o corpo da página baseado no estado da Future
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Mostrando um indicador de carregamento se a Future está pendente
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Exibindo uma mensagem de erro se ocorreu um erro
            return const Center(
              child: Text("Erro ao carregar transferências"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Informando se não há dados de transferências
            return const Center(
              child: Text("Nenhuma transferência encontrada"),
            );
          } else {
            // Construindo a lista de transferências se houver dados
            final transferencias = snapshot.data!;
            return ListView.separated(
              itemCount: transferencias.length,
              itemBuilder: (context, index) {
                final transferencia = transferencias[index];
                return Slidable(
                  // Configuração de ações deslizantes (editar e excluir)
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          // Navegando para a página de edição
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransferenciaCadastroPage(
                                transferenciaParaEdicao: transferencia,
                              ),
                            ),
                          ) as bool?;

                          if (result == true) {
                            // Atualizando a lista após edição bem-sucedida
                            setState(() {
                              futureTransferencias = transferenciasRepo
                                  .listarTransferencias(userId: user?.id ?? '');
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
                          // Excluindo uma transferência
                          await transferenciasRepo
                              .excluirTransferencia(transferencia.id);

                          // Atualizando a lista após a exclusão bem-sucedida
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
                      // Navegando para a página de detalhes da transferência
                      Navigator.pushNamed(context, '/transferencia-detalhes',
                          arguments: transferencia);
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) {
                // Adicionando divisores entre os itens da lista
                return const Divider();
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "transferencia-cadastro",
        onPressed: () async {
          // Navegando para a página de cadastro de transação
          final result =
              await Navigator.pushNamed(context, '/transferencia-cadastro')
                  as bool?;

          if (result == true) {
            // Atualizando a lista após a adição de uma nova transação
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
