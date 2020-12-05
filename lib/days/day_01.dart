import 'dart:io';

import 'package:aoc2020/days/day.dart';
import 'package:meta/meta.dart';

class Day01 extends Day<Map<String, int>> {
  Day01({@required this.inputPath});

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
    int result;
    final needed = <int>{};

    for (final line in lines) {
      final number = int.parse(line);
      final need = 2020 - number;

      if (needed.contains(need)) {
        result = number * need;
        break;
      }

      needed.add(number);
    }

    return result;
  }

  int _secondPart(List<String> lines) {
    int result;

    final numbers = lines.map((l) => int.parse(l)).toList();
    final rest = Set.from(numbers);

    for (var i = 0; i < numbers.length; i++) {
      for (var j = i + 1; j < numbers.length; j++) {
        final currentSum = numbers[i] + numbers[j];

        if (currentSum > 2020) {
          continue;
        }

        final need = 2020 - currentSum;

        if (rest.contains(need)) {
          result = numbers[i] * numbers[j] * need;
          break;
        }
      }
    }

    return result;
  }
}
