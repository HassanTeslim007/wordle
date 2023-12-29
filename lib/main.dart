import 'dart:developer' as p;
import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

void main() {
  runApp(const WordleGameApp());
}

class WordleGameApp extends StatelessWidget {
  const WordleGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Wordle Game',
      home: WordleGameScreen(),
    );
  }
}

class WordleGameScreen extends StatefulWidget {
  const WordleGameScreen({super.key});

  @override
  WordleGameScreenState createState() => WordleGameScreenState();
}

class WordleGameScreenState extends State<WordleGameScreen> {
  late String hiddenWord;

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    hiddenWord = generateWord();
  }

  String generateWord() {
    List<String> fiveLetterWords =
        all.where((word) => word.length == 5).toList();
    int randomIndex = Random().nextInt(fiveLetterWords.length);
    return fiveLetterWords[randomIndex].toUpperCase();
  }

  final TextEditingController controller1 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Wordle Game'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Guess the Word!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Hidden Word: $hiddenWord',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Pinput(
                useNativeKeyboard: false,
                controller: controller1,
                length: 5,
                showCursor: false,
              ),
              const Spacer(),
              CustomKeyboard(
                hiddenWord: hiddenWord,
                controller: controller1,
              ),
            ],
          ),
        ));
  }
}

class CustomKeyboard extends StatefulWidget {
  final TextEditingController controller;
  final String hiddenWord;
  const CustomKeyboard(
      {super.key, required this.controller, required this.hiddenWord});

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  List<String> wrongLetters = [];
  List<String> rightLetters = [];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          final String key = event.logicalKey.keyLabel;
          p.log(key);
          if (key.isNotEmpty &&
              !key.isDigit() &&
              ((key.contains(RegExp(r'[A-Z]')) && key.length == 1) ||
                  key.toLowerCase() == 'backspace' ||
                  key.toLowerCase() == 'enter')) {
            onKeyPressed(key);
          }
        }
      },
      child: Container(
        decoration: BoxDecoration(border: Border.all()),
        // height: size.height * 0.4,
        child: Column(
          children: [
            Row(
              children: [
                buildKey('Q', height: size.height / 11),
                buildKey('W', height: size.height / 11),
                buildKey('E', height: size.height / 11),
                buildKey('R', height: size.height / 11),
                buildKey('T', height: size.height / 11),
                buildKey('Y', height: size.height / 11),
                buildKey('U', height: size.height / 11),
                buildKey('I', height: size.height / 11),
                buildKey('O', height: size.height / 11),
                buildKey('P', height: size.height / 11),
              ],
            ),
            Row(
              children: [
                buildKey('A', height: size.height / 11),
                buildKey('S', height: size.height / 11),
                buildKey('D', height: size.height / 11),
                buildKey('F', height: size.height / 11),
                buildKey('G', height: size.height / 11),
                buildKey('H', height: size.height / 11),
                buildKey('J', height: size.height / 11),
                buildKey('K', height: size.height / 11),
                buildKey('L', height: size.height / 11),
              ],
            ),
            Row(
              children: [
                buildKey('Backspace',
                    flex: 2, height: size.height / 11, isDelete: true),
                buildKey('Z', height: size.height / 11),
                buildKey('X', height: size.height / 11),
                buildKey('C', height: size.height / 11),
                buildKey('V', height: size.height / 11),
                buildKey('B', height: size.height / 11),
                buildKey('N', height: size.height / 11),
                buildKey('M', height: size.height / 11),
                buildKey('Enter', flex: 2, height: size.height / 11),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildKey(
    String label, {
    int flex = 1,
    double height = 30,
    bool isDelete = false,
  }) {
    bool isWrongLetter = wrongLetters.contains(label);
    bool isRightLetter = rightLetters.contains(label);
    return Expanded(
      flex: flex,
      child: Container(
        height: height,
        margin: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  Colors.blueAccent.withOpacity(0.5);
                } else if (isWrongLetter) {
                  return Colors.red; // Change the color for pressed buttons
                } else if (isRightLetter) {
                  return Colors.green; // Change the color for pressed buttons
                }
                return Colors.blueAccent; // Use the component's default.
              },
            ),
          ),
          onPressed: () {
            onKeyPressed(label);
          },
          child: isDelete ? const Icon(Icons.backspace) : Text(label),
        ),
      ),
    );
  }

  void onKeyPressed(String key) {
    setState(() {
      if (key == 'Backspace') {
        if (widget.controller.text.isNotEmpty) {
          widget.controller.text = widget.controller.text
              .substring(0, widget.controller.text.length - 1);
        }
      } else if (key == 'Enter') {
        if (widget.controller.text.length < 5) {
          p.log('word incomplete');
          return;
        }
        updatePressedKeys();
      } else {
        if (widget.controller.text.length == 5) {
          p.log('word full');
          return;
        }
        widget.controller.text += key;
        // pressedKeys.add(key);
      }
    });
  }

  void updatePressedKeys() {
    // Get the entered word
    String enteredWord = widget.controller.text;

    // Check the entered word against the hidden word
    if (all.contains(enteredWord.toLowerCase())) {
      if (enteredWord == widget.hiddenWord) {
        p.log('Correct');
      } else {
        p.log('Wrong');
      }
      List<String> pressedKeys = [];

      pressedKeys = enteredWord.split('');

      p.log(pressedKeys.toString());

      setState(() {
        wrongLetters = pressedKeys
            .where((letter) => !widget.hiddenWord.split('').contains(letter))
            .toList();
        rightLetters = pressedKeys
            .where((letter) => widget.hiddenWord.split('').contains(letter))
            .toList();
      });
    } else {
      p.log('unknown word');
    }
  }
}

extension StringExtension on String {
  bool isDigit() {
    try {
      double.parse(this);
      return true;
    } catch (e) {
      return false;
    }
  }
}
