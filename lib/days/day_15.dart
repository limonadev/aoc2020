import 'dart:io';

import 'package:aoc2020/days/day.dart';
import 'package:meta/meta.dart';

class Day15 extends Day<Map<String, int>> {
  Day15({@required this.inputPath});

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
    final starters = lines[0]
        .split(',')
        .map(
          (e) => int.parse(e),
        )
        .toList();

    final mem = <int, int>{};
    for (var i = 0; i < starters.length; i++) {
      mem[starters[i]] = i;
    }

    final turns = 2020;

    var lastSpoken = 0;
    for (var i = starters.length; i < turns - 1; i++) {
      final modifier = mem.containsKey(lastSpoken) ? i - mem[lastSpoken] : 0;
      mem[lastSpoken] = i;
      lastSpoken = modifier;
    }

    return lastSpoken;
  }

  int _secondPart(List<String> lines) {
    final starters = lines[0]
        .split(',')
        .map(
          (e) => int.parse(e),
        )
        .toList();

    final mem = <int, int>{};
    for (var i = 0; i < starters.length; i++) {
      mem[starters[i]] = i;
    }

    final turns = 30000000;

    var lastSpoken = 0;
    for (var i = starters.length; i < turns - 1; i++) {
      final modifier = mem.containsKey(lastSpoken) ? i - mem[lastSpoken] : 0;
      mem[lastSpoken] = i;
      lastSpoken = modifier;
    }

    return lastSpoken;
  }
}
