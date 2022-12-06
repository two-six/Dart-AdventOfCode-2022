import 'dart:io';
import 'dart:async';

Future<void> main() async {
  String input = await File('bigboy.txt').readAsString();
  int silver = 0, gold = 0;
  for (var i = 0, j = 0;;) {
    if (silver == 0) {
      int len = input.substring(i, i + 4).split('').toSet().length;
      if (len == 4) {
        silver = i + 4;
      }
      i += 4 - len;
    }
    if (gold == 0) {
      int len = input.substring(j, j + 14).split('').toSet().length;
      if (len == 14) {
        gold = j + 14;
      }
      j += 14 - len;
    }
    if (gold != 0 && silver != 0) break;
  }
  print('Silver: $silver');
  print('Gold: $gold');
}
