import 'dart:io';
import 'dart:math';

import 'package:aoc2020/days/day.dart';
import 'package:meta/meta.dart';

class Day13 extends Day<Map<String, int>> {
  Day13({@required this.inputPath});

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
    final arrive = int.parse(lines[0]);

    var earliestId = -1;
    var earliestArrive = double.maxFinite.toInt();

    for (final val in lines[1].split(',')) {
      if (val == 'x') continue;

      final id = int.parse(val);

      var divisor = arrive ~/ id;
      if (divisor * id < arrive) divisor++;

      if (divisor * id < earliestArrive) {
        earliestId = id;
        earliestArrive = divisor * id;
      }
    }

    return (earliestArrive - arrive) * earliestId;
  }

  int lcm(int a, int b) {
    return (a * b) ~/ a.gcd(b);
  }

  int _secondPart(List<String> lines) {
    var ids =
        lines[1].split(',').map((e) => e == 'x' ? -1 : int.parse(e)).toList();

    final remainders = <int>[];
    for (var i = 0; i < ids.length; i++) {
      if (ids[i] == -1) continue;

      remainders.add(i);
    }
    ids = ids.where((id) => id != -1).toList();

    var currLoop = ids[0];
    var currCount = ids[0];
    var index = 1;

    /// By using the Chinese Remainder Theorem: https://crypto.stanford.edu/pbc/notes/numbertheory/crt.html
    while (index < ids.length) {
      if ((currCount + remainders[index]) % ids[index] == 0) {
        currLoop *= ids[index];
        index++;
      } else {
        currCount += currLoop;
      }
    }

    return currCount;
  }
}
