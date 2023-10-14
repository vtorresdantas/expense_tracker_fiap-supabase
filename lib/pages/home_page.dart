import 'dart:async';

import 'package:expense_tracker/pages/categorias_page.dart';
import 'package:expense_tracker/pages/contas_page.dart';
import 'package:expense_tracker/pages/dashboard_page.dart';
import 'package:expense_tracker/pages/transacoes_page.dart';
import 'package:expense_tracker/pages/transferencia_page.dart';
import 'package:expense_tracker/pages/usuarios_page.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<AuthState>? authSubscription;
  int pageIndex = 0;

  @override
  void initState() {
    authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedOut) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      bottomNavigationBar: getFooter(),
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: pageIndex,
      children: const [
        DashBoardPage(),
        TransferenciasPage(),
        TransacoesPage(),
        ContasPage(),
        CategoriasPage(),
        UsuariosPage(),
      ],
    );
  }

  Widget getFooter() {
    List<BottomNavigationBarItem> items = const [
      BottomNavigationBarItem(
        icon: Icon(Ionicons.bar_chart_outline),
        label: 'Dashboard',
      ),
      BottomNavigationBarItem(
        icon: Icon(Ionicons.swap_vertical_outline),
        label: 'Transferências',
      ),
      BottomNavigationBarItem(
        icon: Icon(Ionicons.swap_horizontal_outline),
        label: 'Transações',
      ),
      BottomNavigationBarItem(
          icon: Icon(Ionicons.wallet_outline), label: 'Contas'),
      BottomNavigationBarItem(
          icon: Icon(Ionicons.list_outline), label: 'Categorias'),
      BottomNavigationBarItem(
          icon: Icon(Ionicons.person_add_outline), label: 'Usuários'),
    ];

    return BottomNavigationBar(
      items: items,
      type: BottomNavigationBarType.fixed,
      currentIndex: pageIndex,
      onTap: (index) {
        setState(() {
          pageIndex = index;
        });
      },
    );
  }

  @override
  void dispose() {
    authSubscription?.cancel();
    super.dispose();
  }
}
