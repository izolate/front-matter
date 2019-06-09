import 'dart:io';
import 'package:front_matter/front_matter.dart' as front_matter;

void main() async {
  var file = new File('example/hello-world.md');
  var contents = await file.readAsString();

  // Parse file contents.
  var doc = front_matter.parse(contents);

  print("The author is ${doc.data['author']}");
  print("The publish date is ${doc.data['author']}");
  print("The content is ${doc.content}");
}
