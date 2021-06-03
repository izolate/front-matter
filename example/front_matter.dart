import 'dart:io';
import 'package:front_matter/front_matter.dart' as fm;

// ignore_for_file: avoid_print

// Example 1 - Parse a string.
Future<void> example1() async {
  final file = File('example/hello-world.md');
  final fileContents = await file.readAsString();

  final doc = fm.parse(fileContents);

  print("The author is ${doc.data!['author']}");
  print("The publish date is ${doc.data!['date']}");
  print("The content is ${doc.content}");
}

// Example 2 - Read a file and parse its contents.
Future<void> example2() async {
  final doc = await fm.parseFile('example/hello-world.md');

  print("The author is ${doc.data!['author']}");
  print("The publish date is ${doc.data!['date']}");
  print("The content is ${doc.content}");
}

Future<void> main() async {
  await example1();
  await example2();
}
