import 'dart:io';
import 'dart:async';

const List<List<int>> directions = [
  [0, 1],
  [0, -1],
  [1, 0],
  [-1, 0],
];

Future<void> main() async {
  String input = await File('input.txt').readAsString();
  List<List<int>> trees = input
      .split('\n')
      .map((line) => line.split('').map((tree) => int.parse(tree)).toList())
      .toList();
  trees.removeWhere((line) => line.length == 0);
  int silver = 0;
  int gold = 0;
  for (var i = 0; i < trees.length; i++) {
    for (var j = 0; j < trees.length; j++) {
      int goldCount = 1;
      for (var k = 0; k < directions.length; k++) {
        if (checkVisibility(trees, i, j, directions[k])) {
          silver++;
          break;
        }
      }
      for (var k = 0; k < directions.length; k++) {
        goldCount *= visibleTrees(trees, i, j, directions[k]);
      }
      if (goldCount > gold) gold = goldCount;
    }
  }
  print('Silver: ${silver}');
  print('Gold: ${gold}');
}

bool checkVisibility(List<List<int>> trees, int y, int x, List<int> direction) {
  int currentValue = trees[x][y];
  int movement = direction[direction[0] == 0 ? 1 : 0];
  bool isX = direction[0] != 0;
  if (isX
      ? movement < 0
          ? x == 0
          : x == trees.length - 1
      : movement < 0
          ? y == 0
          : y == trees.length - 1) return true;
  for (var i = (isX ? (movement < 0 ? x - 1 : x + 1) : x),
          j = (isX ? y : (movement < 0 ? y - 1 : y + 1));
      movement < 0 ? (isX ? i : j) >= 0 : (isX ? i : j) < trees.length;
      movement < 0 ? (isX ? i-- : j--) : (isX ? i++ : j++)) {
    if (trees[i][j] >= currentValue) return false;
  }
  return true;
}

int visibleTrees(List<List<int>> trees, int y, int x, List<int> direction) {
  int currentValue = trees[x][y];
  int movement = direction[direction[0] == 0 ? 1 : 0];
  bool isX = direction[0] != 0;
  if (isX
      ? movement < 0
          ? x == 0
          : x == trees.length - 1
      : movement < 0
          ? y == 0
          : y == trees.length - 1) return 0;
  int result = 0;
  for (var i = (isX ? (movement < 0 ? x - 1 : x + 1) : x),
          j = (isX ? y : (movement < 0 ? y - 1 : y + 1));
      movement < 0 ? (isX ? i : j) >= 0 : (isX ? i : j) < trees.length;
      movement < 0 ? (isX ? i-- : j--) : (isX ? i++ : j++)) {
    result++;
    if (trees[i][j] >= currentValue) break;
  }
  return result;
}
