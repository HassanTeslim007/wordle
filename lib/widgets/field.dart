import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final int index;
  final TextEditingController controller;
  const InputField({super.key, required this.controller, required this.index});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: 50,
        child: TextField(
          
          controller: widget.controller,
          autofocus: widget.index == 0,
          showCursor: true,
          maxLength: 1,
          textAlign: TextAlign.center,
          decoration: inputDecoration(),
        ));
  }
}

InputDecoration inputDecoration() {
  return const InputDecoration(
      filled: true,
      counterText: ' ',
      fillColor: Colors.red,
      border: OutlineInputBorder());
}
