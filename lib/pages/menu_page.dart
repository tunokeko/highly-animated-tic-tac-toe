import 'package:flutter/material.dart';
import 'package:animated_tic_tac_toe/pages/game_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [theme.primaryColor, theme.primaryColorDark])),
        child: Center(
          child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const GamePage()));
              },
              child: const Text("Start")),
        ),
      ),
    );
  }
}
