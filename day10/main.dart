import 'dart:io';
import 'dart:async';

const List<int> cycles = [20, 60, 100, 140, 180, 220];

Future<void> main() async {
  String input = await File('input.txt').readAsString();
  Iterable<List<String>> instructions =
      input.split('\n').map((e) => e.split(' '));
  print('Silver: ${silver(instructions.toList())}');
  print('Gold: \n${gold(instructions.toList())}');
}

int silver(List<List<String>> instructions) {
  int cycle = 0;
  int x = 1;
  List<int> results = [];
  instructions.forEach((line) {
    switch (line.first) {
      case 'noop':
        {
          cycle++;
          if (check(x, cycle) is int) {
            results.add(x * cycle);
          }
        }
        break;
      case 'addx':
        {
          cycle++;
          if (check(x, cycle) is int) {
            results.add(x * cycle);
          }
          cycle++;
          if (check(x, cycle) is int) {
            results.add(x * cycle);
          }
          x += int.parse(line[1]);
        }
    }
  });
  return results.reduce((prev, next) => prev + next);
}

int? check(int x, cycle) {
  for (int c in cycles) {
    if (c == cycle) {
      return x;
    }
  }
  return null;
}

String gold(List<List<String>> instructions) {
  int x = 1;
  String currentInstruction = '';
  int currentInstructionValue = 0;
  int currentInstructionCyclesLeft = 0;
  int instructionLine = 0;
  List<List<String>> crt =
      List.generate(6, (_) => List.generate(40, (_) => '.'));
  for (List<String> line in crt) {
    for (int i = 0; i < line.length; i++) {
      if (currentInstructionCyclesLeft == 0) {
        if (currentInstruction == 'addx') {
          x += currentInstructionValue;
        }
        currentInstruction = instructions[instructionLine].first;
        switch (currentInstruction) {
          case 'addx':
            {
              currentInstructionCyclesLeft = 2;
              currentInstructionValue =
                  int.parse(instructions[instructionLine].last);
            }
            break;
          case 'noop':
            {
              currentInstructionCyclesLeft = 1;
            }
        }
        instructionLine++;
      }
      if ((i - x).abs() <= 1) {
        line[i] = '#';
      }
      currentInstructionCyclesLeft--;
    }
  }
  return crt.map((line) => line.join()).join('\n');
}
