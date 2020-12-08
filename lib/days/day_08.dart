import 'dart:collection';
import 'dart:io';

import 'package:aoc2020/days/day.dart';
import 'package:meta/meta.dart';

class Day08 extends Day<Map<String, int>> {
  Day08({@required this.inputPath});

  final String inputPath;

  final RegExp _inst = RegExp(r'((acc|jmp|nop) ((\+|\-)[0-9]+))');
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
    var acc = 0;
    final mem = List.filled(lines.length, 0);
    final instructions = <List>[];

    for (final line in lines) {
      final match = _inst.firstMatch(line);
      final op = match.group(2);
      final number = int.parse(match.group(3));

      instructions.add([op, number]);
    }

    var index = 0;
    while (mem[index] == 0) {
      mem[index]++;
      final ins = instructions[index];

      if (ins[0] == 'acc') {
        acc += ins[1];
      } else if (ins[0] == 'jmp') {
        index += ins[1] - 1;
      }

      index++;
    }

    return acc;
  }

  int _secondPart(List<String> lines) {
    int acc;
    final instructions = <List>[];

    for (final line in lines) {
      final match = _inst.firstMatch(line);
      final op = match.group(2);
      final number = int.parse(match.group(3));

      instructions.add([op, number]);
    }

    for (final ins in instructions) {
      if (ins[0] == 'jmp') {
        ins[0] = 'nop';
        acc = _try(instructions);
        ins[0] = 'jmp';
      } else if (ins[0] == 'nop') {
        ins[0] = 'jmp';
        acc = _try(instructions);
        ins[0] = 'nop';
      }

      if (acc != null) {
        return acc;
      }
    }

    return acc;
  }

  int _try(List<List> instructions) {
    var acc = 0;
    final mem = List.filled(instructions.length, 0);

    var index = 0;
    while (index != null && index < mem.length) {
      mem[index]++;
      final ins = instructions[index];

      if (ins[0] == 'acc') {
        acc += ins[1];
      } else if (ins[0] == 'jmp') {
        index += ins[1] - 1;
      }

      index++;
      if (index < mem.length && mem[index] != 0) {
        index = null;
      }
    }

    return index == null ? index : acc;
  }
}
