import 'package:meta/meta.dart';
import 'package:aoc2020/days/all.dart';

enum DayOption { Day01 }

class DaySelector {
  static Day choose({@required DayOption selection}) {
    Day result;
    switch (selection) {
      case DayOption.Day01:
        result = FirstDay(inputPath: 'assets/first_day.txt');
        break;
      default:
        throw ArgumentError('$selection is not part of the options');
    }

    return result;
  }
}
