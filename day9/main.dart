import 'dart:io';
import 'dart:async';

class Point {
  int x = 0;
  int y = 0;

  Point(int x, int y) {
    this.x = x;
    this.y = y;
  }

  Point.from(Point p) {
    this.x = p.x;
    this.y = p.y;
  }

  void moveTo(Point p) {
    if (p.isTouching(Point(this.x + 1, this.y)))
      this.x += 1;
    else if (p.isTouching(Point(this.x - 1, this.y)))
      this.x -= 1;
    else if (p.isTouching(Point(this.x, this.y + 1)))
      this.y += 1;
    else
      this.y -= 1;
  }

  void moveDiagonally(Point p) {
    if (p.isTouching(Point(this.x + 1, this.y + 1))) {
      this.x += 1;
      this.y += 1;
    } else if (p.isTouching(Point(this.x + 1, this.y - 1))) {
      this.x += 1;
      this.y -= 1;
    } else if (p.isTouching(Point(this.x - 1, this.y + 1))) {
      this.x -= 1;
      this.y += 1;
    } else {
      this.x -= 1;
      this.y -= 1;
    }
  }

  bool isTouching(Point p) {
    return (this.x - p.x).abs() <= 1 && (this.y - p.y).abs() <= 1;
  }

  bool operator ==(Object other) =>
      other is Point && x == other.x && y == other.y;

  int get hashCode => Object.hash(x, y);
}

Future<void> main() async {
  String input = await File('input.txt').readAsString();
  print('${solution(input)}');
}

Map<String, int> solution(String input) {
  List<Set<Point>> visited = [
    [Point(0, 0)].toSet(),
    [Point(0, 0)].toSet()
  ];
  List<Point> P = [];
  for (var i = 0; i < 10; i++) {
    P.add(Point(0, 0));
  }
  RegExp regex = RegExp(r'(\w+) (\d+)');
  regex.allMatches(input).forEach((line) {
    String direction = line[1]!;
    int value = int.parse(line[2]!);
    for (var i = 0; i < value; i++) {
      P[0].moveTo(Point(
          direction == 'R'
              ? P[0].x + 2
              : (direction == 'L' ? P[0].x - 2 : P[0].x),
          direction == 'U'
              ? P[0].y - 2
              : (direction == 'D' ? P[0].y + 2 : P[0].y)));
      for (var j = 1; j < 10; j++) {
        if (!P[j].isTouching(P[j - 1])) {
          if (P[j].x != P[j - 1].x && P[j].y != P[j - 1].y) {
            P[j].moveDiagonally(P[j - 1]);
          } else {
            P[j].moveTo(P[j - 1]);
          }
          if (j == 1 || j == 9) visited[j == 1 ? 0 : 1].add(Point.from(P[j]));
        }
      }
    }
  });
  return {'Silver': visited[0].length, 'Gold': visited[1].length};
}
