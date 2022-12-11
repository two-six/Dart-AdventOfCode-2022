import 'dart:io';
import 'dart:async';

class Item {
  int originalValue = 0;
  List<int> monkeyValues = [];
  Item(originalValue) {
    this.originalValue = originalValue;
  }
  void createMonkeyValues(List<int> tests) {
    tests.forEach((test) => this.monkeyValues.add(this.originalValue % test));
  }

  @override
  String toString() {
    return '$originalValue -> $monkeyValues';
  }
}

class Monkey {
  List<Item> items = [];
  List<String> operation = [];
  int test = 0;
  int testTrue = 0;
  int testFalse = 0;
  int inspectedItem = 0;
  Monkey(List<int> startingItems, String operation, int test, int testTrue,
      int testFalse) {
    this.items = startingItems.map((item) => Item(item)).toList();
    this.operation = operation.split(' ');
    this.test = test;
    this.testTrue = testTrue;
    this.testFalse = testFalse;
  }

  bool checkTestValue(int n, Item item) {
    return item.monkeyValues[n] == 0;
  }

  void inspectItems(List<int> tests) {
    inspectedItem += items.length;
    items.forEach((item) {
      for (int i = 0; i < item.monkeyValues.length; i++) {
        if (operation[1] == '*')
          item.monkeyValues[i] = (item.monkeyValues[i] *
                  (operation[2] == 'old'
                      ? item.monkeyValues[i]
                      : int.parse(operation[2]) % tests[i])) %
              tests[i];
        else
          item.monkeyValues[i] =
              (item.monkeyValues[i] + (int.parse(operation[2]) % tests[i])) %
                  tests[i];
      }
    });
  }

  void silverInspectItems() {
    inspectedItem += items.length;
    items.forEach((item) {
      if (operation[1] == '*')
        item.originalValue *= (operation[2] == 'old'
            ? item.originalValue
            : int.parse(operation[2]));
      else
        item.originalValue += int.parse(operation[2]);
      item.originalValue ~/= 3;
    });
  }

  @override
  String toString() {
    return 'Items: $items\nInspected Items: $inspectedItem\nOperation: $operation\n Test: $test\n TestTrue: $testTrue\nTestFalse: $testFalse\n';
  }
}

Future<void> main() async {
  String input = await File('input.txt').readAsString();
  List<Monkey> monkeys = createMonkeys(input);
  print('Silver: ${silver(monkeys)}');
  monkeys = createMonkeys(input);
  print('Gold: ${gold(monkeys)}');
}

List<Monkey> createMonkeys(String input) {
  List<Monkey> result = [];
  RegExp regex = RegExp(
      r'Monkey (\d+):\n\s+Starting items: (.*)\n\s+Operation: new = (.*)\n\s+Test: divisible by (\d+)\n\s+If true: throw to monkey (\d+)\n\s+If false: throw to monkey (\d+)');
  regex.allMatches(input).forEach((monkey) {
    result.add(Monkey(
        monkey[2]!.split(', ').map((item) => int.parse(item)).toList(),
        monkey[3]!,
        int.parse(monkey[4]!),
        int.parse(monkey[5]!),
        int.parse(monkey[6]!)));
  });
  return result;
}

int silver(List<Monkey> monkeys) {
  for (int round = 0; round < 20; round++) {
    monkeys.forEach((monkey) {
      monkey.silverInspectItems();
      monkey.items.forEach((item) {
        if (item.originalValue % monkey.test == 0)
          monkeys[monkey.testTrue].items.add(item);
        else
          monkeys[monkey.testFalse].items.add(item);
      });
      monkey.items.clear();
    });
  }
  monkeys.sort((a, b) => b.inspectedItem.compareTo(a.inspectedItem));
  return monkeys[0].inspectedItem * monkeys[1].inspectedItem;
}

int gold(List<Monkey> monkeys) {
  List<int> tests = [];
  monkeys.forEach((monkey) => tests.add(monkey.test));
  monkeys.forEach((monkey) {
    monkey.items.forEach((item) {
      item.createMonkeyValues(tests);
    });
  });
  for (int round = 0; round < 10000; round++) {
    for (int i = 0; i < monkeys.length; i++) {
      monkeys[i].inspectItems(tests);
      monkeys[i].items.forEach((item) {
        if (monkeys[i].checkTestValue(i, item))
          monkeys[monkeys[i].testTrue].items.add(item);
        else
          monkeys[monkeys[i].testFalse].items.add(item);
      });
      monkeys[i].items.clear();
    }
  }
  monkeys.sort((a, b) => b.inspectedItem.compareTo(a.inspectedItem));
  return monkeys[0].inspectedItem * monkeys[1].inspectedItem;
}
