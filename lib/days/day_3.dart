import 'dart:io';

import 'package:aoc2020/days/day.dart';
import 'package:meta/meta.dart';

class Day3 extends Day<Map<String, int>> {
  Day3({@required this.inputPath});

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
    final rowSize = lines[0].length;
    final current = [0, 0];
    var result = 0;

    while (current[0] < lines.length) {
      if (lines[current[0]][current[1]] == '#') result++;

      current[0]++;
      current[1] = (current[1] + 3) % rowSize;
    }

    return result;
  }

  int _secondPart(List<String> lines) {
    final slopes = [
      [1, 1],
      [1, 3],
      [1, 5],
      [1, 7],
      [2, 1],
    ];
    final rowSize = lines[0].length;

    var result = 1;

    for (final slope in slopes) {
      final current = [0, 0];
      var trees = 0;

      while (current[0] < lines.length) {
        if (lines[current[0]][current[1]] == '#') trees++;

        current[0] += slope[0];
        current[1] = (current[1] + slope[1]) % rowSize;
      }

      result *= trees;
    }

    return result;
  }
}
