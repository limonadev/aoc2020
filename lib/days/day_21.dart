import 'dart:io';

import 'package:aoc2020/days/day.dart';
import 'package:meta/meta.dart';

class Day21 extends Day<Map<String, Object>> {
  Day21({@required this.inputPath});

  final String inputPath;

  @override
  Future<Map<String, Object>> solve() async {
    final result = <String, Object>{};

    final file = File(inputPath);
    final lines = file.readAsLinesSync();

    result['first'] = _firstPart(lines);
    result['second'] = _secondPart(lines);

    return result;
  }

  int _firstPart(List<String> lines) {
    final ingredients = <String>{};
    final allergens = <String>{};
    final possibilities = <String, Set<String>>{};

    final ingLines = <String, Set<int>>{};
    final allerLines = <String, Set<int>>{};

    final usedIngredients = <String>{};
    final result = <String, String>{};

    _solver(
      lines,
      ingredients,
      allergens,
      possibilities,
      ingLines,
      allerLines,
      usedIngredients,
      result,
    );

    var total = 0;
    for (final ing in ingredients.difference(usedIngredients)) {
      total += ingLines[ing].length;
    }

    return total;
  }

  String _secondPart(List<String> lines) {
    final ingredients = <String>{};
    final allergens = <String>{};
    final possibilities = <String, Set<String>>{};

    final ingLines = <String, Set<int>>{};
    final allerLines = <String, Set<int>>{};

    final usedIngredients = <String>{};
    final result = <String, String>{};

    _solver(
      lines,
      ingredients,
      allergens,
      possibilities,
      ingLines,
      allerLines,
      usedIngredients,
      result,
    );

    final sortedAllergies = result.keys.toList()..sort();
    final dangerous = sortedAllergies.map((e) => result[e]).join(',');
    return dangerous;
  }

  void _solver(
    List<String> lines,
    Set<String> ingredients,
    Set<String> allergens,
    Map<String, Set<String>> possibilities,
    Map<String, Set<int>> ingLines,
    Map<String, Set<int>> allerLines,
    Set<String> usedIngredients,
    Map<String, String> result,
  ) {
    var lineIndex = 0;
    for (final line in lines) {
      final splitted = line.split(' (contains ');

      final partialIngredients = splitted[0].split(' ');
      partialIngredients.forEach((ing) {
        ingLines.putIfAbsent(ing, () => {});
        ingLines[ing].add(lineIndex);
      });
      ingredients.addAll(partialIngredients);

      var partialAllergens = <String>[];
      if (splitted.length == 2) {
        partialAllergens = splitted[1]
            .substring(
              0,
              splitted[1].length - 1,
            )
            .split(', ');
      }
      partialAllergens.forEach((aller) {
        allerLines.putIfAbsent(aller, () => {});
        allerLines[aller].add(lineIndex);
      });
      allergens.addAll(partialAllergens);

      for (var aller in partialAllergens) {
        possibilities.putIfAbsent(aller, () => {});
        for (var ingr in partialIngredients) {
          possibilities[aller].add(ingr);
        }
      }

      lineIndex++;
    }

    final _ = _dfsAllergens(
      allergens,
      usedIngredients,
      possibilities,
      ingLines,
      allerLines,
      result,
    );
  }

  bool _dfsAllergens(
    Set<String> allergens,
    Set<String> usedIngredients,
    Map<String, Set<String>> possibilities,
    Map<String, Set<int>> ingLines,
    Map<String, Set<int>> allerLines,
    Map<String, String> result,
  ) {
    if (allergens.isEmpty) return true;

    final allergen = allergens.first;
    final availableIng = possibilities[allergen].difference(
      usedIngredients,
    );

    if (availableIng.isEmpty) return false;
    allergens.remove(allergen);

    for (var ingr in availableIng) {
      if (allerLines[allergen].intersection(ingLines[ingr]).length !=
          allerLines[allergen].length) {
        continue;
      }

      usedIngredients.add(ingr);

      final wasGoodPath = _dfsAllergens(
        allergens,
        usedIngredients,
        possibilities,
        ingLines,
        allerLines,
        result,
      );

      if (wasGoodPath) {
        result[allergen] = ingr;
        return true;
      }

      usedIngredients.remove(ingr);
    }

    allergens.add(allergen);
    return false;
  }
}
