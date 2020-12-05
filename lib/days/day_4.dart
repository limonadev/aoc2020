import 'dart:io';

import 'package:aoc2020/days/day.dart';
import 'package:meta/meta.dart';

class Day4 extends Day<Map<String, int>> {
  Day4({@required this.inputPath});

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
    final fields = {
      'byr': 1,
      'iyr': 2,
      'eyr': 4,
      'hgt': 8,
      'hcl': 16,
      'ecl': 32,
      'pid': 64,
      'cid': 128,
    };

    var mark = 0;
    var result = 0;

    for (final line in lines) {
      if (line.isEmpty) {
        result = mark == 255 || mark == 127 ? result + 1 : result;
        mark = 0;
        continue;
      }

      final splitted = line.split(' ');
      for (final prop in splitted) {
        final field = prop.split(':')[0];
        mark |= fields[field];
      }
    }

    result = mark == 255 || mark == 127 ? result + 1 : result;

    return result;
  }

  int _secondPart(List<String> lines) {
    final fields = {
      'byr': [1, (val) => _validBirth(val)],
      'iyr': [2, (val) => _validIssue(val)],
      'eyr': [4, (val) => _validExpiration(val)],
      'hgt': [8, (val) => _validHeight(val)],
      'hcl': [16, (val) => _validHair(val)],
      'ecl': [32, (val) => _validEye(val)],
      'pid': [64, (val) => _validPassport(val)],
      'cid': [128, (val) => _validCountry(val)],
    };

    var mark = 0;
    var result = 0;

    for (final line in lines) {
      if (line.isEmpty) {
        result = mark == 255 || mark == 127 ? result + 1 : result;
        mark = 0;
        continue;
      }

      final splitted = line.split(' ');
      for (final prop in splitted) {
        final props = prop.split(':');
        final field = props[0];
        final value = props[1];
        if ((fields[field][1] as Function)(value)) {
          mark |= fields[field][0];
        }
      }
    }

    result = mark == 255 || mark == 127 ? result + 1 : result;

    return result;
  }

  bool _validBirth(String birth) {
    final b = int.parse(birth);
    return b >= 1920 && b <= 2002;
  }

  bool _validIssue(String issue) {
    final i = int.parse(issue);
    return i >= 2010 && i <= 2020;
  }

  bool _validExpiration(String expiration) {
    final e = int.parse(expiration);
    return e >= 2020 && e <= 2030;
  }

  bool _validHeight(String height) {
    var result = false;
    if (height.contains('cm')) {
      var h = int.parse(height.substring(0, height.length - 2));
      result = h >= 150 && h <= 193;
    } else if (height.contains('in')) {
      var h = int.parse(height.substring(0, height.length - 2));
      result = h >= 59 && h <= 76;
    }
    return result;
  }

  bool _validHair(String hair) {
    return hair.length == 7 &&
        hair[0] == '#' &&
        hair.replaceAll(RegExp(r'[a-f]|[0-9]'), '') == '#';
  }

  bool _validEye(String eye) {
    return ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'].contains(eye);
  }

  bool _validPassport(String passport) {
    return passport.length == 9 &&
        passport.replaceAll(RegExp(r'[0-9]'), '').isEmpty;
  }

  bool _validCountry(String country) {
    return true;
  }
}
