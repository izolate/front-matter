import 'package:yaml/yaml.dart';

/// Document containing the original `value`, front matter `data` and `content`.
class FrontMatterDocument {
  String value, content;

  /// The parsed YAML front matter as a [YamlMap].
  YamlMap data;

  FrontMatterDocument(this.value);
}
