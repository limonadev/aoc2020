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
    var activePoints = <NPoint>{};

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      for (var j = 0; j < line.length; j++) {
        if (line[j] == '#') {
          activePoints.add(NPoint(coords: [i, j, 0]));
        }
      }
    }

    for (var i = 0; i < 6; i++) {
      final candidates = <NPoint, int>{};
      final nextActivePoints = <NPoint>{};

      for (final point in activePoints) {
        final activeNeighbors = _countActive3DNeighbor(
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

  int _countActive3DNeighbor(
    NPoint p,
    Set<NPoint> activePoints,
    Map<NPoint, int> candidates,
  ) {
    var total = 0;

    for (var i = p.coords[0] - 1; i <= p.coords[0] + 1; i++) {
      for (var j = p.coords[1] - 1; j <= p.coords[1] + 1; j++) {
        for (var k = p.coords[2] - 1; k <= p.coords[2] + 1; k++) {
          final neighbor = NPoint(coords: [i, j, k]);
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

    return total;
  }
}
