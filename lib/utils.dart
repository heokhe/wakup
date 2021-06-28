import 'dart:math';

import 'package:english_words/english_words.dart' as english;

T _pickRandomly<T>(List<T> list) => list[Random().nextInt(list.length)];

String capitalize(String string) {
  if (string.length == 0) return string;
  return string[0].toUpperCase() + string.substring(1);
}

String getANounAndAdjective() =>
    '${capitalize(_pickRandomly(english.adjectives))} ${capitalize(_pickRandomly(english.nouns))}';

String padWithZeros(int x) => x.toString().padLeft(2, '0');

