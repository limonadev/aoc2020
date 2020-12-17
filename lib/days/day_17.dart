import 'dart:io';

import 'package:aoc2020/days/day.dart';
import 'package:meta/meta.dart';

class NPoint {
  NPoint({@required List<int> coords}) : coords = List.from(coords);

  final List<int> coords;

  @override
  int get hashCode {
    var result = 17;

    coords.forEach((coord) {
      var objectHash = coord;
      result = 31 * result + objectHash;
    });

    return result;
  }

  @override
  bool operator ==(Object other) {
    var result = true;
    if (other is NPoint && coords.length == other.coords.length) {
      for (var i = 0; i < coords.length; i++) {
        if (coords[i] != other.coords[i]) {
          result = false;
          break;
        }
      }
    } else {
      result = false;
    }
    return result;
  }

  @override
  String toString() {
    return '$coords';
  }
}

class Day17 extends Day<Map<String, int>> {
  Day17({@required this.inputPath});

  final String inputPath;

  final fieldPattern = RegExp(
    r'([a-z ]+)\: ([0-9]+-[0-9]+) or ([0-9]+-[0-9]+)',
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
    var grid = <List<List<int>>>[];

    for (final line in lines) {
      final row = <List<int>>[];

      for (var i = 0; i < line.length; i++) {
        row.add([line[i] == '#' ? 1 : 0]);
      }

      grid.add(row);
    }

    for (var counter = 0; counter < 6; counter++) {
      _addLayer(grid);
      var copy = _copyGrid(grid);

      for (var i = 0; i < grid.length; i++) {
        for (var j = 0; j < grid[i].length; j++) {
          for (var k = 0; k < grid[i][j].length; k++) {
            final active = _countActiveNeighbor(grid, i, j, k);
            if (grid[i][j][k] == 0 && active == 3) {
              copy[i][j][k] = 1;
            } else if (grid[i][j][k] == 1 && active != 2 && active != 3) {
              copy[i][j][k] = 0;
            }
          }
        }
      }

      grid = copy;
    }

    return _totalActive(grid);
  }

  int _secondPart(List<String> lines) {
    var activePoints = <NPoint>{};

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      for (var j = 0; j < line.length; j++) {
        if (line[j] == '#') {
          activePoints.add(NPoint(coords: [i, j, 0, 0]));
        }
      }
    }

    for (var i = 0; i < 6; i++) {
      final candidates = <NPoint, int>{};
      final nextActivePoints = <NPoint>{};

      for (final point in activePoints) {
        final activeNeighbors = _countActive4DNeighbor(
          point,
          activePoints,
          candidates,
        );

        if (activeNeighbors == 2 || activeNeighbors == 3) {
          nextActivePoints.add(point);
        }
      }

      for (final entry in candidates.entries) {
        if (entry.value == 3) {
          nextActivePoints.add(entry.key);
        }
      }

      activePoints = nextActivePoints;
    }

    return activePoints.length;
  }

  void _addLayer(List<List<List<int>>> grid) {
    for (var i = 0; i < grid.length; i++) {
      for (var j = 0; j < grid[i].length; j++) {
        grid[i][j].insert(0, 0);
        grid[i][j].add(0);
      }
    }

    final elemToAdd = List.filled(grid[0][0].length, 0, growable: true);
    for (var i = 0; i < grid.length; i++) {
      grid[i].insert(0, List.from(elemToAdd));
      grid[i].add(List.from(elemToAdd));
    }

    final rowToAdd = <List<int>>[];
    for (var i = 0; i < grid[0].length; i++) {
      rowToAdd.add(List.from(elemToAdd));
    }

    grid.insert(0, List.from(rowToAdd));
    grid.add(List.from(rowToAdd));
  }

  int _countActiveNeighbor(List<List<List<int>>> grid, int i, int j, int k) {
    var count = 0;

    for (var mi = i - 1; mi <= i + 1; mi++) {
      if (mi < 0 || mi >= grid.length) continue;
      for (var mj = j - 1; mj <= j + 1; mj++) {
        if (mj < 0 || mj >= grid[mi].length) continue;
        for (var mk = k - 1; mk <= k + 1; mk++) {
          if (mk < 0 || mk >= grid[mi][mj].length) continue;
          if (i == mi && j == mj && k == mk) continue;

          count += grid[mi][mj][mk];
        }
      }
    }

    return count;
  }

  List<List<List<int>>> _copyGrid(List<List<List<int>>> grid) {
    final result = <List<List<int>>>[];

    for (final row in grid) {
      final r = <List<int>>[];
      for (final col in row) {
        r.add(List.from(col));
      }
      result.add(r);
    }

    return result;
  }

  int _totalActive(List<List<List<int>>> grid) {
    var total = 0;

    for (var i = 0; i < grid.length; i++) {
      for (var j = 0; j < grid[i].length; j++) {
        for (var k = 0; k < grid[i][j].length; k++) {
          total += grid[i][j][k];
        }
      }
    }

    return total;
  }

  int _countActive4DNeighbor(
    NPoint p,
    Set<NPoint> activePoints,
    Map<NPoint, int> candidates,
  ) {
    var total = 0;

    for (var i = p.coords[0] - 1; i <= p.coords[0] + 1; i++) {
      for (var j = p.coords[1] - 1; j <= p.coords[1] + 1; j++) {
        for (var k = p.coords[2] - 1; k <= p.coords[2] + 1; k++) {
          for (var l = p.coords[3] - 1; l <= p.coords[3] + 1; l++) {
            final neighbor = NPoint(coords: [i, j, k, l]);
            if (neighbor == p) continue;

            if (activePoints.contains(neighbor)) {
              total++;
            } else {
              candidates.putIfAbsent(neighbor, () => 0);
              candidates[neighbor]++;
            }
          }
        }
      }
    }

    return total;
  }
}
