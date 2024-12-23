import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animated_tic_tac_toe/game_state.dart';

class OTile extends StatefulWidget {
  const OTile({super.key});

  @override
  State<OTile> createState() => _OTileState();
}

class _OTileState extends State<OTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _degreeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    Tween<double> degreeTween = Tween<double>(begin: 0.0, end: 360.0);
    _degreeAnimation = degreeTween.animate(_controller);

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
            painter: OTilePainter(degreeValue: _degreeAnimation.value),
            child: Container(),
          );
        });
  }
}

class OTilePainter extends CustomPainter {
  final double degreeValue;

  OTilePainter({super.repaint, required this.degreeValue});
  double degreeToRadian(int degree) {
    return (pi / 180) * degree;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    Rect rect = Rect.fromCircle(
        center: Offset(size.width * 0.5, size.height * 0.5),
        radius: size.width * 0.25);

    canvas.drawArc(rect, degreeToRadian(-90),
        degreeToRadian(degreeValue.toInt()), false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
