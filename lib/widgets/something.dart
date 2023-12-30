import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';

class Something extends StatefulWidget {
  const Something({super.key});

  @override
  State<Something> createState() => _SomethingState();
}

class _SomethingState extends State<Something> {
  double fontSize = 20;
  double strokeWidth = 1;
  String text = '';
  Color pickerColor = const Color(0xff443a49);
  Color textColor = const Color(0xff443a49);
  Color strokeColor = const Color(0xff443a49);
  bool isToggled = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text('Enter Text')),
              onChanged: (value) {
                text = value;
                setState(() {});
              },
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  text,
                  style: isToggled
                      ? GoogleFonts.monomaniacOne(
                          fontSize: fontSize,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = strokeWidth
                            ..color = strokeColor,
                        )
                      : TextStyle(
                          fontSize: fontSize,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = strokeWidth
                            ..color = strokeColor,
                        ),
                ),
                Text(
                  text,
                  style: isToggled
                      ? GoogleFonts.monomaniacOne(
                          fontSize: fontSize - 5,
                          color: textColor,
                        )
                      : TextStyle(
                          fontSize: fontSize,
                          color: textColor,
                        ),
                )
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        const Text('Select Text Color: '),
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Pick a color!'),
                                    content: SingleChildScrollView(
                                      child: ColorPicker(
                                        pickerColor: pickerColor,
                                        onColorChanged: (color) =>
                                            setState(() => pickerColor = color),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: const Text('Got it'),
                                        onPressed: () {
                                          setState(
                                              () => textColor = pickerColor);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                border: Border.all(), color: textColor),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const Text('Select Stroke Color: '),
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Pick a color!'),
                                    content: SingleChildScrollView(
                                      child: ColorPicker(
                                        pickerColor: pickerColor,
                                        onColorChanged: (color) =>
                                            setState(() => pickerColor = color),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        child: const Text('Got it'),
                                        onPressed: () {
                                          setState(
                                              () => strokeColor = pickerColor);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                border: Border.all(), color: strokeColor),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Toggle font:'),
                    Switch.adaptive(
                        value: isToggled,
                        onChanged: (val) {
                          isToggled = val;
                          setState(() {});
                        })
                  ],
                ),
                Row(
                  children: [
                    const Text('Fontsize:'),
                    Flexible(
                      child: Slider(
                          min: 20,
                          max: size.width / 4,
                          value: fontSize,
                          onChanged: (val) {
                            fontSize = val;
                            setState(() {});
                          }),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Stroke thickness:'),
                    Flexible(
                      child: Slider(
                          min: 1,
                          max: 20,
                          value: strokeWidth,
                          onChanged: (val) {
                            strokeWidth = val;
                            setState(() {});
                          }),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
