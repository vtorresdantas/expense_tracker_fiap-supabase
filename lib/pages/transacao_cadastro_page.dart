import 'package:expense_tracker/components/categoria_select.dart';
import 'package:expense_tracker/models/categoria.dart';
import 'package:expense_tracker/models/tipo_transacao.dart';
import 'package:expense_tracker/models/transacao.dart';
import 'package:expense_tracker/pages/categorias_select_page.dart';
import 'package:expense_tracker/pages/contas_select_page.dart';
import 'package:expense_tracker/repository/transacoes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../components/conta_select.dart';
import '../models/conta.dart';

class TransacaoCadastroPage extends StatefulWidget {
  final Transacao? transacaoParaEdicao;

  const TransacaoCadastroPage({super.key, this.transacaoParaEdicao});

  @override
  State<TransacaoCadastroPage> createState() => _TransacaoCadastroPageState();
}

class _TransacaoCadastroPageState extends State<TransacaoCadastroPage> {
  User? user;
  final transacoesRepo = TransacoesReepository();

  final descricaoController = TextEditingController();
  final valorController = MoneyMaskedTextController(
      decimalSeparator: ',', thousandSeparator: '.', leftSymbol: 'R\$');

  final dataController = TextEditingController();

  final detalhesController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  TipoTransacao tipoTransacaoSelecionada = TipoTransacao.receita;

  Categoria? categoriaSelecionada;
  Conta? contaSelecionada;

  @override
  void initState() {
    user = Supabase.instance.client.auth.currentUser;

    final transacao = widget.transacaoParaEdicao;

    if (transacao != null) {
      categoriaSelecionada = transacao.categoria;
      contaSelecionada = transacao.conta;

      descricaoController.text = transacao.descricao;
      tipoTransacaoSelecionada = transacao.tipoTransacao;
      detalhesController.text = transacao.detalhes;

      valorController.text =
          NumberFormat.simpleCurrency(locale: 'pt_BR').format(transacao.valor);

      dataController.text = DateFormat('MM/dd/yyyy').format(transacao.data);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Transação'),
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
                _buildTipoTransacao(),
                const SizedBox(height: 30),
                _buildCategoriaSelect(),
                const SizedBox(height: 30),
                _buildContaSelect(),
                const SizedBox(height: 30),
                _buildValor(),
                const SizedBox(height: 30),
                _buildData(),
                const SizedBox(height: 30),
                _buildDetalhes(),
                const SizedBox(height: 30),
                _buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CategoriaSelect _buildCategoriaSelect() {
    return CategoriaSelect(
      categoria: categoriaSelecionada,
      onTap: () async {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CategoriesSelectPage(
              tipoTransacao: tipoTransacaoSelecionada,
            ),
          ),
        ) as Categoria?;

        if (result != null) {
          setState(() {
            categoriaSelecionada = result;
          });
        }
      },
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

  DropdownMenu<TipoTransacao> _buildTipoTransacao() {
    return DropdownMenu<TipoTransacao>(
      width: MediaQuery.of(context).size.width - 16,
      initialSelection: tipoTransacaoSelecionada,
      label: const Text('Tipo de Transação'),
      dropdownMenuEntries: const [
        DropdownMenuEntry(
          value: TipoTransacao.receita,
          label: "Receita",
        ),
        DropdownMenuEntry(
          value: TipoTransacao.despesa,
          label: "Despesa",
        ),
      ],
      onSelected: (value) {
        tipoTransacaoSelecionada = value!;
        setState(() {
          categoriaSelecionada = null;
        });
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
            // Detalhes
            final detalhes = detalhesController.text;

            final userId = user?.id ?? '';

            final transacao = Transacao(
              id: 0,
              userId: userId,
              descricao: descricao,
              tipoTransacao: tipoTransacaoSelecionada,
              valor: valor.toDouble(),
              data: data,
              categoria: categoriaSelecionada!,
              conta: contaSelecionada!,
              detalhes: detalhes,
            );

            if (widget.transacaoParaEdicao == null) {
              await _cadastrarTransacao(transacao);
            } else {
              transacao.id = widget.transacaoParaEdicao!.id;
              await _alterarTransacao(transacao);
            }
          }
        },
        child: const Text('Cadastrar'),
      ),
    );
  }

  TextFormField _buildDetalhes() {
    return TextFormField(
      controller: detalhesController,
      decoration: const InputDecoration(
        hintText: 'Detalhes da transação',
        labelText: 'Detalhes',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.multiline,
      maxLines: 2,
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

  Future<void> _cadastrarTransacao(Transacao transacao) async {
    final scaffold = ScaffoldMessenger.of(context);
    await transacoesRepo.cadastrarTransacao(transacao).then((_) {
      // Mensagem de Sucesso
      scaffold.showSnackBar(SnackBar(
        content: Text(
          '${transacao.tipoTransacao == TipoTransacao.receita ? 'Receita' : 'Despesa'} cadastrada com sucesso',
        ),
      ));
      Navigator.of(context).pop(true);
    }).catchError((error) {
      // Mensagem de Erro
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Erro ao cadastrar ${transacao.tipoTransacao == TipoTransacao.receita ? 'Receita' : 'Despesa'}',
        ),
      ));

      Navigator.of(context).pop(false);
    });
  }

  Future<void> _alterarTransacao(Transacao transacao) async {
    final scaffold = ScaffoldMessenger.of(context);
    await transacoesRepo.alterarTransacao(transacao).then((_) {
      // Mensagem de Sucesso
      scaffold.showSnackBar(SnackBar(
        content: Text(
          '${transacao.tipoTransacao == TipoTransacao.receita ? 'Receita' : 'Despesa'} alterada com sucesso',
        ),
      ));
      Navigator.of(context).pop(true);
    }).catchError((error) {
      // Mensagem de Erro
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Erro ao alterar ${transacao.tipoTransacao == TipoTransacao.receita ? 'Receita' : 'Despesa'}',
        ),
      ));

      Navigator.of(context).pop(false);
    });
  }
}
