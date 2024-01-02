// ignore_for_file: public_member_api_docs, sort_constructors_first
class Letter {
  final String value;
  final LetterStatus status;

  Letter(this.value, {this.status = LetterStatus.initial});

  factory Letter.empty() => Letter('');

  Letter copyWith({
    String? value,
    LetterStatus? status,
  }) {
    return Letter(
      value ?? this.value,
     status: status ?? this.status,
    );
  }
}

enum LetterStatus { initial, correct, inWord, wrong }
