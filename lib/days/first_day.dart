import 'dart:io';

import 'package:aoc2020/days/day.dart';
import 'package:meta/meta.dart';

class FirstDay extends Day<int> {
  FirstDay({@required this.inputPath});

  final String inputPath;

  @override
  Future<int> solve() async {
    final needed = <int>{};
    int result;

    final file = File(inputPath);
    final lines = file.readAsLinesSync();

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
}
