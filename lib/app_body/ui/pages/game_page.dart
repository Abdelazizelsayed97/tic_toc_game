import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state_management/game_cubit/game_cubit.dart';
import '../state_management/game_cubit/game_state.dart';
import '../widgets/show_dialog.dart';

class TicTacToeGame extends StatelessWidget {
  final Function(String) onGameEnd;

  const TicTacToeGame({super.key, required this.onGameEnd});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TicTacToeCubit(),
      child: BlocListener<TicTacToeCubit, GameState>(
        listener: (context, state) {
          if (state.winner.isNotEmpty) {
            ShowDialog.handleWhoWins(state.winner, context);
            if (state.winner == "X") {
              onGameEnd(state.winner);
            }
          } else if (state.isDraw) {
            ShowDialog.handleWhoWins('Draw', context);
          }
        },
        child: BlocBuilder<TicTacToeCubit, GameState>(
          builder: (context, state) {
            return Column(
              children: [
                for (int i = 0; i < 3; i++)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int j = 0; j < 3; j++)
                        GestureDetector(
                          onTap: () =>
                              context.read<TicTacToeCubit>().makeMove(i, j),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: Center(
                              child: Text(
                                state.board[i][j],
                                style: TextStyle(fontSize: 40),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                if (state.winner.isNotEmpty || state.isDraw)
                  Text(
                    state.winner.isNotEmpty
                        ? 'Winner: ${state.winner}'
                        : 'It\'s a Draw!',
                    style: TextStyle(fontSize: 24),
                  ),
                ElevatedButton(
                  onPressed: () => context.read<TicTacToeCubit>().resetGame(),
                  child: Text('Reset Game'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
