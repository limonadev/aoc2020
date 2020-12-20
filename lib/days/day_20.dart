import 'dart:io';

import 'package:aoc2020/days/day.dart';
import 'package:meta/meta.dart';

enum Edge {
  Top,
  Right,
  Bottom,
  Left,
}

class Day20 extends Day<Map<String, int>> {
  Day20({@required this.inputPath});

  final String inputPath;
  final RegExp mainMonsterPattern = RegExp(
    r'#(\.|\#){4}##(\.|\#){4}##(\.|\#){4}###',
  );
  final RegExp topMonsterPattern = RegExp(
    r'(\.|\#){18}#(\.|\#){1}',
  );
  final RegExp bottomMonsterPattern = RegExp(
    r'(\.|\#){1}#(\.|\#){2}#(\.|\#){2}#(\.|\#){2}#(\.|\#){2}#(\.|\#){2}#(\.|\#){3}',
  );

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
    final tiles = <int, List<String>>{};

    final edges = <String, List<int>>{};

    final it = lines.iterator;
    while (it.moveNext()) {
      final id = int.parse(
        it.current.split(' ')[1].replaceAll(':', ''),
      );

      final tile = <String>[];

      var leftEdge = '';
      var rightEdge = '';
      while (it.moveNext() && it.current.isNotEmpty) {
        tile.add(it.current);

        leftEdge += it.current[0];
        rightEdge += it.current[it.current.length - 1];
      }

      final topEdge = tile.first;
      final bottomEdge = tile.last;

      final currEdges = [leftEdge, rightEdge, topEdge, bottomEdge].expand(
        (e) => [e, e.split('').reversed.join()],
      );

      for (final edge in currEdges) {
        edges.putIfAbsent(edge, () => []).add(id);
      }

      tiles[id] = tile;
    }

    final counter = <int, int>{};

    for (var val in edges.values) {
      if (val.length == 2) {
        for (var i in val) {
          counter.putIfAbsent(i, () => 0);
          counter[i]++;
        }
      }
    }

    var result = 1;
    for (var entry in counter.entries) {
      if (entry.value == 4) result *= entry.key;
    }

