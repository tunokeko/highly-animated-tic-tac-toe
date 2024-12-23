import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_tic_tac_toe/components/game_tile.dart';
import 'package:animated_tic_tac_toe/game_state.dart';

class GameTable extends StatefulWidget {
  const GameTable({super.key});

  @override
  State<GameTable> createState() => _GameTableState();
}

class _GameTableState extends State<GameTable>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GameState gameState = Provider.of<GameState>(context);
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: FinishingTilePainter(
                finishingLine: gameState.winningLine, animation: _controller),
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              padding: EdgeInsets
                  .zero, // by default grid view has a padding at the top
              children: List.generate(gameState.gameShape.length, (index) {
                return GestureDetector(
                  onTap: () {
                    if (gameState.isAnimating ||
                        gameState.status == GameStatus.finished) {
                      return;
                    }
                    context.read<GameState>().changeGameShape(index);
                  },
                  child: GameTile(
                      player: gameState.gameShape[index], index: index),
                );
              }),
            ),
          );
        });
  }
}

class FinishingTilePainter extends CustomPainter {
  final List<int> finishingLine;
  final AnimationController animation;

  FinishingTilePainter(
      {super.repaint, required this.finishingLine, required this.animation});

  Tween<double>? _tweenX;
  Tween<double>? _tweenY;
  Animation<double>? _animationX;
  Animation<double>? _animationY;
  @override
  void paint(Canvas canvas, Size size) {
    if (finishingLine.isEmpty) {
      return;
    }
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    int yLineStart = ((finishingLine[0] + 1) / 3).ceil();
    double xLineStart = (finishingLine[0]) - ((yLineStart - 1) * 3) + 1;
    int yLineEnd = ((finishingLine[2] + 1) / 3).ceil();
    double xLineEnd = (finishingLine[2]) - ((yLineEnd - 1) * 3) + 1;

    if (_animationX == null && _animationY == null) {
      _tweenX = Tween(begin: xLineStart, end: xLineEnd);
      _tweenY = Tween(begin: yLineStart.toDouble(), end: yLineEnd.toDouble());
      _animationX = _tweenX?.animate(animation);
      _animationY = _tweenY?.animate(animation);
      animation.forward();
    }

    double start = 1;
    double end = 1;
    canvas.drawLine(
        Offset((size.width / 6) * (start + (2 * (xLineStart - 1))),
            (size.height / 6) * (end + (2 * (yLineStart - 1)))),
        Offset(size.width / 6 * (start + (2 * (_animationX!.value - 1))),
            size.height / 6 * (end + (2 * (_animationY!.value - 1)))),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
