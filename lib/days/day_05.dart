import 'dart:io';

import 'package:aoc2020/days/day.dart';
import 'package:meta/meta.dart';

class Day05 extends Day<Map<String, int>> {
  Day05({@required this.inputPath});

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
    var max = -1;

    for (final line in lines) {
      final binRow = line.substring(0, 7);
      final binCol = line.substring(7, 10);

      final row = _binarySearch(binRow, 0, 0, 127);
      final col = _binarySearch(binCol, 0, 0, 7);

      final candidate = row * 8 + col;
      max = candidate > max ? candidate : max;
    }

    return max;
  }

  int _secondPart(List<String> lines) {
    var result;
    final ids = <int>{};
    final candidates = <int>[];

    for (final line in lines) {
      final binRow = line.substring(0, 7);
      final binCol = line.substring(7, 10);

      final row = _binarySearch(binRow, 0, 0, 127);
      final col = _binarySearch(binCol, 0, 0, 7);

      final id = row * 8 + col;

      if (ids.contains(id + 2)) {
        candidates.add(id + 1);
      } else if (ids.contains(id - 2)) {
        candidates.add(id - 1);
      }

      ids.add(id);
    }

    for (final candidate in candidates) {
      if (!ids.contains(candidate)) {
        result = candidate;
        break;
      }
    }

    return result;
  }

  int _binarySearch(String line, int cur, int min, int max) {
    if (min == max) return min;

    final c = line[cur];

    if (c == 'F' || c == 'L') {
      max = min + ((max - min) / 2.0).floor();
    } else {
      min = min + ((max - min) / 2.0).ceil();
    }

    return _binarySearch(line, cur + 1, min, max);
  }
}
