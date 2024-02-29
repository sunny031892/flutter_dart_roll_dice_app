import 'dart:math';
import 'package:flutter/material.dart';
import 'styled_text.dart';

final randomizer = Random();

class DiceRoller extends StatefulWidget {
  const DiceRoller({super.key, this.onGameEnd, this.onResetGame});
  final Function(bool)? onGameEnd;
  final VoidCallback? onResetGame;

  @override
  State<DiceRoller> createState() {
    return _DiceRollerState();
  }
}

class _DiceRollerState extends State<DiceRoller> {
  var currentDiceRoll = 2;
  List<int> rolls = [];
  bool gameEnded = false;

  void rollDice() {
    if (!gameEnded) {
      setState(() {
        currentDiceRoll = randomizer.nextInt(6) + 1;
        rolls.add(currentDiceRoll);
      });

      int totalScore = rolls.fold(0, (sum, element) => sum + element);
      if (rolls.length == 5 || totalScore >= 20) {
        setState(() {
          gameEnded = true;
        });
        bool isWin = totalScore >= 20;
        Future.microtask(() => widget.onGameEnd?.call(isWin));
      }
    }
  }

  void resetGame() {
    setState(() {
      rolls.clear();
      gameEnded = false;
    });
    widget.onResetGame?.call();
  }

  @override
  Widget build(context) {
    int totalScore = rolls.fold(0, (sum, element) => sum + element);
    List<String> displayRolls = List.generate(5, (index) => index < rolls.length ? rolls[index].toString() : '--');
    int chancesLeft = 5 - rolls.length;
    double progress = (totalScore / 20).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const StyledText('Your score'),
        StyledText('$totalScore/20'),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            color: Colors.grey,
            minHeight: 8,
          ),
        ),
        const StyledText('1st    2nd    3rd    4th    5th'),
        StyledText('${displayRolls[0]}        ${displayRolls[1]}        ${displayRolls[2]}        ${displayRolls[3]}        ${displayRolls[4]}'),
        Image.asset(
          'assets/images/dice-$currentDiceRoll.png',
          width: 200,
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: gameEnded ? resetGame : rollDice,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 28),
          ),
          child: StyledText(gameEnded ? 'Play Again' : 'Roll Dice'),
        ),
        StyledText('Chance left: $chancesLeft')
      ],
    );
  }
}
