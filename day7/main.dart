import 'dart:io';
import 'dart:async';

Future<void> main() async {
  String input = await File('input.txt').readAsString();
  print(solution(input));
}

Map<String, int> solution(String input) {
  Map<String, int> files = parseFiles(input);
  int silver = 0;
  files.values.forEach((size) {
    if (size <= 100000) silver += size;
  });

  int gold = 0;
  int needed = 30000000 - (70000000 - files['/']!);
  var directories = files.keys.toList();
  directories.sort((a, b) => files[b]!.compareTo(files[a]!));
  for (var i = 0; i < 20; i++) {
    if (files[directories[i]]! < needed) {
      gold = files[directories[i - 1]]!;
      break;
    }
  }
  return {
    'Silver': silver,
    'Gold': gold,
  };
}

Map<String, int> parseFiles(String input) {
  Map<String, int> files = {'/': 0};
  String currentDir = '/';
  RegExp regex = RegExp(r'(.+?) (.+)');
  String commands = input.replaceAll('\$ ', '');
  regex.allMatches(commands).forEach((line) {
    String command = line[1]!;
    String value = line[2]!;
    switch (command) {
      case 'cd':
        {
          if (value[0] == '/') {
            currentDir = value;
          } else if (value == '..') {
            currentDir = currentDir.substring(0, currentDir.length - 1);
            currentDir =
                currentDir.substring(0, currentDir.lastIndexOf('/') + 1);
          } else
            currentDir += value + '/';
        }
        break;
      case 'dir':
        {
          files.putIfAbsent(currentDir + value + '/', () => 0);
        }
        break;
      default:
        {
          files[currentDir] = files[currentDir]! + int.parse(command);
        }
    }
  });
  List<String> directoriesSortedInc = files.keys.toList();
  directoriesSortedInc.sort((a, b) => a.length.compareTo(b.length));
  var directoriesSortedDesc = directoriesSortedInc.reversed;
  for (var key in directoriesSortedInc) {
    for (var keyInside in directoriesSortedDesc) {
      if (keyInside.length > key.length &&
          keyInside.substring(0, key.length) == key &&
          keyInside != key) {
        files[key] = files[key]! + files[keyInside]!;
      }
      if (keyInside.length < key.length) break;
    }
  }
  return files;
}
