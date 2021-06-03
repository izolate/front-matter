import 'package:yaml/yaml.dart';

/// Document containing the original `value`, front matter `data` and `content`.
class FrontMatterDocument {
  FrontMatterDocument({
    required this.value,
    this.content,
    this.data,
  });

  /// The initial [value] to be parsed.
  String value;

  /// The parsed [content] from the [value].
  String? content;

  /// The parsed YAML front matter as a [YamlMap].
  YamlMap? data;

  /// Returns the initial [value].
  @override
  String toString() => value;
}
