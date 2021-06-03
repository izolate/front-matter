import 'package:yaml/yaml.dart';
import 'package:front_matter/src/front_matter_document.dart';
import 'package:front_matter/src/front_matter_exception.dart';

/// Extracts and parses YAML front matter from a [String].
///
/// Returns a [FrontMatterDocument] comprising the parsed YAML front matter
/// `data` [YamlMap], and the remaining `content` [String].
///
/// Throws a [FrontMatterException] if front matter contains invalid YAML.
FrontMatterDocument parser({
  required String text,
  required String delimiter,
}) {
  final doc = FrontMatterDocument(value: text);

  // Remove any leading whitespace.
  final value = text.trimLeft();

  // If there's no starting delimiter, there's no front matter.
  if (!value.startsWith(delimiter)) {
    return doc;
  }

  // Get the index of the closing delimiter.
  final closeIndex = value.indexOf('\n$delimiter');

  // Get the raw front matter block between the opening and closing delimiters.
  final frontMatter = value.substring(delimiter.length, closeIndex);

  if (frontMatter.isNotEmpty) {
    try {
      // Parse the front matter as YAML.
      doc.data = loadYaml(frontMatter) as YamlMap?;
      // The content begins after the closing delimiter index.
      doc.content = value.substring(closeIndex + (delimiter.length + 1));
    } catch (e) {
      throw const FrontMatterException(invalidYamlError);
    }
  }

  return doc;
}
