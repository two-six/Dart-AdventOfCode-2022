import 'dart:io';
import 'dart:async';

Future<void> main() async {
  String input = await File('input.txt').readAsString();
  List<List<List<dynamic>>> parsedInput = input
      .split('\n\n')
      .map((e) => e.split('\n').map((e2) => parseString(e2)).toList())
      .toList();
  print(solution(parsedInput));
}

List<dynamic> parseString(String s) {
  var list = [];
  var current = list;
  var stack = [];
  for (var i = 0; i < s.length; i++) {
    var char = s[i];
    if (char == '[') {
      stack.add(current);
      var newList = [];
      current.add(newList);
      current = newList;
    } else if (char == ']') {
      current = stack.removeLast();
    } else if (int.tryParse(char) != null) {
      var numberString = char;
      while (i + 1 < s.length && int.tryParse(s[i + 1]) != null) {
        numberString += s[i + 1];
        i++;
      }
      current.add(int.parse(numberString));
    }
  }
  return list.expand((i) => i).toList();
}

int isInOrder(List<dynamic> left, List<dynamic> right) {
  for (int i = 0; i < left.length; i++) {
    if (i == right.length)
      return -1;
    else if (left[i] is int && right[i] is int) {
      if (left[i] < right[i])
        return 1;
      else if (left[i] > right[i]) return -1;
    } else if (left[i] is int && right[i] is List) {
      int result = isInOrder([left[i]], right[i]);
      if (result != 0) return result;
    } else if (left[i] is List && right[i] is int) {
      int result = isInOrder(left[i], [right[i]]);
      if (result != 0) return result;
    } else {
      int result = isInOrder(left[i], right[i]);
      if (result != 0) return result;
    }
  }
  if (left.length < right.length) return 1;
  return 0;
}

Map<String, int> solution(List<dynamic> parsedInput) {
  int silver = 0;
  for (int i = 0; i < parsedInput.length; i++) {
    var left = parsedInput[i].first;
    var right = parsedInput[i].last;
    if (isInOrder(left, right) == 1) {
      silver += i + 1;
    }
  }
  var gold = parsedInput.expand((i) => i).toList() +
      [
        [
          [2]
        ],
        [
          [6]
        ]
      ];
  print(gold);
  gold.sort((a, b) => isInOrder(b, a));
  return {
    'Silver': silver,
    'Gold': (gold.indexWhere((e) => e.toString() == '[[2]]')) *
        (gold.indexWhere((e) => e.toString() == '[[6]]'))
  };
}
