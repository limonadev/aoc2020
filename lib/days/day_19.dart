import 'dart:collection';
import 'dart:io';

import 'package:aoc2020/days/day.dart';
import 'package:meta/meta.dart';

class Day19 extends Day<Map<String, int>> {
  Day19({@required this.inputPath});

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
    final rules = <String, List<List<String>>>{};

    final it = lines.iterator;
    while (it.moveNext() && it.current.isNotEmpty) {
      final parsed = it.current.split(':');
      final ruleNumber = parsed[0];

      var subRules = <List<String>>[];

      if (parsed[1].contains('"')) {
        subRules = [
          [parsed[1][parsed[1].length - 2]]
        ];
      } else {
        subRules = parsed[1].split('|').map((e) {
          final r = <String>[];

          for (final s in e.split(' ')) {
            if (s.replaceAll(' ', '').isNotEmpty) {
              r.add(s);
            }
          }

          return r;
        }).toList();
      }

      rules[ruleNumber] = subRules;
    }

    final mem = <String, List<String>>{};
    final options = _allValid('0', rules, mem).toSet();

    var total = 0;
    while (it.moveNext()) {
      final message = it.current;

      if (options.contains(message)) total++;
    }

    return total;
  }

  int _secondPart(List<String> lines) {
    final rules = <String, List<List<String>>>{};

    final it = lines.iterator;
    while (it.moveNext() && it.current.isNotEmpty) {
      final parsed = it.current.split(':');
      final ruleNumber = parsed[0];

      var subRules = <List<String>>[];

      if (parsed[1].contains('"')) {
        subRules = [
          [parsed[1][parsed[1].length - 2]]
        ];
      } else {
        subRules = parsed[1].split('|').map((e) {
          final r = <String>[];

          for (final s in e.split(' ')) {
            if (s.replaceAll(' ', '').isNotEmpty) {
              r.add(s);
            }
          }

          return r;
        }).toList();
      }

      rules[ruleNumber] = subRules;
    }

    final mem = <String, List<String>>{};
    final options = _allValid('0', rules, mem).toSet();

    final opt8 = mem['8'].toSet();
    final opt11 = mem['11'].toSet();

    var total = 0;

    final l8 = opt8.first.length;

    while (it.moveNext()) {
      final message = it.current;

      if (options.contains(message)) {
        total++;
      } else {
        var n8 = 0;
        var n11 = 0;

        var on8 = true;

        final last8 = <String>[];

        for (var i = 0; i < message.length; i += l8) {
          final part = message.substring(i, i + l8);

          if (on8 && opt8.contains(part)) {
            last8.add(part);
            n8++;
          } else if (last8.isNotEmpty && opt11.contains(last8.last + part)) {
            on8 = false;
            last8.removeLast();
            n11++;
          } else {
            n8 = -1;
            break;
          }
        }

        if (n8 != -1 && n8 > n11 && n11 > 0) {
          total++;
        }
      }
    }

    return total;
  }

  List<String> _allValid(
    String startingRule,
    Map<String, List<List<String>>> rules,
    Map<String, List<String>> mem,
  ) {
    if (!rules.containsKey(startingRule)) {
      return [startingRule];
    }

    if (mem.containsKey(startingRule)) {
      return mem[startingRule];
    }

    final valid = <String>[];

    for (final subRule in rules[startingRule]) {
      var prefixes = <String>[''];
      for (final r in subRule) {
        final suffixes = _allValid(r, rules, mem);

        final temp = <String>[];
        for (final pref in prefixes) {
          for (final suf in suffixes) {
            temp.add(pref + suf);
          }
        }

        prefixes = temp;
      }

      valid.addAll(prefixes);
    }

    mem[startingRule] = valid;

    return valid;
  }
}