    return result;
  }

  int _secondPart(List<String> lines) {
    final tiles = <int, List<String>>{};

    final edges = <String, List<int>>{};
    final frontiers = <int, Map<int, Set<String>>>{};

    final it = lines.iterator;
    while (it.moveNext()) {
      final id = int.parse(
        it.current.split(' ')[1].replaceAll(':', ''),
      );

      final tile = <String>[];

      var leftEdge = '';
      var rightEdge = '';
      while (it.moveNext() && it.current.isNotEmpty) {
        tile.add(it.current);

        leftEdge += it.current[0];
        rightEdge += it.current[it.current.length - 1];
      }

      final topEdge = tile.first;
      final bottomEdge = tile.last;

      final currEdges = [leftEdge, rightEdge, topEdge, bottomEdge].expand(
        (e) => [e, e.split('').reversed.join()],
      );

      for (final edge in currEdges) {
        edges.putIfAbsent(edge, () => []).add(id);
      }

      tiles[id] = tile;
    }

    for (var entry in edges.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value.length == 2) {
        frontiers.putIfAbsent(value[0], () => {});
        frontiers.putIfAbsent(value[1], () => {});

        frontiers[value[0]].putIfAbsent(value[1], () => {});
        frontiers[value[1]].putIfAbsent(value[0], () => {});

        frontiers[value[0]][value[1]].add(key);
        frontiers[value[1]][value[0]].add(key);
      }
    }

    /*for (var e in frontiers.entries) {
      print('${e.key}  ${e.value}');
    }
    print('\n\n\n');

    for (var e in [1823, 3391, 1327, 3571]) {
      print(e);
      for (var lol in tiles[e]) {
        print(lol);
      }
      print('\n\n');
    }*/

    final sortedIds = <List<int>>[];

    final firstCornerId = _getCorner(frontiers);
    final bottomNeighborId = frontiers[firstCornerId].keys.elementAt(1);
    final rightNeighborId = frontiers[firstCornerId].keys.elementAt(0);

    var firstCorner = _fitTile(
      tiles[firstCornerId],
      frontiers[firstCornerId][bottomNeighborId].first,
      Edge.Bottom,
    );
    final rightBorder = _getBorder(firstCorner, Edge.Right);
    if (!frontiers[rightNeighborId][firstCornerId].contains(rightBorder)) {
      firstCorner = _flipTile(firstCorner, true);
    }

    tiles[firstCornerId] = firstCorner;
    sortedIds.add([firstCornerId]);

    var lastId = firstCornerId;
    var last = tiles[lastId];

    while (lastId != null) {
      final neighbors = frontiers[lastId];
      final pattern = _getBorder(last, Edge.Bottom);

      lastId = null;

      for (final n in neighbors.keys) {
        final fitted = _fitTile(tiles[n], pattern, Edge.Top);
        if (fitted != null) {
          tiles[n] = fitted;
          sortedIds.add([n]);

          lastId = n;
          last = tiles[lastId];
          break;
        }
      }
    }

    for (final row in sortedIds) {
      lastId = row[0];
      last = tiles[lastId];

      while (lastId != null) {
        final neighbors = frontiers[lastId];
        final pattern = _getBorder(last, Edge.Right);

        lastId = null;

        for (final n in neighbors.keys) {
          final fitted = _fitTile(tiles[n], pattern, Edge.Left);
          if (fitted != null) {
            tiles[n] = fitted;
            row.add(n);

            lastId = n;
            last = tiles[lastId];
            break;
          }
        }
      }
    }

    final bigTile = <String>[];

    for (final row in sortedIds) {
      final subRow = <String>[];
      for (final col in row) {
        final tile = _removeBorders(tiles[col]);

        for (var i = 0; i < tile.length; i++) {
          if (subRow.length == i) {
            subRow.add('');
          }
          subRow[i] += tile[i];
        }
      }

      bigTile.addAll(subRow);
    }

    var raw = 0;
    for (var lol in bigTile) {
      raw += lol.replaceAll('.', '').length;
    }

    var rotatedBigTile = bigTile;
    int total;
    for (var i = 0; i < 4; i++) {
      total = _searchMonsters(rotatedBigTile, raw);
      if (total != 0) break;
      total = _searchMonsters(_flipTile(rotatedBigTile, true), raw);
      if (total != 0) break;
      total = _searchMonsters(_flipTile(rotatedBigTile, false), raw);
      if (total != 0) break;
      rotatedBigTile = _rotateTile(rotatedBigTile);
    }

    return total;
  }

  int _getCorner(Map<int, Map<int, Set<String>>> frontiers) {
    int result;
    for (final entry in frontiers.entries) {
      if (entry.value.length == 2) {
        result = entry.key;
        break;
      }
    }

    return result;
  }

  List<String> _fitTile(
    List<String> tile,
    String pattern,
    Edge desired,
  ) {
    var rotated = tile;

    for (var i = 0; i < 4; i++) {
      final border = _getBorder(rotated, desired);

      if (border == pattern) {
        return rotated;
      } else if (reversed(border) == pattern) {
        return _flipTile(
          rotated,
          desired == Edge.Top || desired == Edge.Bottom,
        );
      }

      rotated = _rotateTile(rotated);
    }

    return null;
  }

  String _getBorder(List<String> tile, Edge edge) {
    switch (edge) {
      case Edge.Top:
        return tile.first;
      case Edge.Bottom:
        return tile.last;
      case Edge.Left:
        var result = '';
        for (final row in tile) {
          result += row[0];
        }
        return result;
      case Edge.Right:
        var result = '';
        for (final row in tile) {
          result += row[row.length - 1];
        }
        return result;
      default:
        throw ArgumentError('Invalid Edge [edge] wass passed');
    }
  }

  List<String> _rotateTile(List<String> tile) {
    final result = <String>[];
    for (var col = 0; col < tile.length; col++) {
      var line = '';
      for (var row = 0; row < tile.length; row++) {
        line = '${tile[row][col]}$line';
      }
      result.add(line);
    }

    return result;
  }

  List<String> _flipTile(List<String> tile, bool horizontal) {
    final result = <String>[];
    if (horizontal) {
      for (final row in tile) {
        result.add(reversed(row));
      }
    } else {
      for (var i = tile.length - 1; i >= 0; i--) {
        result.add(tile[i]);
      }
    }

    return result;
  }

  String reversed(String s) {
    return s.split('').reversed.join();
  }

  List<String> _removeBorders(List<String> tile) {
    final result = <String>[];

    for (var i = 1; i < tile.length - 1; i++) {
      result.add(tile[i].substring(1, tile[i].length - 1));
    }

    return result;
  }

  int _searchMonsters(List<String> tile, int raw) {
    var monsterFound = false;
    var monsters = 0;

    for (var i = 1; i < tile.length - 1; i++) {
      final found = mainMonsterPattern.allMatches(tile[i]).toList();

      for (final match in found) {
        final start = match.start;
        final topFound =
            topMonsterPattern.allMatches(tile[i - 1], start).isNotEmpty;
        final bottomFound =
            bottomMonsterPattern.allMatches(tile[i + 1], start).isNotEmpty;

        if (topFound && bottomFound) {
          monsters++;
          monsterFound = true;
        }
      }
    }

    var total = 0;
    if (monsterFound) {
      total = raw - monsters * 15;
    }

    return total;
  }
}
