import 'package:flutter/material.dart';
import 'package:animated_tic_tac_toe/components/o_tile.dart';
import 'package:animated_tic_tac_toe/components/x_tile.dart';
import 'package:animated_tic_tac_toe/game_state.dart';

class GameTile extends StatelessWidget {
  final Player? player;
  final int index;
  const GameTile({super.key, required this.index, this.player});

  BorderSide blackLine() => const BorderSide(color: Colors.black26);
  BorderSide transparentLine() => BorderSide.none;

  Map<String, BorderSide> orderLine() {
    Map<String, BorderSide> borderOrder = {
      "top": blackLine(),
      "right": blackLine(),
      "bottom": blackLine(),
      "left": blackLine()
    };
    List<int> leftSpace = [0, 3, 6];
    List<int> rightSpace = [2, 5, 8];
    List<int> topSpace = [0, 1, 2];
    List<int> bottomSpace = [6, 7, 8];

    if (topSpace.contains(index)) {
      borderOrder["top"] = transparentLine();
    }
    if (leftSpace.contains(index)) {
      borderOrder["left"] = transparentLine();
    }
    if (rightSpace.contains(index)) {
      borderOrder["right"] = transparentLine();
    }
    if (bottomSpace.contains(index)) {
      borderOrder["bottom"] = transparentLine();
    }

    return borderOrder;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, BorderSide> borderOrder = orderLine();
    return Container(
      decoration: BoxDecoration(
          border: Border(
              top: borderOrder[
                  "top"]!, // in dart a map always returns nullable since the key might not be in the list
              left: borderOrder["left"]!,
              right: borderOrder["right"]!,
              bottom: borderOrder["bottom"]!)),
      child: player == Player.X
          ? const XTile()
          : player == Player.O
              ? const OTile()
              : null,
    );
  }
}
