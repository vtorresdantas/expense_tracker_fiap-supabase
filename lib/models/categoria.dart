import 'package:expense_tracker/models/tipo_transacao.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class Categoria {
  int id;
  String descricao;
  Color cor = Colors.red;
  IconData icone;
  TipoTransacao tipoTransacao;

  Categoria({
    required this.id,
    required this.descricao,
    required this.cor,
    required this.icone,
    required this.tipoTransacao,
  });

  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      id: map['id'],
      descricao: map['descricao'],
      cor: Color(map['cor']),
      icone: IoniconsData(map['icone']),
      tipoTransacao: TipoTransacao.values[map['tipo_transacao']],
    );
  }
}
