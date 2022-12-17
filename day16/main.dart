import 'dart:io';
import 'dart:async';
import 'dart:math';

class Valve {
  List<String> tunnels;
  int rate;
  Valve(this.rate, this.tunnels) {}

  @override
  String toString() {
    return '\nRate:$rate\nTunnels: $tunnels\n';
  }
}

Future<void> main() async {
  String input = await File('input.txt').readAsString();
  Map<String, Valve> valves = parseInput(input);
  print('Silver: ${silver(valves)}');
  // print('Gold: ${gold(valves)}');
}

int gold(Map<String, Valve> valves) {
  int timeLimit = 26;
  List<String> rates = [];
  valves.forEach((k, v) {
    if (v.rate > 0) rates.add(k);
  });
  List<List<List<bool>>> variations = getVariations(rates.length);
  print(rates);
  print(variations[0]);
  return 0;
}

Map<String, Map<String, int>> createDistances(Map<String, Valve> valves) {
  Map<String, Map<String, int>> result = {};
  valves.keys.where((v) => valves[v]!.rate > 0 || v == 'AA').forEach((v) {
    print(v);
    result.putIfAbsent(v, () {
      Map<String, int> innerResult = {};
      valves.keys.where((iv) => iv != v && valves[iv]!.rate > 0).forEach((iv) =>
          innerResult.putIfAbsent(iv, () => shortestPath(v, iv, valves)));
      return innerResult;
    });
  });
  return result;
}

Map<String, Valve> parseInput(String input) {
  Map<String, Valve> result = {};
  RegExp regex = RegExp(
      r'Valve (.*) has flow rate=(\d+); tunnels? leads? to valves? (.*)');
  regex.allMatches(input).forEach((m) {
    result.putIfAbsent(
        m[1]!, () => Valve(int.parse(m[2]!), m[3]!.split(', ').toList()));
  });
  return result;
}

int shortestPath(String from, String to, Map<String, Valve> valves,
    {int n = 0, Set<String>? visited = null}) {
  if (from == to) return n;
  if (visited == null) visited = Set();
  visited.add(from);
  int result = valves.length;
  valves[from]!
      .tunnels
      .where((tunnel) => !visited!.contains(tunnel))
      .forEach((tunnel) {
    int newSP = n;
    if (!visited!.contains(tunnel))
      newSP =
          shortestPath(tunnel, to, valves, n: n + 1, visited: visited.toSet());
    if (result > newSP) result = newSP;
  });
  return result;
}

List<List<List<bool>>> getVariations(int n) {
  List<List<List<bool>>> result = List.generate(n + 1, (_) => []);
  List<bool> b = List.filled(n, false);
  for (int i = 0; i < pow(2, n); i++) {
    for (int j = 0; j < n; j++) {
      b[j] = (i >> j) & 1 == 1;
    }
    result[b.where((e) => e).length].add(b.toList());
  }
  return result;
}

List<List<bool>> getVariationsWhere(List<List<bool>> variations, int n) {
  return variations.where((v) => v.where((e) => e).length == n).toList();
}

int silver(Map<String, Valve> valves) {
  Map<String, Map<String, int>> distances = createDistances(valves);
  List<String> rates = [];
  valves.forEach((key, value) {
    if (value.rate != 0) rates.add(key);
  });
  int result = 0;
  rates.forEach((r) {
    int rP = releasedPressure(
        r, valves, rates, [r], distances['AA']![r]!, distances);
    if (result < rP) {
      result = rP;
    }
  });
  return result;
}

Map<String, int>? alreadyUsedRates = null;
int highestResult = 0;

int releasedPressure(
    String start,
    Map<String, Valve> valves,
    List<String> rates,
    List<String> usedRates,
    int time,
    Map<String, Map<String, int>> distances,
    {List<List<List<bool>>>? variations = null,
    int timeLimit = 30,
    int result = 0}) {
  time++;
  result += valves[start]!.rate * (timeLimit - time);
  String usedRatesS = usedRates.toString();
  if (alreadyUsedRates == null) alreadyUsedRates = {usedRatesS: result};
  if (alreadyUsedRates!.containsKey(usedRatesS) &&
      alreadyUsedRates![usedRatesS]! > result)
    return 0;
  else
    alreadyUsedRates!.putIfAbsent(usedRatesS, () => result);
  if (variations == null) variations = getVariations(rates.length);
  if (usedRates.length == rates.length) {
    if (time >= timeLimit) return 0;
    if (highestResult < result) highestResult = result;
    return result;
  }
  int endResult = 0;
  variations[usedRates.length + 1].where((v) {
    for (String uR in usedRates) {
      if (!v[rates.indexOf(uR)]) return false;
    }
    return true;
  }).forEach((v) {
    List<String> newUsedRates = [];
    for (int i = 0; i < v.length; i++) if (v[i]) newUsedRates.add(rates[i]);
    String newEl = newUsedRates.singleWhere((e) => !usedRates.contains(e));
    int newTime = time + distances[start]![newEl]!;
    if (newTime <= 30) {
      int rP = releasedPressure(
          newEl, valves, rates, newUsedRates, newTime, distances,
          variations: variations, result: result);
      if (endResult < rP) endResult = rP;
    }
  });
  return endResult == 0 ? result : endResult;
}
