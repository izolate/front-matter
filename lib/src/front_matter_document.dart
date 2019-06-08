import 'package:yaml/yaml.dart';

/// Document containing the original value, front matter and content.
class FrontMatterDocument {
  /// The `input` is the original, unedited text.
  /// The `content` is the remainder after substracting the front matter
  /// from the `input`.
  String input, content;

  /// The parsed YAML front matter as a [YamlMap].
  YamlMap data;

  FrontMatterDocument(this.input);
}
