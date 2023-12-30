import 'dart:developer' as p;
import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:wordle/core/utils/utils.dart';
import 'package:wordle/widgets/something.dart';

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
    for (int i = 0; i < 5; i++) {
      controllers.add(TextEditingController());
      focusNodes.add(FocusNode());
    }
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

  List<TextEditingController> controllers = [];
  List<FocusNode> focusNodes = [];
  bool isCorrect = false;
  List<int> correctness = List.filled(5, 0);
  Widget buildKey(
    String label, {
    int? flex = 1,
    double height = 30,
    bool isDelete = false,
  }) {
    bool isWrongLetter = wrongLetters.contains(label);
    bool isRightLetter = rightLetters.contains(label);
    return Expanded(
      flex: flex ?? 0,
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
          child: isDelete
              ? const Center(child: Icon(Icons.backspace))
              : Center(child: Text(label)),
        ),
      ),
    );
  }

  PinTheme _pinTheme(int? correctness) {
    return PinTheme(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            color: correctness == 0
                ? Colors.black12
                : correctness == 1
                    ? Colors.amberAccent
                    : correctness == 2
                        ? Colors.green
                        : null,
            borderRadius: BorderRadius.circular(10)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Wordle Game'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Something()));
                },
                icon: const Icon(Icons.ramen_dining))
          ],
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
              ySpace(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // InputField(
                  //   controller: controllers[0],
                  //   index: 0,
                  // ),
                  // InputField(
                  //   controller: controllers[1],
                  //   index: 1,
                  // ),
                  // InputField(
                  //   controller: controllers[2],
                  //   index: 2,
                  // ),
                  // InputField(
                  //   controller: controllers[3],
                  //   index: 3,
                  // ),
                  // InputField(
                  //   controller: controllers[4],
                  //   index: 4,
                  // ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Pinput(
                        length: 1,
                        controller: controllers[0],
                        focusNode: focusNodes[0],
                        useNativeKeyboard: false,
                        showCursor: false,
                        defaultPinTheme: _pinTheme(correctness[0])),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Pinput(
                        length: 1,
                        controller: controllers[1],
                        focusNode: focusNodes[1],
                        useNativeKeyboard: false,
                        showCursor: false,
                        defaultPinTheme: _pinTheme(correctness[1])),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Pinput(
                        length: 1,
                        controller: controllers[2],
                        focusNode: focusNodes[2],
                        useNativeKeyboard: false,
                        showCursor: false,
                        defaultPinTheme: _pinTheme(correctness[2])),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Pinput(
                        length: 1,
                        controller: controllers[3],
                        focusNode: focusNodes[3],
                        useNativeKeyboard: false,
                        showCursor: false,
                        defaultPinTheme: _pinTheme(correctness[3])),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Pinput(
                        length: 1,
                        controller: controllers[4],
                        focusNode: focusNodes[4],
                        useNativeKeyboard: false,
                        showCursor: false,
                        defaultPinTheme: _pinTheme(correctness[4])),
                  )
                ],
              ),
              const Spacer(),
              customKeyboard(),
            ],
          ),
        ));
  }

  List<String> wrongLetters = [];
  List<String> rightLetters = [];

  Widget customKeyboard() {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    if (size.height > size.width) {
      height = size.width;
    }
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          final String key = event.logicalKey.keyLabel;
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
                buildKey('Q', height: height / 11),
                buildKey('W', height: height / 11),
                buildKey('E', height: height / 11),
                buildKey('R', height: height / 11),
                buildKey('T', height: height / 11),
                buildKey('Y', height: height / 11),
                buildKey('U', height: height / 11),
                buildKey('I', height: height / 11),
                buildKey('O', height: height / 11),
                buildKey('P', height: height / 11),
              ],
            ),
            Row(
              children: [
                buildKey('A', height: height / 11),
                buildKey('S', height: height / 11),
                buildKey('D', height: height / 11),
                buildKey('F', height: height / 11),
                buildKey('G', height: height / 11),
                buildKey('H', height: height / 11),
                buildKey('J', height: height / 11),
                buildKey('K', height: height / 11),
                buildKey('L', height: height / 11),
              ],
            ),
            Row(
              children: [
                buildKey('Backspace',
                    flex: 2, height: height / 11, isDelete: true),
                buildKey('Z', height: height / 11),
                buildKey('X', height: height / 11),
                buildKey('C', height: height / 11),
                buildKey('V', height: height / 11),
                buildKey('B', height: height / 11),
                buildKey('N', height: height / 11),
                buildKey('M', height: height / 11),
                buildKey('Enter', flex: 2, height: height / 11),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onKeyPressed(String key) {
    setState(() {
      if (key == 'Backspace') {
        if (controllers[4].text.isNotEmpty) {
          controllers[4].clear();
          FocusScope.of(context).requestFocus(focusNodes[3]);
        } else if (controllers[3].text.isNotEmpty) {
          controllers[3].clear();
          FocusScope.of(context).requestFocus(focusNodes[2]);
        } else if (controllers[2].text.isNotEmpty) {
          controllers[2].clear();
          FocusScope.of(context).requestFocus(focusNodes[1]);
        } else if (controllers[1].text.isNotEmpty) {
          controllers[1].clear();
          FocusScope.of(context).requestFocus(focusNodes[0]);
        } else if (controllers[0].text.isNotEmpty) {
          controllers[0].clear();
          FocusScope.of(context).requestFocus(focusNodes[0]);
        }
      } else if (key == 'Enter') {
        if (controllers[4].text.isEmpty) {
          p.log('word incomplete');
          return;
        }
        updatePressedKeys();
      } else {
        if (controllers[4].text.isNotEmpty) {
          p.log('word full');
          return;
        }
        if (controllers[0].text.isEmpty) {
          controllers[0].text += key;
          FocusScope.of(context).requestFocus(focusNodes[1]);
        } else if (controllers[1].text.isEmpty) {
          controllers[1].text += key;
          FocusScope.of(context).nextFocus();
        } else if (controllers[2].text.isEmpty) {
          controllers[2].text += key;
          FocusScope.of(context).nextFocus();
        } else if (controllers[3].text.isEmpty) {
          controllers[3].text += key;
          FocusScope.of(context).nextFocus();
        } else if (controllers[4].text.isEmpty) {
          controllers[4].text += key;
          FocusScope.of(context).nextFocus();
        }

        FocusScope.of(context).nextFocus();
        p.log(key);
        // pressedKeys.add(key);
      }
    });
  }

  void updatePressedKeys() {
    // Get the entered word
    String enteredWord = controllers.map((c) => c.text).join();

    // Check the entered word against the hidden word
    if (all.map((e) => e.toLowerCase()).contains(enteredWord.toLowerCase())) {
      //field 1
      if (hiddenWord.contains(controllers[0].text) &&
          hiddenWord[0] == controllers[0].text) {
        correctness[0] = 2;
      } else if (hiddenWord.contains(controllers[0].text) &&
          hiddenWord[0] != controllers[0].text) {
        correctness[0] = 1;
      } else if (!hiddenWord.contains(controllers[0].text)) {
        correctness[0] = 0;
      }

      //field 2
      if (hiddenWord.contains(controllers[1].text) &&
          hiddenWord[1] == controllers[1].text) {
        correctness[1] = 2;
      } else if (hiddenWord.contains(controllers[1].text) &&
          hiddenWord[1] != controllers[1].text) {
        correctness[1] = 1;
      } else if (!hiddenWord.contains(controllers[0].text)) {
        correctness[1] = 0;
      }

      //field 3
      if (hiddenWord.contains(controllers[2].text) &&
          hiddenWord[2] == controllers[2].text) {
        correctness[2] = 2;
      } else if (hiddenWord.contains(controllers[2].text) &&
          hiddenWord[2] != controllers[2].text) {
        correctness[2] = 1;
      } else if (!hiddenWord.contains(controllers[2].text)) {
        correctness[2] = 0;
      }

      //field 4
      if (hiddenWord.contains(controllers[3].text) &&
          hiddenWord[3] == controllers[3].text) {
        correctness[3] = 2;
      } else if (hiddenWord.contains(controllers[3].text) &&
          hiddenWord[3] != controllers[3].text) {
        correctness[3] = 1;
      } else if (!hiddenWord.contains(controllers[0].text)) {
        correctness[3] = 0;
      }

      //field 5
      if (hiddenWord.contains(controllers[4].text) &&
          hiddenWord[4] == controllers[4].text) {
        correctness[4] = 2;
      } else if (hiddenWord.contains(controllers[4].text) &&
          hiddenWord[4] != controllers[5].text) {
        correctness[4] = 1;
      } else if (!hiddenWord.contains(controllers[4].text)) {
        correctness[4] = 0;
      }

      p.log(correctness.toString());
      setState(() {});
      List<String> pressedKeys = [];

      pressedKeys = enteredWord.split('');

      p.log(pressedKeys.toString());

      setState(() {
        wrongLetters = pressedKeys
            .where((letter) => !hiddenWord.split('').contains(letter))
            .toList();
        rightLetters = pressedKeys
            .where((letter) => hiddenWord.split('').contains(letter))
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
