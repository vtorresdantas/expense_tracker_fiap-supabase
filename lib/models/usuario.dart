class Usuario {
  int id;
  String nome;
  String email;

  Usuario({required this.id, required this.nome, required this.email});

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['user_id'],
      nome: map['nome'],
      email: map['email'],
    );
  }
}
