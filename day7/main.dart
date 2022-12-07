import 'dart:io';
import 'dart:async';

class Node {
  String name = '';
  int value = 0;
  Node? parent = null;
  Map<String, Node> children = {};

  Node({String name = '', int value = 0, Node? parent = null}) {
    this.name = name;
    this.value = value;
    this.parent = parent;
  }
  void addChild(String name, {int value = 0, Node? parent = null}) {
    children.putIfAbsent(
        name, () => Node(name: name, value: value, parent: parent));
  }

  int computeValue() {
    int result = this.value;
    this.children.values.forEach((child) => result += child.computeValue());
    return result;
  }

  void computeAllValues() {
    this.value = this.computeValue();
    this.children.values.forEach((child) => child.computeAllValues());
  }

  @override
  String toString() {
    String result = '${this.name} - ${this.value}\n';
    children.values.forEach((child) => result += child.toString());
    return result;
  }
}

Future<void> main() async {
  String input = await File('input.txt').readAsString();
  Node tree = parseFiles(input);
  print('Silver: ${silver(tree)}');
  print('Gold: ${gold(tree)}');
}

int silver(Node tree) {
  int result = tree.value <= 100000 ? tree.value : 0;
  tree.children.values.forEach((child) {
    result += silver(child);
  });
  return result;
}

int gold(Node tree) {
  int needed = -(70000000 - tree.value - 30000000);
  List<int> result = goldCompute(tree, needed);
  result.sort();
  return result.first;
}

List<int> goldCompute(Node tree, int needed) {
  List<int> result = [];
  if (tree.value >= needed) {
    result.add(tree.value);
    tree.children.values
        .forEach((child) => result += goldCompute(child, needed));
  }
  return result;
}

Node parseFiles(String input) {
  Node tree = Node(name: '/', value: 0);
  RegExp regex = RegExp(r'(.+?) (.+)');
  String commands = input.replaceAll('\$ ', '');
  regex.allMatches(commands).forEach((line) {
    String command = line[1]!;
    String value = line[2]!;
    switch (command) {
      case 'cd':
        {
          if (value[0] == '/')
            tree.name = '/';
          else if (value == '..')
            tree = tree.parent!;
          else {
            tree.addChild(tree.name + value + '/', parent: tree);
            tree = tree.children[tree.name + value + '/']!;
          }
        }
        break;
      case 'dir':
        {
          tree.addChild(tree.name + value + '/', parent: tree);
        }
        break;
      default:
        {
          tree.value += int.parse(command);
        }
    }
  });
  for (;;) {
    if (tree.parent != null)
      tree = tree.parent!;
    else
      break;
  }

  tree.computeAllValues();

  return tree;
}
