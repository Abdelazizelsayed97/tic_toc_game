import 'package:equatable/equatable.dart';


class GameState extends Equatable{
  final List<List<String>> board;
  final String winner;
  final bool isDraw;

  GameState({
    required this.board,
    this.winner = '',
    this.isDraw = false,
  });

  GameState copyWith({
    List<List<String>>? board,
    String? winner,
    bool? isDraw,
  }) {
    return GameState(
      board: board ?? this.board,
      winner: winner ?? this.winner,
      isDraw: isDraw ?? this.isDraw,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [board,winner,isDraw];
}