import 'dart:collection';
import 'dart:io';

import 'package:aoc2020/days/day.dart';
import 'package:meta/meta.dart';

class Day07 extends Day<Map<String, int>> {
  Day07({@required this.inputPath});

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
    var result = 0;
    final allBags = <String, Bag>{};

    for (final line in lines) {
      final bagColor = _getMainBagColor(line);
      final bag = allBags.putIfAbsent(
        bagColor,
        () => Bag(color: bagColor),
      );

      final contain = _getContainedBagColors(line);

      for (var contained in contain) {
        final containedColor = contained[0];
        final containedBag = allBags.putIfAbsent(
          containedColor,
          () => Bag(color: containedColor),
        );

        containedBag.addContainer(bag);
      }
    }

    final look = ListQueue<Bag>.from([allBags['shinygold']]);
    final visited = <String>{};
    while (look.isNotEmpty) {
      final curr = look.removeLast();
      visited.add(curr.color);

      look.addAll(
        curr.containedIn.values.where(
          (bagColor) => !visited.contains(bagColor),
        ),
      );
    }

    result = visited.length - 1;

    return result;
  }

  int _secondPart(List<String> lines) {
    var result = 0;
    final allBags = <String, Bag>{};

    for (final line in lines) {
      final bagColor = _getMainBagColor(line);
      final bag = allBags.putIfAbsent(
        bagColor,
        () => Bag(color: bagColor),
      );

      final contain = _getContainedBagColors(line);

      for (var contained in contain) {
        final containedColor = contained[0];
        final containedAmount = contained[1];
        final containedBag = allBags.putIfAbsent(
          containedColor,
          () => Bag(color: containedColor),
        );

        bag.addSmaller(containedBag, containedAmount);
      }
    }

    final mem = <String, int>{};
    for (var key in allBags.keys) {
      mem[key] = null;
    }

    result = _amountOfBags('shinygold', allBags, mem) - 1;

    return result;
  }

  String _getMainBagColor(String line) {
    return line.split('contain')[0].split(' bags')[0].replaceAll(
          ' ',
          '',
        );
  }

  List<List> _getContainedBagColors(String line) {
    return line
        .split('contain')[1]
        .split(RegExp(r'bag\.|bag,|bags.'))
        .where((line) => line != ' no other ' && line != '')
        .map(
      (otherBag) {
        final parsed = otherBag.trim().split(' ');

        if (parsed[0] != '' && !parsed.contains('other')) {
          final amount = int.parse(parsed[0]);
          final name = parsed.sublist(1).join();
          return [name, amount];
        }
      },
    ).toList();
  }

  int _amountOfBags(
    String color,
    Map<String, Bag> allBags,
    Map<String, int> mem,
  ) {
    var result = mem[color];
    if (result == null) {
      final bag = allBags[color];
      var sum = 0;
      for (var contained in bag.contains.values) {
        final containedBag = contained[0];
        final containedAmout = contained[1];

        sum += containedAmout * _amountOfBags(containedBag.color, allBags, mem);
      }
      result = sum + 1;
      mem[color] = result;
    }

    return result;
  }
}

class Bag {
  Bag({@required this.color})
      : containedIn = {},
        contains = {};

  final String color;
  final Map<String, Bag> containedIn;
  final Map<String, List> contains;

  void addContainer(Bag bag) {
    containedIn[bag.color] = bag;
  }

  void addSmaller(Bag bag, int amount) {
    contains[bag.color] = [bag, amount];
  }
}
