import 'package:meta/meta.dart';
import 'package:aoc2020/days/all.dart';

enum DayOption {
  Day01,
  Day02,
  Day03,
  Day04,
  Day05,
  Day06,
  Day07,
  Day08,
  Day09,
  Day10,
  Day11,
  Day12,
  Day13,
  Day14,
  Day15,
  Day16,
  Day17,
  Day18,
  Day19,
  Day20,
}

class DaySelector {
  static Day choose({@required DayOption selection}) {
    Day result;
    switch (selection) {
      case DayOption.Day01:
        result = Day01(inputPath: 'assets/day_01.txt');
        break;
      case DayOption.Day02:
        result = Day02(inputPath: 'assets/day_02.txt');
        break;
      case DayOption.Day03:
        result = Day03(inputPath: 'assets/day_03.txt');
        break;
      case DayOption.Day04:
        result = Day04(inputPath: 'assets/day_04.txt');
        break;
      case DayOption.Day05:
        result = Day05(inputPath: 'assets/day_05.txt');
        break;
      case DayOption.Day06:
        result = Day06(inputPath: 'assets/day_06.txt');
        break;
      case DayOption.Day07:
        result = Day07(inputPath: 'assets/day_07.txt');
        break;
      case DayOption.Day08:
        result = Day08(inputPath: 'assets/day_08.txt');
        break;
      case DayOption.Day09:
        result = Day09(inputPath: 'assets/day_09.txt');
        break;
      case DayOption.Day10:
        result = Day10(inputPath: 'assets/day_10.txt');
        break;
      case DayOption.Day11:
        result = Day11(inputPath: 'assets/day_11.txt');
        break;
      case DayOption.Day12:
        result = Day12(inputPath: 'assets/day_12.txt');
        break;
      case DayOption.Day13:
        result = Day13(inputPath: 'assets/day_13.txt');
        break;
      case DayOption.Day14:
        result = Day14(inputPath: 'assets/day_14.txt');
        break;
      case DayOption.Day15:
        result = Day15(inputPath: 'assets/day_15.txt');
        break;
      case DayOption.Day16:
        result = Day16(inputPath: 'assets/day_16.txt');
        break;
      case DayOption.Day17:
        result = Day17(inputPath: 'assets/day_17.txt');
        break;
      case DayOption.Day18:
        result = Day18(inputPath: 'assets/day_18.txt');
        break;
      case DayOption.Day19:
        result = Day19(inputPath: 'assets/day_19.txt');
        break;
      case DayOption.Day20:
        result = Day20(inputPath: 'assets/day_20.txt');
        break;
      default:
        throw ArgumentError('$selection is not part of the options');
    }

    return result;
  }
}
