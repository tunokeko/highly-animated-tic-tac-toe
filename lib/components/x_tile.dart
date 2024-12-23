import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_tic_tac_toe/game_state.dart';

class XTile extends StatefulWidget {
  const XTile({super.key});

  @override
  State<XTile> createState() => _XTileState();
}

class _XTileState extends State<XTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> leftLine;
  late Animation<double> rightLine;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    // Tween
    Tween<double> lineTween = Tween(begin: 0.25, end: 0.75);
    leftLine = lineTween.animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.45)));
    rightLine = lineTween.animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.55, 1.0)));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
      context.read<GameState>().startAnimation();
      _controller.addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          context.read<GameState>().stopAnimation();
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: XTilePainter(
                leftLineValue: leftLine.value, rightLineValue: rightLine.value),
            child: Container(),
          );
        });
  }
}

class XTilePainter extends CustomPainter {
  final double leftLineValue;
  final double rightLineValue;

  XTilePainter(
      {super.repaint,
      required this.leftLineValue,
      required this.rightLineValue});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(size.width * 0.25, size.height * 0.25),
        Offset(size.width * leftLineValue, size.height * leftLineValue), paint);

    canvas.drawLine(
        Offset(size.width * 0.75, size.height * 0.25),
        Offset(size.width * (1 - rightLineValue), size.height * rightLineValue),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
