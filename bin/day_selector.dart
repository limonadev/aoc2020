import 'package:meta/meta.dart';
import 'package:aoc2020/days/all.dart';

enum DayOption {
  Day01,
  Day02,
  Day03,
  Day04,
}

class DaySelector {
  static Day choose({@required DayOption selection}) {
    Day result;
    switch (selection) {
      case DayOption.Day01:
        result = Day1(inputPath: 'assets/day_1.txt');
        break;
      case DayOption.Day02:
        result = Day2(inputPath: 'assets/day_2.txt');
        break;
      case DayOption.Day03:
        result = Day3(inputPath: 'assets/day_3.txt');
        break;
      case DayOption.Day04:
        result = Day4(inputPath: 'assets/day_4.txt');
        break;
      default:
        throw ArgumentError('$selection is not part of the options');
    }

    return result;
  }
}
