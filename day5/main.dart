import 'dart:io';
import 'dart:async';

class Stack<T> {
  List<T> stack = [];
  T pop() {
    return stack.removeLast();
  }

  void push(T element) {
    stack.add(element);
  }

  bool isEmpty() {
    return stack.isEmpty;
  }

  void reverse() {
    stack = stack.reversed.toList();
  }

  Stack<T> fromList(List<T> list) {
    Stack<T> result = Stack<T>();
    stack = List<T>.from(list);
    result.stack = stack;
    return result;
  }

  @override
  String toString() {
    String result = '';
    stack.forEach((element) => result += '[$element]\n');
    return result.trimRight();
  }
}

Future<void> main() async {
  String input = await File('input.txt').readAsString();
  print(solution(input, parse(input)));
}

Map<String, String> solution(String input, List<Stack<String>> parsed) {
  String silverResult = '';
  String goldResult = '';
  var goldParsed = [];
  parsed.forEach((element) => goldParsed.add(Stack().fromList(element.stack)));
  RegExp regex = RegExp(r'move (\d+) from (\d+) to (\d+)');
  regex.allMatches(input).forEach((instruction) {
    int n1 = int.parse(instruction[1]!);
    int n2 = int.parse(instruction[2]!) - 1;
    int n3 = int.parse(instruction[3]!) - 1;
    for (int i = 0; i < n1; i++) {
      parsed[n3].push(parsed[n2].pop());
    }
    List<String> elements = [];
    for (int i = 0; i < n1; i++) {
      elements.add(goldParsed[n2].pop());
    }
    elements.reversed.forEach((element) {
      goldParsed[n3].push(element);
    });
  });
  parsed.forEach((stack) => silverResult += stack.stack.last);
  goldParsed.forEach((stack) => goldResult += stack.stack.last);
  return {
    'Silver': silverResult,
    'Gold': goldResult,
  };
}

List<Stack<String>> parse(String input) {
  List<Stack<String>> result = [];
  List<String> lines = input.split('\n').toList();
  for (var i = 0; i < lines.length; i++) {
    int currentElement = 0;
    for (var j = 0; j < lines[i].length; j++) {
      if (lines[i][j] == ' ') j++;
      if (lines[i].substring(j, j + 3) == '   ') {
        j += 2;
        if (i == 0) result.add(Stack());
      } else if (lines[i][j] == '[') {
        String element = '';
        j++;
        while (lines[i][j] != ']') {
          element += lines[i][j];
          j++;
        }
        if (result.length == currentElement) result.add(Stack());
        result[currentElement].push(element);
      } else if (lines[i][1] == '1') {
        i = lines.length;
        break;
      }
      currentElement++;
    }
  }
  result.forEach((stack) => stack.reverse());
  return result;
}
