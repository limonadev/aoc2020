import 'dart:io';

import 'package:aoc2020/days/day.dart';
import 'package:meta/meta.dart';

class Day14 extends Day<Map<String, int>> {
  Day14({@required this.inputPath});

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
    final memory = List.filled(1000000, 0);
    var mask = <int, int>{};

    for (final line in lines) {
      if (line.contains('mask')) {
        mask.clear();

        final update = line.split('mask = ')[1];
        for (var i = 0; i < update.length; i++) {
          if (update[i] != 'X') mask[i] = int.parse(update[i]);
        }
      } else {
        final splitted = line.split(' = ');
        final memPos = int.parse(
          splitted[0].substring(
            4,
            splitted[0].length - 1,
          ),
        );
        var val = int.parse(splitted[1]).toUnsigned(36);
        var maskedVal = 0.toUnsigned(1);

        for (var i = 0; i < 36; i++) {
          maskedVal <<= 1;
          if (mask.containsKey(i)) {
            maskedVal += mask[i];
          } else {
            final bitMask = 1 << (35 - i);
            final bit = (val & bitMask) >> (35 - i);
            maskedVal += bit;
          }
        }

        memory[memPos] = maskedVal;
      }
    }

    return memory.reduce((a, b) => a + b);
  }

  int _secondPart(List<String> lines) {
    //final memory = List.filled(double.maxFinite.toInt().toUnsigned(36), 0);

    final memory = <int, int>{};
    var mask = List.filled(36, 0);

    for (final line in lines) {
      if (line.contains('mask')) {
        final update = line.split('mask = ')[1];
        for (var i = 0; i < update.length; i++) {
          mask[i] = update[i] == 'X' ? -1 : int.parse(update[i]);
        }
      } else {
        final splitted = line.split(' = ');
        final memPos = int.parse(
          splitted[0].substring(
            4,
            splitted[0].length - 1,
          ),
        ).toUnsigned(36);
        var val = int.parse(splitted[1]).toUnsigned(36);

        final memPositions = _maskMemory(memPos, 0, mask);

        memPositions.forEach(
          (pos) => memory[pos] = val,
        );

        /*var maskedVal = 0.toUnsigned(1);

        for (var i = 0; i < 36; i++) {
          maskedVal <<= 1;
          if (mask.containsKey(i)) {
            maskedVal += mask[i];
          } else {
            final bitMask = 1 << (35 - i);
            final bit = (val & bitMask) >> (35 - i);
            maskedVal += bit;
          }
        }

        memory[memPos] = maskedVal;*/
      }
    }

    return memory.values.reduce((a, b) => a + b);
  }

  List<int> _maskMemory(int address, int bitIndex, List<int> mask) {
    if (bitIndex == 36) return [address];

    if (mask[bitIndex] == 0) {
      return [..._maskMemory(address, bitIndex + 1, mask)];
    } else if (mask[bitIndex] == 1) {
      final bitMask = (1 << (35 - bitIndex)).toUnsigned(36);
      return [..._maskMemory(address | bitMask, bitIndex + 1, mask)];
    }

    final orBitMask = (1 << (35 - bitIndex)).toUnsigned(36);
    final andBitMask = (~orBitMask).toUnsigned(36);

    return [
      ..._maskMemory(address | orBitMask, bitIndex + 1, mask),
      ..._maskMemory(address & andBitMask, bitIndex + 1, mask),
    ];
  }
}
