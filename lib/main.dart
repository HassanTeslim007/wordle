import 'package:flutter/material.dart';
import 'package:wordle/presentation/wordle.dart';

void main() {
  runApp(const WordleGameApp());
}

class WordleGameApp extends StatelessWidget {
  const WordleGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Wordle Game',
      home: Wordle(),
      debugShowCheckedModeBanner: false,
    );
  }
}
