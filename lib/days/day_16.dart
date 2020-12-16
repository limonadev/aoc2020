import 'dart:io';

import 'package:aoc2020/days/day.dart';
import 'package:meta/meta.dart';

class Day16 extends Day<Map<String, int>> {
  Day16({@required this.inputPath});

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
    final fields = _parseFields(lines);

    final invalids = [];

    for (final line
        in lines.skipWhile((value) => value != 'nearby tickets:').skip(1)) {
      line
          .split(',')
          .map(
            (e) => int.parse(e),
          )
          .forEach(
        (value) {
          if (!fields.containsKey(value)) invalids.add(value);
        },
      );
    }

    return invalids.fold(0, (value, element) => value + element);
  }

  int _secondPart(List<String> lines) {
    final fields = _parseFields(lines);

    final myTicket = _parseMyTicket(lines);
    final myOptions = myTicket.map((e) => fields[e]).toList();

    for (final line
        in lines.skipWhile((value) => value != 'nearby tickets:').skip(1)) {
      final nearby = line
          .split(',')
          .map(
            (e) => int.parse(e),
          )
          .toList();

      final nearbyOptions = <Set<String>>[];
      var isValid = true;
      for (var val in nearby) {
        if (!fields.containsKey(val)) {
          isValid = false;
        } else {
          nearbyOptions.add(fields[val]);
        }
      }
      if (!isValid) continue;

      for (var i = 0; i < nearbyOptions.length; i++) {
        myOptions[i] = myOptions[i].intersection(nearbyOptions[i]);
      }
    }

    var allOne = 0;

    while (allOne != myOptions.length) {
      allOne = 0;

      final toRemove = <String>{};
      for (var opt in myOptions) {
        if (opt.length == 1) {
          toRemove.add(opt.first);
          allOne++;
        }
      }

      for (var opt in myOptions) {
        if (opt.length != 1) {
          opt.removeAll(toRemove);
        }
      }
    }

    var total = 1;
    for (var i = 0; i < myOptions.length; i++) {
      if (myOptions[i].first.contains('departure')) {
        total *= myTicket[i];
      }
    }

    return total;
  }

  Map<int, Set<String>> _parseFields(List<String> lines) {
    final rawFields = lines
        .takeWhile(
          (line) => line.isNotEmpty,
        )
        .toList();

    final fields = <int, Set<String>>{};

    for (final line in rawFields) {
      if (line.isEmpty) break;

      final match = fieldPattern.firstMatch(line);
      final field = match.group(1);
      final firstRange = match
          .group(2)
          .split('-')
          .map(
            (e) => int.parse(e),
          )
          .toList();
      final secondRange = match
          .group(3)
          .split('-')
          .map(
            (e) => int.parse(e),
          )
          .toList();

      for (var i = firstRange[0]; i <= firstRange[1]; i++) {
        fields.putIfAbsent(i, () => <String>{});
        fields[i].add(field);
      }
      for (var i = secondRange[0]; i <= secondRange[1]; i++) {
        fields.putIfAbsent(i, () => <String>{});
        fields[i].add(field);
      }
    }

    return fields;
  }

  List<int> _parseMyTicket(List<String> lines) {
    return lines
        .skipWhile(
          (value) => value != 'your ticket:',
        )
        .skip(1)
        .take(1)
        .toList()[0]
        .split(',')
        .map(
          (e) => int.parse(e),
        )
        .toList();
  }
}
