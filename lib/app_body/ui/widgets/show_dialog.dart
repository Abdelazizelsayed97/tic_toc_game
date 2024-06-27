import 'package:flutter/material.dart';
import 'package:tic_tac_toe_game_second_clone/core/helpers/spacer.dart';

class ShowDialog {
  static void handleWhoWins(String mark, BuildContext context) {
    String message;
    Color color;

    if (mark == 'X') {
      message = 'You Win';
      color = Colors.green.shade400;
    } else if (mark == 'O') {
      message = 'Bot Wins';
      color = Colors.red.shade400;
    } else {
      message = 'It\'s a Draw';
      color = Colors.blue.shade400;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                mark,
                style: const TextStyle(color: Colors.white, fontSize: 30),
              ),
              const SizedBox(height: 20),
              Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 30),
              ),
              verticalSpace(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(color)),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
