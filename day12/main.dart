import 'dart:io';
import 'dart:async';
import 'dart:math';

const List<Point> neighbours = [
  Point(-1, 0),
  Point(0, -1),
  Point(1, 0),
  Point(0, 1),
];

Future<void> main() async {
  String input = await File('input.txt').readAsString();
  List<List<int>> parsedInput = input
      .split('\n')
      .map((e) => e.split('').map((c) => c.codeUnitAt(0)).toList())
      .toList();
  Point startPoint = Point(0, 0);
  Point endPoint = Point(0, 0);
  for (int i = 0; i < parsedInput.length; i++) {
    for (int j = 0; j < parsedInput[i].length; j++) {
      if (parsedInput[i][j] == 83) {
        startPoint = Point(i, j);
        parsedInput[i][j] = 97;
      }
      if (parsedInput[i][j] == 69) {
        endPoint = Point(i, j);
        parsedInput[i][j] = 122;
      }
    }
  }
  print('${solution(startPoint, endPoint, parsedInput)}');
}

Map<String, int> solution(
    Point startPoint, Point endPoint, List<List<int>> parsedInput) {
  Map<Point, int> distance = {endPoint: 0};
  createMap(distance, endPoint, parsedInput);
  int gold = distance[startPoint]!;
  distance.forEach((key, value) {
    if (parsedInput[key.x.toInt()][key.y.toInt()] == 97 && value < gold)
      gold = value;
  });
  return {'Silver': distance[startPoint]!, 'Gold': gold};
}

void createMap(
    Map<Point, int> p, Point currentPoint, List<List<int>> parsedInput) {
  neighbours.forEach((n) {
    Point neighbour = currentPoint + n;
    if (neighbour.y >= 0 &&
        neighbour.x >= 0 &&
        neighbour.x < parsedInput.length &&
        neighbour.y < parsedInput[neighbour.x.toInt()].length &&
        parsedInput[currentPoint.x.toInt()][currentPoint.y.toInt()] -
                parsedInput[neighbour.x.toInt()][neighbour.y.toInt()] <=
            1 &&
        (!p.containsKey(neighbour) || p[neighbour]! > p[currentPoint]! + 1)) {
      p.update(neighbour, (_) => p[currentPoint]! + 1,
          ifAbsent: () => p[currentPoint]! + 1);
      createMap(p, neighbour, parsedInput);
    }
  });
}
