import 'dart:io';

import 'package:aoc2020/days/day.dart';
import 'package:meta/meta.dart';

/// TODO: The second part can be optimized in terms of space:
/// Instead of using String everywhere, an integer as index
/// could potentially reduce the real space required.
/// The algorithm anyways has O(nlgn) amortized time and space
/// because of sorting
class Day10 extends Day<Map<String, int>> {
  Day10({@required this.inputPath});

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
    final adapters = [0];

    for (final line in lines) {
      adapters.add(int.parse(line));
    }
    adapters.sort();
    adapters.add(adapters.last + 3);

    var oneJolt = 0;
    var threeJolt = 0;

    for (var i = 1; i < adapters.length; i++) {
      final diff = adapters[i] - adapters[i - 1];
      oneJolt += diff == 1 ? 1 : 0;
      threeJolt += diff == 3 ? 1 : 0;
    }

    return oneJolt * threeJolt;
  }

  int _secondPart(List<String> lines) {
    final adapters = [0];

    for (final line in lines) {
      adapters.add(int.parse(line));
    }
    adapters.sort();
    adapters.add(adapters.last + 3);

    var combinations = {
      '111',
      '110',
      '101',
      '011',
      '100',
      '010',
      '001',
      '000',
    };

    final initialWindow = adapters.sublist(1, 4);
    var valid = <String>{};
    combinations.forEach((bin) {
      final option = [
        adapters[0],
        if (bin[0] == '1') initialWindow[0],
        if (bin[1] == '1') initialWindow[1],
        if (bin[2] == '1') initialWindow[2],
      ];

      if (_isValid(option)) valid.add('1' + bin);
    });

    final validPerWindow = [valid];

    for (var i = 1; i < adapters.length - 4; i++) {
      final window = adapters.sublist(i, i + 4);

      valid = <String>{};
      combinations = validPerWindow[i - 1];

      combinations.forEach((bin) {
        final option = [
          if (bin[1] == '1') window[0],
          if (bin[2] == '1') window[1],
          if (bin[3] == '1') window[2],
        ];

        if (_isValid(option..add(window[3]))) {
          valid.add(bin.substring(1) + '1');
        }
        valid.add(bin.substring(1) + '0');
      });

      validPerWindow.add(valid);
    }

    final counterPerWindow = <Map<String, int>>[];

    final finalWindow = adapters.sublist(adapters.length - 4);
    valid = <String>{};
    var counter = <String, int>{};
    combinations.forEach((bin) {
      final option = [
        if (bin[1] == '1') finalWindow[0],
        if (bin[2] == '1') finalWindow[1],
        if (bin[3] == '1') finalWindow[2],
        finalWindow[3],
      ];

      if (_isValid(option)) {
        valid.add(bin.substring(1) + '1');
        counter[bin.substring(1) + '1'] = 1;
      }
    });

    validPerWindow.add(valid);
    counterPerWindow.insert(0, counter);

    for (var i = validPerWindow.length - 2; i >= 0; i--) {
      final curr = validPerWindow[i];
      final next = validPerWindow[i + 1];

      counter = {};

      curr.forEach((bin) {
        var count = 0;
        final prefix = bin.substring(1);
        if (next.contains(prefix + '0')) {
          count += counterPerWindow[0][prefix + '0'];
        }
        if (next.contains(prefix + '1')) {
          count += counterPerWindow[0][prefix + '1'];
        }

        counter[bin] = count;
      });

      counterPerWindow.insert(0, counter);
    }

    return counterPerWindow[0].values.fold(
          0,
          (previousValue, element) => previousValue + element,
        );
  }

  bool _isValid(List<int> window) {
    var valid = true;
    for (var i = 0; i < window.length - 1; i++) {
      if (window[i] < window[i + 1] - 3) {
        valid = false;
      }
    }

    if (window.length < 2) valid = false;

    return valid;
  }
}
