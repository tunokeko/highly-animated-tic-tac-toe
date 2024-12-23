import 'package:flutter/material.dart';

enum Player {
  X(text: "X"),
  O(text: "O");

  final String text;

  const Player({required this.text});
}

enum GameStatus { ongoing, finished }

class GameState extends ChangeNotifier {
  Player currentPlayer = Player.X;
  GameStatus status = GameStatus.ongoing;
  List<Player?> gameShape = [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null
  ];
  List<List<int>> winningLines = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6]
  ];
  List<int> winningLine = [];
  bool isAnimating = false;

  String get upperText {
    if (status == GameStatus.ongoing && gameShape.every((el) => el != null)) {
      return "It is a draw";
    } else if (status == GameStatus.ongoing) {
      return "It is ${currentPlayer.text}'s turn";
    } else {
      return "${currentPlayer.text} won";
    }
  }

  void startAnimation() {
    if (isAnimating) return;
    isAnimating = true;
    notifyListeners();
  }

  void stopAnimation() {
    if (!isAnimating) return;
    isAnimating = false;
    notifyListeners();
  }

  void changeGameShape(int index) {
    if (gameShape[index] == null) {
      notifyListeners();
      gameShape[index] = currentPlayer;
      bool hasWinningLine = winningLines.any((element) {
        return element.every((int index) => gameShape[index] == currentPlayer);
      });

      if (hasWinningLine) {
        status = GameStatus.finished;
        notifyListeners();
        Future.delayed(const Duration(milliseconds: 500), () {
          winningLine = winningLines.firstWhere(
            (List<int> list) =>
                list.every((int index) => gameShape[index] == currentPlayer),
            orElse: () => [],
          );
          notifyListeners();
        });
      } else {
        currentPlayer = currentPlayer == Player.X ? Player.O : Player.X;
      }
    }
  }
}
