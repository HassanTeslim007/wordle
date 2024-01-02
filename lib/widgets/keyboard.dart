import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordle/core/models/letter.dart';

class CustomKeyboard extends StatelessWidget {
  final Function(String key) onKeyPressed;
  final VoidCallback onBackPressed;
  final VoidCallback onEnterPressed;
  final List<Letter> pressedKeys;
  const CustomKeyboard(
      {super.key,
      required this.onKeyPressed,
      required this.onBackPressed,
      required this.onEnterPressed,
      required this.pressedKeys});

  List<Letter> get correctKeys => pressedKeys
      .where((element) => element.status == LetterStatus.correct)
      .toList();

  List<Letter> get wrongKeys => pressedKeys
      .where((element) => element.status == LetterStatus.wrong)
      .toList();

  Widget buildKey(
    String label, {
    int? flex = 1,
    double height = 30,
    bool isDelete = false,
  }) {
    return Expanded(
      flex: flex ?? 0,
      child: InkWell(
        onTap: () {
          if (label.toLowerCase() == 'backspace') {
            onBackPressed();
          }
          if (label.toLowerCase() == 'enter') {
            onEnterPressed();
          }
          if (!(label.contains(RegExp(r'[A-Z]'))) || label.length != 1) {
            return;
          } else {
            onKeyPressed(label);
          }
        },
        child: Container(
          height: height,
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: pressedKeys
                      .where(
                          (element) => element.status == LetterStatus.correct)
                      .contains(Letter(label, status: LetterStatus.correct))
                  ? Colors.green.shade700
                  : pressedKeys
                          .where(
                              (element) => element.status == LetterStatus.wrong)
                          .contains(Letter(label, status: LetterStatus.wrong))
                      ? Colors.red.shade700
                      : pressedKeys
                              .where((element) =>
                                  element.status == LetterStatus.wrong)
                              .contains(
                                  Letter(label, status: LetterStatus.wrong))
                          ? Colors.yellow.shade700
                          : Colors.blueAccent),
          child: isDelete
              ? const Center(child: Icon(Icons.backspace))
              : Center(child: Text(label)),
          // child: ElevatedButton(
          //   style: ButtonStyle(
          //     backgroundColor: MaterialStateProperty.resolveWith<Color>(
          //       (Set<MaterialState> states) {
          //         if (states.contains(MaterialState.pressed)) {
          //           return Colors.blueAccent.withOpacity(0.5);
          // } else if (pressedKeys
          //     .where((element) => element.status == LetterStatus.correct)
          //     .contains(Letter(label, status: LetterStatus.correct))) {
          //   return Colors.green.shade700;
          // } else if (pressedKeys
          //             .where((element) => element.status == LetterStatus.wrong)
          //             .contains(Letter(label, status: LetterStatus.wrong))) {
          //           return Colors.red.shade700;
          //         } else if (pressedKeys
          //             .where((element) => element.status == LetterStatus.inWord)
          //             .contains(Letter(label, status: LetterStatus.inWord))) {
          //           return Colors.yellow.shade700;
          //         }
          //         return Colors.blueAccent; // Use the component's default.
          //       },
          //     ),
          //   ),
          //   onPressed: () {
          // if (label.toLowerCase() == 'backspace') {
          //   onBackPressed();
          // }
          // if (label.toLowerCase() == 'enter') {
          //   onEnterPressed();
          // }
          // if (!(label.contains(RegExp(r'[A-Z]'))) || label.length != 1) {
          //   return;
          // } else {
          //   onKeyPressed(label);
          // }
          //   },
          // child: isDelete
          //     ? const Center(child: Icon(Icons.backspace))
          //     : Center(child: Text(label)),
          // ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          if (key.toLowerCase() == 'backspace') {
            onBackPressed();
          }
          if (key.toLowerCase() == 'enter') {
            onEnterPressed();
          }
          if (!(key.contains(RegExp(r'[A-Z]'))) || key.length != 1) {
            return;
          } else {
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
}
