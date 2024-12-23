import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:animated_tic_tac_toe/components/game_table.dart';
import 'package:animated_tic_tac_toe/game_state.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameState(),
      child: Builder(
        builder: (context) => buildGame(context),
      ),
    );
  }

  Widget buildGame(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<GameState>(builder: (_, value, child) {
              return Text(
                value.upperText,
                style: const TextStyle(fontSize: 20),
              );
            }),
            Consumer<GameState>(builder: (_, value, child) {
              return const GameTable();
            })
          ],
        ),
      ),
    );
  }
}
