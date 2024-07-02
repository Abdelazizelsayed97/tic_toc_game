import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'game_state.dart';

class TicTacToeCubit extends Cubit<GameState> {
  TicTacToeCubit()
      : super(GameState(
            board: List.generate(3, (_) => List.generate(3, (_) => ''))));

  String _currentPlayer = 'X';

  void resetGame() {
    emit(
        GameState(board: List.generate(3, (_) => List.generate(3, (_) => ''))));
    _currentPlayer = 'X';
  }

  void makeMove(int row, int col) {
    if (state.board[row][col].isEmpty && state.winner.isEmpty) {
      final newBoard = state.board.map((row) => row.toList()).toList();
      newBoard[row][col] = _currentPlayer;
      if (_checkWinner(newBoard, _currentPlayer)) {
        emit(GameState(board: newBoard, winner: _currentPlayer));
      } else if (newBoard
          .every((row) => row.every((cell) => cell.isNotEmpty))) {
        emit(GameState(board: newBoard, isDraw: true));
      } else {
        _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
        emit(GameState(board: newBoard));
        if (_currentPlayer == 'O') {
          _botMove();
        }
      }
    }
  }

  void _botMove() {
    final newBoard = state.board.map((row) => row.toList()).toList();
    Timer(
      const Duration(milliseconds: 800),
      () {
        for (int i = 0; i < 3; i++) {
          for (int j = 0; j < 3; j++) {
            if (newBoard[i][j].isEmpty) {
              newBoard[i][j] = 'O';
              if (_checkWinner(newBoard, 'O')) {
                emit(GameState(board: newBoard, winner: 'O'));
              } else if (newBoard
                  .every((row) => row.every((cell) => cell.isNotEmpty))) {
                emit(GameState(board: newBoard, isDraw: true));
              } else {
                _currentPlayer = 'X';
                emit(GameState(board: newBoard));
              }
              return;
            }
          }
        }
      },
    );
  }

  bool _checkWinner(List<List<String>> board, String player) {
    for (int i = 0; i < 3; i++) {
      if (board[i].every((cell) => cell == player) ||
          board.every((row) => row[i] == player)) {
        return true;
      }
    }
    if (board[0][0] == player &&
        board[1][1] == player &&
        board[2][2] == player) {
      return true;
    }
    if (board[0][2] == player &&
        board[1][1] == player &&
        board[2][0] == player) {
      return true;
    }
    return false;
  }
}
