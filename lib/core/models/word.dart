import 'package:wordle/core/models/letter.dart';

class Word {
  final List<Letter> letters;

  Word(this.letters);

  String get wordString => letters.map((e) => e.value).join();

  void addLetter(String val) {
    if (letters.length < 5) {
      letters.add(Letter(val));
    }
  }

  void removeLetter(){
    if(letters.isNotEmpty){
      letters.removeLast(); 
    }
  }
}
