class Banco {
  final String id;
  final String nome;
  final String logo;

  const Banco(this.id, this.nome, this.logo);
}

const Map<String, Banco> bancosMap = {
  "bb": Banco('bb', 'Banco do Brasil', 'bb.png'),
  "bmg": Banco('bmg', 'Bmg', 'bmg.png'),
  "bradesco": Banco('bradesco', 'Bradesco', 'bradesco.png'),
  "c6bank": Banco('c6bank', 'C6 Bank', 'c6bank.png'),
  "caixa": Banco('caixa', 'Caixa', 'caixa.png'),
  "inter": Banco('inter', 'Inter', 'inter.png'),
  "itau": Banco('itau', 'Itau', 'itau.png'),
  "neon": Banco('neon', 'Neon', 'neon.png'),
  "nubank": Banco('nubank', 'Nubank', 'nubank.png'),
  "original": Banco('original', 'Original', 'original.png'),
  "pan": Banco('pan', 'Pan', 'pan.png'),
  "picpay": Banco('picpay', 'Picpay', 'picpay.png'),
  "santander": Banco('santander', 'Santander', 'santander.png'),
  "sofisa": Banco('sofisa', 'Sofisa', 'sofisa.png'),
};
