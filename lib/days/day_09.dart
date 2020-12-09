import 'dart:io';
import 'dart:math';

import 'package:aoc2020/days/day.dart';
import 'package:meta/meta.dart';

class Day09 extends Day<Map<String, int>> {
  Day09({@required this.inputPath});

  final String inputPath;

  @override
  Future<Map<String, int>> solve() async {
    final result = <String, int>{};

    final file = File(inputPath);
    final lines = file.readAsLinesSync();

    result['first'] = _firstPart(lines);
    result['second'] = _secondPart(lines);

    return result;
  }

  int _firstPart(List<String> lines) {
    const preamble = 25;

    int result;
    final numbers = <int>[];

    for (final line in lines) {
      var isValid = false;
      final curr = int.parse(line);

      if (numbers.length == preamble) {
        final rest = <int>{};
        for (final n in numbers) {
          if (rest.contains(curr - n)) {
            isValid = true;
          }
          rest.add(n);
        }
        numbers.removeAt(0);
      } else {
        isValid = true;
      }

      numbers.add(curr);

      if (!isValid && numbers.length == preamble) {
        result = curr;
        break;
      }
    }

    return result;
  }

  int _secondPart(List<String> lines) {
    const desired = 248131121;

    int result;
    final numbers = <int>[];
    var i = 0, acc = 0;

    for (final line in lines) {
      final curr = int.parse(line);
      numbers.add(curr);

      acc += curr;
      while (acc > desired) {
        acc -= numbers[i];
        i++;
      }

      if (acc == desired) {
        final sub = numbers.sublist(i);
        result = sub.reduce(min) + sub.reduce(max);
        break;
      }
    }

    return result;
  }
}
