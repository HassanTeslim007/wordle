import 'package:flutter/material.dart';
import 'package:wordle/core/utils/utils.dart';

class InputField extends StatefulWidget {
  const InputField({super.key});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(
          5,
          (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: 50,
              child: TextField(
                autofocus: true,
                showCursor: false,
                maxLength: 1,
                onChanged: (value) {
                  if (value.length == 1) FocusScope.of(context).nextFocus();
                  if (value.isEmpty) FocusScope.of(context).previousFocus();
                },
                textAlign: TextAlign.center,
                decoration: inputDecoration(),
              )),
        )
        // xSpace(10),
        // SizedBox(
        //     width: 50,

        //     child: TextField(

        //       decoration: inputDecoration(),
        //     )),
        // xSpace(10),
        // SizedBox(
        //     width: 50,
        //     child: TextField(
        //       decoration: inputDecoration(),
        //     )),
        // xSpace(10),
        // SizedBox(
        //     width: 50,
        //     child: TextField(
        //       decoration: inputDecoration(),
        //     )),
        // xSpace(10),
        // SizedBox(
        //     width: 50,
        //     child: TextField(
        //       decoration: inputDecoration(),
        //     )),
      ],
    );
  }
}

InputDecoration inputDecoration() {
  return InputDecoration(
      filled: true,
      counterText: ' ',
      fillColor: Colors.red,
      border: OutlineInputBorder());
}
