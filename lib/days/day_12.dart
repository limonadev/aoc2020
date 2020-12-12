import 'dart:io';

import 'package:aoc2020/days/day.dart';
import 'package:meta/meta.dart';

class Day12 extends Day<Map<String, int>> {
  Day12({@required this.inputPath});

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
    final directions = {
      'E': 0,
      'S': 1,
      'W': 2,
      'N': 3,
    };

    final movements = [
      [0, 1],
      [1, -1],
      [0, -1],
      [1, 1],
    ];

    /// As (x,y). So E/W = x/-x and N/S = y/-y
    final position = [0, 0];
    var facing = 0;

    for (final line in lines) {
      final order = line[0];
      final units = int.parse(line.substring(1));

      switch (order) {
        case 'F':
          position[movements[facing][0]] += movements[facing][1] * units;
          break;
        case 'R':
          final rotations = (units ~/ 90) % 4;
          facing = (facing + rotations) % 4;
          break;
        case 'L':
          final rotations = (units ~/ 90) % 4;
          facing = (facing - rotations) % 4;
          break;
        default:
          final moveTo = directions[order];
          position[movements[moveTo][0]] += movements[moveTo][1] * units;
      }
    }

    return position[0].abs() + position[1].abs();
  }

  int _secondPart(List<String> lines) {
    final directions = {
      'E': 0,
      'S': 1,
      'W': 2,
      'N': 3,
    };

    final movements = [
      [0, 1],
      [1, -1],
      [0, -1],
      [1, 1],
    ];

    final signs = [
      [1, 1],
      [1, -1],
      [-1, -1],
      [-1, 1],
    ];

    /// As (x,y). So E/W = x/-x and N/S = y/-y
    final shipPos = [0, 0];
    var wayPos = [10, 1];
    var waySign = 0;

    for (final line in lines) {
      final order = line[0];
      final units = int.parse(line.substring(1));

      switch (order) {
        case 'F':
          shipPos[0] += wayPos[0] * units;
          shipPos[1] += wayPos[1] * units;
          break;
        case 'R':
          final rotations = (units ~/ 90) % 4;
          if (rotations % 2 != 0) wayPos = wayPos.reversed.toList();
          waySign = (waySign + rotations) % 4;

          wayPos[0] =
              signs[waySign][0] == 1 ? wayPos[0].abs() : _toNeg(wayPos[0]);
          wayPos[1] =
              signs[waySign][1] == 1 ? wayPos[1].abs() : _toNeg(wayPos[1]);
          break;
        case 'L':
          final rotations = (units ~/ 90) % 4;
          if (rotations % 2 != 0) wayPos = wayPos.reversed.toList();
          waySign = (waySign - rotations) % 4;

          wayPos[0] =
              signs[waySign][0] == 1 ? wayPos[0].abs() : _toNeg(wayPos[0]);
          wayPos[1] =
              signs[waySign][1] == 1 ? wayPos[1].abs() : _toNeg(wayPos[1]);
          break;
        default:
          final moveTo = directions[order];
          wayPos[movements[moveTo][0]] += movements[moveTo][1] * units;

          final newSign = [
            wayPos[0].isNegative ? -1 : 1,
            wayPos[1].isNegative ? -1 : 1,
          ];

          waySign = _findSign(signs, newSign);
      }
    }

    return shipPos[0].abs() + shipPos[1].abs();
  }

  int _toNeg(int i) {
    return i < 0 ? i : -i;
  }

  int _findSign(List<List<int>> signs, List<int> newSign) {
    var result = -1;
    for (var i = 0; i < signs.length; i++) {
      final s = signs[i];
      if (s[0] == newSign[0] && s[1] == newSign[1]) {
        result = i;
        break;
      }
    }
    return result;
  }
}
