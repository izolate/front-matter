import 'dart:io';
import 'package:front_matter/front_matter.dart' as front_matter;

void main() async {
  // Read and parse a file from path.
  var doc = await front_matter.parseFile('example/hello-world.md');

  print("The author is ${doc.data['author']}");
  print("The publish date is ${doc.data['date']}");
  print("The content is ${doc.content}");
}
