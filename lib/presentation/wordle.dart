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
  GameStatus status = GameStatus.playing;
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
    getHiddenWord();
    super.initState();
  }

  void getHiddenWord() {
    hiddenWord = generateWord();
    print(hiddenWord);
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
                if (status == GameStatus.over) {
                  playAgain();
                  return;
                }
                checkLetters();
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

  void checkLetters() {
    if (_currentWord!.letters.contains(Letter.empty())) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Word Incomplete'),
        backgroundColor: Colors.red,
      ));
      return;
    } else {
      String word = _currentWord!.wordString;
      if (!all.map((e) => e.toLowerCase()).contains(word.toLowerCase())) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Word not found'),
          backgroundColor: Colors.red,
        ));
        return;
      }
      for (var i = 0; i < 5; i++) {
        if (word[i] == hiddenWord[i]) {
          setState(() {
            _currentWord!.letters[i] = _currentWord!.letters[i]
                .copyWith(value: word[i], status: LetterStatus.correct);
          });
        } else if (hiddenWord.contains(word[i])) {
          setState(() {
            _currentWord!.letters[i] = _currentWord!.letters[i]
                .copyWith(value: word[i], status: LetterStatus.inWord);
          });
        } else {
          setState(() {
            _currentWord!.letters[i] = _currentWord!.letters[i]
                .copyWith(value: word[i], status: LetterStatus.wrong);
          });
        }
      }
    }
    checkWord();
    if (_currentIndex < 6) {
      _currentIndex++;
    }
  }

  void checkWord() async {
    // print(_currentWord?.wordString ?? 'I dont');
    String word = _currentWord!.wordString;
    if (word == hiddenWord) {
      status = GameStatus.over;
      await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Congratulation! You win"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      playAgain();
                      Navigator.pop(context);
                    },
                    child: const Text("Play Again"))
              ],
            );
          });
    }

    if (_currentIndex == 5) {
      if (!mounted) return;
      if (word != hiddenWord) {
        status = GameStatus.over;
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("You lose"),
                content: Text('The word is $hiddenWord'),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        playAgain();
                        Navigator.pop(context);
                      },
                      child: const Text("Play Again"))
                ],
              );
            });
      }
    }
  }

  void playAgain() {
    status = GameStatus.starts;
    _currentIndex = 0;
    words.clear();
    words = List.generate(
        6, (index) => Word(List.generate(5, (index) => Letter.empty())));
    getHiddenWord();
    setState(() {});
  }
}

enum GameStatus { starts, playing, over }
