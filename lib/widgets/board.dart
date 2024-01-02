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
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: widget.letter.status == LetterStatus.correct
            ? Colors.green
            : widget.letter.status == LetterStatus.wrong
                ? Colors.red
                : widget.letter.status == LetterStatus.inWord
                    ? Colors.amberAccent
                    : Colors.transparent,
        border: Border.all(
            color: widget.letter.status == LetterStatus.initial
                ? Colors.grey
                : Colors.transparent),
      ),
      child: Center(
        child: Text(
          widget.letter.value,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
        ),
      ),
    );
  }
}
