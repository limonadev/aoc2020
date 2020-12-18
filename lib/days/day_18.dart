import 'dart:collection';
import 'dart:io';

import 'package:aoc2020/days/day.dart';
import 'package:meta/meta.dart';

class Day18 extends Day<Map<String, int>> {
  Day18({@required this.inputPath});

  final String inputPath;

  final numberPattern = RegExp(r'[0-9]');
  final operations = {
    '+': (a, b) => a + b,
    '*': (a, b) => a * b,
  };

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
    var total = 0;

    for (final line in lines) {
      final stackQueue = ListQueue<Object>();

      final trimmed = line.split(' ').join();

      var operand = '';
      for (var i = 0; i < trimmed.length; i++) {
        final curr = trimmed[i];

        if (numberPattern.hasMatch(curr)) {
          operand += curr;
        } else {
          if (operand.isNotEmpty) {
            stackQueue.add(int.parse(operand));
            operand = '';
          }

          if (curr == ')') {
            final expression = <Object>[];
            while (stackQueue.last != '(') {
              expression.insert(0, stackQueue.removeLast());
            }
            stackQueue.removeLast();

            var result = expression.removeAt(0);
            for (var i = 0; i < expression.length; i++) {
              final op = expression[i];
              final operand = expression[++i];

              result = operations[op](result, operand);
            }

            stackQueue.add(result);
          } else {
            stackQueue.add(curr);
          }
        }
      }

      if (operand.isNotEmpty) {
        stackQueue.add(int.parse(operand));
        operand = '';
      }

      var result = stackQueue.removeFirst();
      while (stackQueue.isNotEmpty) {
        final op = stackQueue.removeFirst();
        final operand = stackQueue.removeFirst();

        result = operations[op](result, operand);
      }

      total += result;
    }

    return total;
  }

  int _secondPart(List<String> lines) {
    var total = 0;

    for (final line in lines) {
      final stackQueue = ListQueue<Object>();

      final trimmed = line.split(' ').join();

      var operand = '';
      for (var i = 0; i < trimmed.length; i++) {
        final curr = trimmed[i];

        if (numberPattern.hasMatch(curr)) {
          operand += curr;
        } else {
          if (operand.isNotEmpty) {
            stackQueue.add(int.parse(operand));
            operand = '';
          }

          if (curr == ')') {
            final expression = <Object>[];
            while (stackQueue.last != '(') {
              final op = stackQueue.removeLast();
              if (op == '+') {
                final op1 = expression[0];
                final op2 = stackQueue.removeLast();
                expression[0] = operations['+'](op1, op2);
              } else {
                expression.insert(0, op);
              }
            }
            stackQueue.removeLast();

            var result = expression.removeAt(0);
            for (var i = 0; i < expression.length; i++) {
              final op = expression[i];
              final operand = expression[++i];

              result = operations[op](result, operand);
            }

            stackQueue.add(result);
          } else {
            stackQueue.add(curr);
          }
        }
      }

      if (operand.isNotEmpty) {
        stackQueue.add(int.parse(operand));
        operand = '';
      }

      final otherExp = <Object>[];

      otherExp.add(stackQueue.removeFirst());
      while (stackQueue.isNotEmpty) {
        final op = stackQueue.removeFirst();
        if (op == '+') {
          final op1 = otherExp[0];
          final op2 = stackQueue.removeFirst();
          otherExp[0] = operations['+'](op1, op2);
        } else {
          otherExp.insert(0, op);
        }
      }

      var result = otherExp.removeAt(0);
      for (var i = 0; i < otherExp.length; i++) {
        final op = otherExp[i];
        final operand = otherExp[++i];

        result = operations[op](result, operand);
      }

      total += result;
    }

    return total;
  }
}
