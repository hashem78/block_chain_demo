import 'package:block_chain_demo/presentation/home/actions_pane.dart';
import 'package:block_chain_demo/presentation/home/log_pane.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: const ActionsPane()),
          Expanded(child: const LogPane()),
        ],
      ),
    );
  }
}
