import 'dart:io';
import 'dart:async';

Future<void> main() async {
  String input = await File('input.txt').readAsString();
  var result = solution(input);
  print('Silver: ${result['silver']}');
  print('Gold: ${result['gold']}');
}

Map<String, int> solution(String input) {
  int silverResult = 0;
  int goldResult = 0;
  RegExp regex = RegExp(r'(\d+)-(\d+),(\d+)-(\d+)');
  regex.allMatches(input).forEach((line) {
    int n1 = int.parse(line[1]!);
    int n2 = int.parse(line[2]!);
    int n3 = int.parse(line[3]!);
    int n4 = int.parse(line[4]!);
    if ((n1 >= n3 && n2 <= n4) || (n3 >= n1 && n4 <= n2)) silverResult++;
    if ((n1 >= n3 && n1 <= n4) ||
        (n2 >= n3 && n2 <= n4) ||
        (n3 >= n1 && n3 <= n2) ||
        (n4 >= n1 && n4 <= n2)) goldResult++;
  });
  return {'silver': silverResult, 'gold': goldResult};
}
