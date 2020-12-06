import 'dart:io';

import 'package:aoc2020/days/day.dart';
import 'package:meta/meta.dart';

class Day06 extends Day<Map<String, int>> {
  Day06({@required this.inputPath});

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
    var memory = <int>{};
    var result = 0;

    for (final line in [...lines, '']) {
      if (line.isEmpty) {
        result += memory.length;
        memory.clear();
        continue;
      }

      line.codeUnits.toSet().forEach((c) => memory.add(c - 97));
    }

    return result;
  }

  int _secondPart(List<String> lines) {
    var memory = List.filled(26, 0);
    var people = 0;
    var result = 0;

    for (final line in [...lines, '']) {
      if (line.isEmpty) {
        result += memory.fold(
          0,
          (p, e) => p += e == people ? 1 : 0,
        );
        memory = List.filled(26, 0);
        people = 0;
        continue;
      }

      line.codeUnits.toSet().forEach((c) => memory[c - 97]++);
      people++;
    }

    return result;
  }
}
