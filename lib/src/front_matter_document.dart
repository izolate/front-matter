import 'package:yaml/yaml.dart';

/// Document containing the original `value`, front matter `data` and `content`.
class FrontMatterDocument {
  /// The initial [value] to be parsed.
  String value;

  /// The parsed [content] from the [value].
  String? content;

  /// The parsed YAML front matter as a [YamlMap].
  YamlMap data = YamlMap();

  FrontMatterDocument(this.value);

  /// Returns the initial [value].
  String toString() => this.value;
}
