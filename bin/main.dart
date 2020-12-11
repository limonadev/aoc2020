import 'day_selector.dart';

void main() async {
  final selected = DaySelector.choose(selection: DayOption.Day11);
  final result = await selected.solve();

  print(result);
}
