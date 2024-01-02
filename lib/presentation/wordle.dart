import 'package:flutter/material.dart';
import 'package:wordle/core/models/letter.dart';
import 'package:wordle/core/models/word.dart';
import 'package:wordle/widgets/board.dart';
import 'package:wordle/widgets/keyboard.dart';

class Wordle extends StatefulWidget {
  const Wordle({super.key});

  @override
  State<Wordle> createState() => _WordleState();
}

class _WordleState extends State<Wordle> {
  List<Word> words = List.generate(
      6, (index) => Word(List.generate(5, (index) => Letter.empty())));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        title: const Text('Wordle'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Board(words: words),
            const Spacer(),
            const CustomKeyboard(),
          ],
        ),
      ),
    );
  }
}
