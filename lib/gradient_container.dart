import 'package:flutter/material.dart';

import 'dice_roller.dart';

const startAlignment = Alignment.topLeft;
const endAlignment = Alignment.bottomRight;

class GradientContainer extends StatefulWidget {
  const GradientContainer({super.key});

  @override
  State<GradientContainer> createState() => _GradientContainerState();
}

class _GradientContainerState extends State<GradientContainer> {
  Color color1 = Colors.deepPurple;
  Color color2 = Colors.indigo;
  String message = '';

  void resetBackground() {
    setState(() {
      color1 = Colors.deepPurple;
      color2 = Colors.indigo;
      message = '';
    });
  }

  void onGameEnd(bool isWin) {
    setState(() {
      if (isWin) {
        color1 = Colors.lightGreen;
        color2 = Colors.green;
        message = 'You win!';
      } else {
        color1 = Colors.redAccent;
        color2 = Colors.deepOrange;
        message = 'You lose!';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: startAlignment,
          end: endAlignment,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DiceRoller(
              onGameEnd: onGameEnd,
              onResetGame: resetBackground,
            ), 
            if (message.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  message,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
