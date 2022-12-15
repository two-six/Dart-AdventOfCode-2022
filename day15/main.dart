import 'dart:async';
import 'dart:io';
import 'dart:math';

class Sensor {
  Point<int> sensor;
  Point<int> beacon;
  int distance = 0;
  Sensor(this.sensor, this.beacon) {
    this.distance = (this.sensor.x - this.beacon.x).abs() +
        (this.sensor.y - this.beacon.y).abs();
  }
  int getDistance(Point<int> p2) {
    return (this.sensor.x - p2.x).abs() + (this.sensor.y - p2.y).abs();
  }

  @override
  String toString() {
    return 'Sensor: $sensor - Beacon: $beacon - Distance: $distance';
  }
}

Future<void> main() async {
  String input = await File('input.txt').readAsString();
  List<Sensor> sensors = parseInput(input);
  print('Silver: ${silver(sensors)}');
  print('Gold: ${gold(sensors)}');
}

List<Sensor> parseInput(String input) {
  List<Sensor> result = [];
  RegExp regex =
      RegExp(r'Sensor at x=(.*), y=(.*): closest beacon is at x=(.*), y=(.*)');
  regex.allMatches(input).forEach((m) {
    int x1 = int.parse(m[1]!);
    int y1 = int.parse(m[2]!);
    int x2 = int.parse(m[3]!);
    int y2 = int.parse(m[4]!);
    result.add(Sensor(Point(x1, y1), Point(x2, y2)));
  });
  return result;
}

int getMaxRight(List<Sensor> sensors) {
  int result = 0;
  sensors.forEach((s) {
    if (result < s.sensor.x + s.distance) result = s.sensor.x + s.distance;
  });
  return result;
}

int getMaxLeft(List<Sensor> sensors, int start) {
  sensors.forEach((s) {
    if (start > s.sensor.x - s.distance) start = s.sensor.x - s.distance;
  });
  return start;
}

int silver(List<Sensor> sensors) {
  const int row = 2000000;
  // const int row = 10;
  int maxRight = getMaxRight(sensors);
  int maxLeft = getMaxLeft(sensors, maxRight);
  int result = 0;
  for (int i = maxLeft; i <= maxRight; i++) {
    for (Sensor s in sensors) {
      if (s.distance >= s.getDistance(Point(i, row)) &&
          Point(i, row) != s.beacon) {
        result++;
        break;
      }
    }
  }
  return result;
}

int gold(List<Sensor> sensors) {
  // const int maxN = 20;
  const int maxN = 4000000;
  bool isFound;
  for (int i = 0; i <= maxN; i++) {
    for (int j = 0; j <= maxN; j++) {
      int skip = 0;
      isFound = true;
      for (Sensor s in sensors) {
        int dis = s.getDistance(Point(j, i));
        if (s.distance >= dis) {
          isFound = false;
          int nSkip = s.distance - dis;
          if (s.sensor.x > j) nSkip += (s.sensor.x - j) * 2;
          if (skip < nSkip) skip = nSkip;
        }
      }
      if (isFound) {
        return j * 4000000 + i;
      } else {
        j += skip;
      }
    }
  }
  return 0;
}
