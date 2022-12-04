import 'dart:io';
import 'dart:async';

Future<void> main() async {
  String input = await File('input.txt').readAsString();
  print('Silver: ${silver(input)}');
  print('Gold: ${gold(input)}');
}

int silver(String input) {
  int result = 0;
  input.split('\n').forEach((line) {
    List<Set<String>> rucksacks = [
      line.substring(0, line.length ~/ 2).split('').toSet(),
      line.substring(line.length ~/ 2).split('').toSet()
    ];
    result += calculate(rucksacks);
  });
  return result;
}

int gold(String input) {
  int result = 0;
  List<String> lines = input.split('\n').toList();
  List<List<Set<String>>> groups = [];
  for (var i = 0; i < lines.length; i += 3) {
    groups += [
      [
        lines[i].split('').toSet(),
        lines[i + 1].split('').toSet(),
        lines[i + 2].split('').toSet()
      ]
    ];
  }
  groups.forEach((group) => result += calculate(group));
  return result;
}

int calculate(List<Set<String>> rucksacks) {
  int result = 0;
  rucksacks
      .fold(rucksacks.first, (a, b) => a.intersection(b))
      .map((letter) => letter.toString().codeUnits)
      .forEach((codeUnit) {
    if (codeUnit[0] > 90)
      result = codeUnit[0] - 96;
    else
      result = codeUnit[0] - 38;
  });
  return result;
}
