class Usuario {
  int id;
  String nome;
  String email;
  String logo;

  Usuario(
      {required this.id,
      required this.nome,
      required this.email,
      required this.logo});

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      logo: map['logo'],
    );
  }
}
