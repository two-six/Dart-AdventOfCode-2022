import 'dart:io';
import 'dart:async';
import 'dart:math';

Future<void> main() async {
  String input = await File('input.txt').readAsString();
  Set<Point> scan = createMap(input.split('\n').map((line) {
    return line.split(' -> ').map((e) {
      return Point(int.parse(e.split(',').first), int.parse(e.split(',').last));
    }).toList();
  }).toList());
  print(solution(scan));
}

Set<Point> createMap(List<List<Point>> scan) {
  Set<Point> result = Set<Point>();
  scan.forEach((line) {
    for (int i = 1; i < line.length; i++)
      result.addAll(createLine(line[i - 1], line[i]));
  });
  return result;
}

Set<Point> createLine(Point p1, Point p2) {
  List<int> x = [
    for (var i = p1.x;
        (p1.x > p2.x ? i >= p2.x : i <= p2.x);
        p1.x > p2.x ? i-- : i++)
      i.toInt()
  ];
  List<int> y = [
    for (var i = p1.y;
        (p1.y > p2.y ? i >= p2.y : i <= p2.y);
        p1.y > p2.y ? i-- : i++)
      i.toInt()
  ];

  Set<Point> result = Set();
  x.forEach((e1) {
    y.forEach((e2) => result.add(Point(e1, e2)));
  });
  return result;
}

Map<String, int> solution(Set<Point> scan) {
  int silver = 0;
  int floorY = 0;
  scan.forEach((p) {
    if (floorY < p.y) floorY = p.y.toInt();
  });
  floorY += 2;
  for (int i = 0;; i++) {
    Point sand = Point(500, 0);
    if (scan.contains(Point(500, 0))) return {'Silver': silver, 'Gold': i};
    while (true) {
      if (silver == 0 && sand.y > floorY - 2) silver = i;
      Point left = sand + Point(-1, 1);
      Point right = sand + Point(1, 1);
      Point down = sand + Point(0, 1);
      if (down.y == floorY) {
        scan.add(sand);
        break;
      } else if (scan.contains(down)) {
        if (scan.contains(left)) {
          if (scan.contains(right)) {
            scan.add(sand);
            break;
          } else
            sand += Point(1, 0);
        } else
          sand += Point(-1, 0);
      }
      sand += Point(0, 1);
    }
  }
}
