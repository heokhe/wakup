import 'dart:math';

import 'package:english_words/english_words.dart' as english;

T _pickRandomly<T>(List<T> list) => list[Random().nextInt(list.length)];

String getANounAndAdjective() =>
    '${_pickRandomly(english.adjectives)} ${_pickRandomly(english.nouns)}';

String padWithZeros(int x) => x.toString().padLeft(2, '0');

String hm(int hour, int minute) => '${padWithZeros(hour)}:${padWithZeros(minute)}';
