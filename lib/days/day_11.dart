import 'dart:io';

import 'package:aoc2020/days/day.dart';
import 'package:meta/meta.dart';

/// TODO: The second part can be optimized in terms of space:
/// Instead of using String everywhere, an integer as index
/// could potentially reduce the real space required.
/// The algorithm anyways has O(nlgn) amortized time and space
/// because of sorting
class Day11 extends Day<Map<String, int>> {
  Day11({@required this.inputPath});

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
    var automata = List<String>.from(lines);
    var next = List<String>.from(lines);

    var hasChanged = true;

    while (hasChanged) {
      hasChanged = false;

      for (var i = 0; i < lines.length; i++) {
        for (var j = 0; j < lines[i].length; j++) {
          if (_nextCellState(automata, next, i, j)) {
            hasChanged = true;
          }
        }
      }

      automata = next;
      next = List<String>.from(automata);
    }

    return automata.fold(
      0,
      (previousValue, element) =>
          previousValue + element.replaceAll(RegExp(r'\.|L'), '').length,
    );
  }

  int _secondPart(List<String> lines) {
    var automata = List<String>.from(lines);
    var next = List<String>.from(lines);

    var hasChanged = true;

    while (hasChanged) {
      hasChanged = false;

      for (var i = 0; i < lines.length; i++) {
        for (var j = 0; j < lines[i].length; j++) {
          if (_secondNextCellState(automata, next, i, j)) {
            hasChanged = true;
          }
        }
      }

      automata = next;
      next = List<String>.from(automata);
    }

    return automata.fold(
      0,
      (previousValue, element) =>
          previousValue + element.replaceAll(RegExp(r'\.|L'), '').length,
    );
  }

  bool _nextCellState(
    List<String> currentAutomata,
    List<String> nextAutomata,
    int i,
    int j,
  ) {
    var hasChanged = false;
    if (currentAutomata[i][j] != '.') {
      final isEmpty = currentAutomata[i][j] == 'L';
      var adjOccupied = 0;

      for (var y = i - 1; y < i + 2; y++) {
        if (y < 0 || y >= currentAutomata.length) continue;
        for (var x = j - 1; x < j + 2; x++) {
          if (x < 0 || x >= currentAutomata[0].length || (x == j && y == i)) {
            continue;
          }
          adjOccupied += currentAutomata[y][x] == '#' ? 1 : 0;
        }
      }

      hasChanged = true;

      if (isEmpty && adjOccupied == 0) {
        nextAutomata[i] = nextAutomata[i].replaceRange(j, j + 1, '#');
      } else if (!isEmpty && adjOccupied >= 4) {
        nextAutomata[i] = nextAutomata[i].replaceRange(j, j + 1, 'L');
      } else {
        hasChanged = false;
      }
    }

    return hasChanged;
  }

  bool _secondNextCellState(
    List<String> currentAutomata,
    List<String> nextAutomata,
    int i,
    int j,
  ) {
    var hasChanged = false;
    if (currentAutomata[i][j] != '.') {
      final isEmpty = currentAutomata[i][j] == 'L';
      var occupied = 0;

      final cLen = currentAutomata.length;
      final rLen = currentAutomata[0].length;

      for (var y = i + 1; y < cLen; y++) {
        if (currentAutomata[y][j] != '.') {
          occupied += currentAutomata[y][j] == '#' ? 1 : 0;
          break;
        }
      }
      for (var y = i - 1; y >= 0; y--) {
        if (currentAutomata[y][j] != '.') {
          occupied += currentAutomata[y][j] == '#' ? 1 : 0;
          break;
        }
      }

      for (var x = j + 1; x < rLen; x++) {
        if (currentAutomata[i][x] != '.') {
          occupied += currentAutomata[i][x] == '#' ? 1 : 0;
          break;
        }
      }
      for (var x = j - 1; x >= 0; x--) {
        if (currentAutomata[i][x] != '.') {
          occupied += currentAutomata[i][x] == '#' ? 1 : 0;
          break;
        }
      }

      for (var y = i + 1, x = j + 1; y < cLen && x < rLen; y++, x++) {
        if (currentAutomata[y][x] != '.') {
          occupied += currentAutomata[y][x] == '#' ? 1 : 0;
          break;
        }
      }
      for (var y = i - 1, x = j - 1; y >= 0 && x >= 0; y--, x--) {
        if (currentAutomata[y][x] != '.') {
          occupied += currentAutomata[y][x] == '#' ? 1 : 0;
          break;
        }
      }

      for (var y = i + 1, x = j - 1; y < cLen && x >= 0; y++, x--) {
        if (currentAutomata[y][x] != '.') {
          occupied += currentAutomata[y][x] == '#' ? 1 : 0;
          break;
        }
      }
      for (var y = i - 1, x = j + 1; y >= 0 && x < rLen; y--, x++) {
        if (currentAutomata[y][x] != '.') {
          occupied += currentAutomata[y][x] == '#' ? 1 : 0;
          break;
        }
      }

      hasChanged = true;

      if (isEmpty && occupied == 0) {
        nextAutomata[i] = nextAutomata[i].replaceRange(j, j + 1, '#');
      } else if (!isEmpty && occupied >= 5) {
        nextAutomata[i] = nextAutomata[i].replaceRange(j, j + 1, 'L');
      } else {
        hasChanged = false;
      }
    }

    return hasChanged;
  }
}
