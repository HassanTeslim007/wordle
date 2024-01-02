import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordle/main.dart';

class CustomKeyboard extends StatefulWidget {
  const CustomKeyboard({super.key});

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  Widget buildKey(
    String label, {
    int? flex = 1,
    double height = 30,
    bool isDelete = false,
  }) {
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
                }
                return Colors.blueAccent; // Use the component's default.
              },
            ),
          ),
          onPressed: () {
            // onKeyPressed(label);
          },
          child: isDelete
              ? const Center(child: Icon(Icons.backspace))
              : Center(child: Text(label)),
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
          if (key.isNotEmpty &&
              !key.isDigit() &&
              ((key.contains(RegExp(r'[A-Z]')) && key.length == 1) ||
                  key.toLowerCase() == 'backspace' ||
                  key.toLowerCase() == 'enter')) {
            // onKeyPressed(key);
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
