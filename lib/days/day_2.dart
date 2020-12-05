import 'dart:io';

import 'package:aoc2020/days/day.dart';
import 'package:meta/meta.dart';

class Day2 extends Day<Map<String, int>> {
  Day2({@required this.inputPath});

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
    var result = 0;

    for (final line in lines) {
      final split = line.split(' ');
      final limits = split[0].split('-').map((l) => int.parse(l)).toList();
      final letter = split[1][0].codeUnitAt(0);
      final password = split[2];

      if (_isOldValid(
        letter: letter,
        limits: limits,
        password: password,
      )) result++;
    }

    return result;
  }

  int _secondPart(List<String> lines) {
    var result = 0;

    for (final line in lines) {
      final split = line.split(' ');
      final limits = split[0].split('-').map((l) => int.parse(l)).toList();
      final letter = split[1][0].codeUnitAt(0);
      final password = split[2];

      if ((password.codeUnitAt(limits[0] - 1) == letter) ^
          (password.codeUnitAt(limits[1] - 1) == letter)) result++;
    }

    return result;
  }

  bool _isOldValid({
    @required int letter,
    @required List<int> limits,
    @required String password,
  }) {
    var count = 0;
    for (var c in password.codeUnits) {
      if (c == letter) count++;
    }

    return count >= limits[0] && count <= limits[1];
  }
}
