import 'dart:io';
import 'dart:async';

class CPU {
  List<int> _cycles = [20, 60, 100, 140, 180, 220];
  List<List<String>> crt =
      List.generate(6, (_) => List.generate(40, (_) => ' '));
  int x = 1;
  String currentInstruction = '';
  int currentInstructionValue = 0;
  int currentInstructionCyclesLeft = 0;
  int instructionLine = 0;
  int currentCycle = 0;
  List<int> signals = [];
  List<List<String>> instructions = [];

  void getNextInstruction() {
    if (currentInstruction == 'addx') x += currentInstructionValue;
    currentInstruction = instructions[instructionLine].first;
    if (currentInstruction == 'addx') {
      currentInstructionCyclesLeft = 2;
      currentInstructionValue = int.parse(instructions[instructionLine].last);
    } else
      currentInstructionCyclesLeft = 1;
    instructionLine++;
  }

  void checkSignal() {
    _cycles.forEach((cycle) {
      if (cycle == currentCycle) signals.add(x * currentCycle);
    });
  }

  CPU(List<List<String>> instructions) {
    this.instructions = instructions;
  }
}

Future<void> main() async {
  String input = await File('input.txt').readAsString();
  Iterable<List<String>> instructions =
      input.split('\n').map((e) => e.split(' '));
  var results = solution(instructions.toList());
  print('Silver: ${results['silver']}');
  print('Gold: \n${results['gold']}');
}

Map<String, String> solution(List<List<String>> instructions) {
  CPU cpu = CPU(instructions);
  for (List<String> line in cpu.crt) {
    for (int i = 0; i < line.length; i++) {
      cpu.checkSignal();
      cpu.currentCycle++;
      if (cpu.currentInstructionCyclesLeft == 0) cpu.getNextInstruction();
      if ((i - cpu.x).abs() <= 1) line[i] = '#';
      cpu.currentInstructionCyclesLeft--;
    }
  }
  return {
    'silver': '${cpu.signals.reduce((prev, next) => prev + next)}',
    'gold': cpu.crt.map((line) => line.join()).join('\n'),
  };
}
