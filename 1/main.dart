import 'dart:async';
import 'dart:io';
import 'dart:math';

Future<void> main() async {
  String input = await File('input.txt').readAsString();
  List<int> elves = input
    .split('\n\n')
    .map((element) => element
        .split('\n')
        .map((value) => int.parse(value))
        .fold(0, (prev, next) => prev+next))
    .toList();
  print('Silver: ${silver(elves)}');
  print('Gold: ${gold(elves)}');
}

int silver(List<int> elves) {
   return  elves.reduce(max);
}

int gold(List<int> elves) {
  elves.sort((a, b) => b.compareTo(a)); 
  return elves[0] + elves[1] + elves[2];
}

