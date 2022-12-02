import 'dart:io';
import 'dart:async';

const Map<String, int> playValues = {
  'A': 1,
  'B': 2,
  'C': 4,
  'X': 1,
  'Y': 2,
  'Z': 4,
};

Future<void> main() async {
  String input = await File('input.txt').readAsString();
  print('Silver: ${silver(input)}');
  print('Gold: ${gold(input)}');
}

int silver(String input) {
  int result = 0;
  input.split('\n').toList().forEach((game) {
    List<String> play = game.split(' ').toList();
    int value = playValues[play[0]]! + playValues[play[1]]!;
    result += calculate(value, play[1]);
  });
  return result;
}

int gold(String input) {
  int result = 0;
  input.split('\n').toList().forEach((game) {
    List<String> play = game.split(' ').toList();
    if(play[0] == 'A') {
      switch(play[1]) {
        case 'X': { play[1] = 'Z'; } break;
        case 'Y': { play[1] = 'X'; } break;
        case 'Z': { play[1] = 'Y'; } break;
      }
    } else if(play[0] == 'C') {
      switch(play[1]) {
        case 'X': { play[1] = 'Y'; } break;
        case 'Y': { play[1] = 'Z'; } break;
        case 'Z': { play[1] = 'X'; } break;
      }
    }
    int value = playValues[play[0]]! + playValues[play[1]]!;
    result += calculate(value, play[1]);
  });
  return result;
}

int calculate(int value, String secondPlay) {
  switch(value) {
    case 2: { return 4; }
    case 3: { return secondPlay == 'Y' ? 8 : 1; }
    case 4: { return 5; }
    case 5: { return secondPlay == 'Z' ? 3 : 7; }
    case 6: { return secondPlay == 'Z' ? 9 : 2; }
    case 8: { return 6; }
  }
  throw('Invalid play value');
}