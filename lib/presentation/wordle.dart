import 'dart:math';

import 'package:english_words/english_words.dart';
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
  late String hiddenWord;
  String generateWord() {
    List<String> fiveLetterWords =
        all.where((word) => word.length == 5).toList();
    int randomIndex = Random().nextInt(fiveLetterWords.length);
    return fiveLetterWords[randomIndex].toUpperCase();
  }

  List<Word> words = List.generate(
      6, (index) => Word(List.generate(5, (index) => Letter.empty())));

  int _currentIndex = 0;

  Word? get _currentWord =>
      _currentIndex < words.length ? words[_currentIndex] : null;

  @override
  void initState() {
    hiddenWord = generateWord();
    print(hiddenWord);
    super.initState();
  }

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
            CustomKeyboard(
              onBackPressed: () {
                _currentWord?.removeLetter();
                setState(() {});
              },
              onEnterPressed: () {
                if (_currentWord!.letters.contains(Letter.empty())) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Word Incomplete'),
                    backgroundColor: Colors.red,
                  ));
                  return;
                } else {
                  String word = _currentWord!.wordString;
                  for (var i = 0; i < 5; i++) {
                    if (word[i] == hiddenWord[i]) {
                      print('right');
                      setState(() {
                        _currentWord!.letters[i] = _currentWord!.letters[i]
                            .copyWith(
                                value: word[i], status: LetterStatus.correct);
                      });
                    } else if (hiddenWord.contains(word[i])) {
                      print('in Word');
                      setState(() {
                        _currentWord!.letters[i] = _currentWord!.letters[i]
                            .copyWith(
                                value: word[i], status: LetterStatus.inWord);
                      });
                    } else {
                      print('wrong');
                      setState(() {
                        _currentWord!.letters[i] = _currentWord!.letters[i]
                            .copyWith(
                                value: word[i], status: LetterStatus.wrong);
                      });
                    }
                  }
                }
                _currentIndex++;
              },
              onKeyPressed: (key) {
                _currentWord?.addLetter(key);
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
