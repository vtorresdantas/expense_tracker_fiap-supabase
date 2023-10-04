class Conta {
  final int id;
  final String bancoId;
  final String descricao;
  final TipoConta tipoConta;

  Conta(
      {required this.id,
      required this.bancoId,
      required this.descricao,
      required this.tipoConta});

  factory Conta.fromMap(Map<String, dynamic> map) {
    return Conta(
      id: map['id'],
      bancoId: map['banco'],
      descricao: map['descricao'],
      tipoConta: TipoConta.values[map['tipo_conta']],
    );
  }
}

enum TipoConta { contaCorrente, contaPoupanca, contaInvestimento }
