import 'package:flutter/material.dart';
import 'package:wordle/core/models/letter.dart';
import 'package:wordle/core/models/word.dart';

class Board extends StatefulWidget {
  final List<Word> words;
  const Board({super.key, required this.words});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: widget.words
            .map((word) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: word.letters
                      .map((letter) => LetterBox(letter: letter))
                      .toList(),
                ))
            .toList());
  }
}

class LetterBox extends StatefulWidget {
  final Letter letter;
  const LetterBox({super.key, required this.letter});

  @override
  State<LetterBox> createState() => _LetterBoxState();
}

class _LetterBoxState extends State<LetterBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
            color: widget.letter.status == LetterStatus.initial
                ? Colors.grey
                : Colors.transparent),
      ),
      child: Center(
        child: Text(widget.letter.value),
      ),
    );
  }
}
