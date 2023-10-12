// Importação de bibliotecas e módulos necessários
import 'package:expense_tracker/components/conta_item.dart';
import 'package:expense_tracker/models/conta.dart';
import 'package:expense_tracker/pages/conta_cadastro_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../repository/contas_repository.dart';

// Definição da classe ContasPage
class ContasPage extends StatefulWidget {
  const ContasPage({super.key});

  @override
  State<ContasPage> createState() => _ContasPageState();
}

class _ContasPageState extends State<ContasPage> {
  // Instância do repositório de contas
  final contasRepo = ContasRepository();

  // Futuro que será usado para atualizar a lista de contas
  late Future<List<Conta>> futureContas;

  @override
  void initState() {
    // Inicializando a lista de transações
    futureContas = ContasRepository().listarContas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar com título 'Contas'
      appBar: AppBar(
        title: const Text('Contas'),
      ),
      body: FutureBuilder<List<Conta>>(
        // O futuro é a lista de contas obtida do repositório
        future: futureContas,
        builder: (context, snapshot) {
          // Verifica o estado da conexão e decide o que renderizar
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Se a conexão está em andamento, exibe um indicador de carregamento
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Se ocorreu um erro, mostra uma mensagem de erro
            return const Center(
              child: Text("Erro ao carregar contas"),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Se não há dados ou os dados estão vazios, exibe uma mensagem indicando que nenhuma conta foi encontrada
            return const Center(
              child: Text("Nenhuma conta encontrada"),
            );
          } else {
            // Lista de contas disponível, constrói a interface
            final contas = snapshot.data!;
            return ListView.separated(
              itemCount: contas.length,
              itemBuilder: (context, index) {
                final conta = contas[index];
                return Slidable(
                  // Slidable permite ações deslizantes
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      // Ação de editar conta
                      SlidableAction(
                        onPressed: (context) async {
                          // Abre a página de edição da conta
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ContaCadastroPage(
                                contaParaEdicao: conta,
                              ),
                            ),
                          ) as bool?;

                          // Atualiza a lista se a edição foi bem-sucedida
                          if (result == true) {
                            setState(() {
                              futureContas = contasRepo.listarContas();
                            });
                          }
                        },
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Editar',
                      ),
                      // Ação de remover conta
                      SlidableAction(
                        onPressed: (context) async {
                          // Exclui a conta
                          await contasRepo.excluirConta(conta.id);

                          setState(() {
                            contas.removeAt(index);
                          });
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Remover',
                      ),
                    ],
                  ),
                  // Widget que representa a conta
                  child: ContaItem(
                    conta: conta,
                    onTap: () {
                      // Navega para a página de detalhes da conta
                      Navigator.pushNamed(context, '/conta-detalhes',
                          arguments: conta);
                    },
                  ),
                );
              },
              // Separador entre os itens da lista
              separatorBuilder: (context, index) {
                return const Divider();
              },
            );
          }
        },
      ),
      // Botão de ação flutuante para adicionar nova conta
      floatingActionButton: FloatingActionButton(
        heroTag: "conta-cadastro",
        onPressed: () async {
          // Navega para a página de cadastro de contas
          final result =
              await Navigator.pushNamed(context, '/conta-cadastro') as bool?;

          // Atualiza a lista se o cadastro foi bem-sucedido
          if (result == true) {
            setState(() {
              futureContas = contasRepo.listarContas();
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
