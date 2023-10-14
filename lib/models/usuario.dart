class Usuario {
  final String id;
  final String nome;
  final String logo;

  const Usuario(this.id, this.nome, this.logo);
}

const Map<String, Usuario> usuarioMap = {
  "mulher": Usuario('mulher', 'Mulher', 'mulher.png'),
  "ladrao": Usuario('ladrao', 'Ladrão', 'ladrao.png'),
  "estudante": Usuario('estudante', 'Estudante', 'estudante.png'),
};
