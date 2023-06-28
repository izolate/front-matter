import 'package:yaml/yaml.dart';
import 'front_matter_document.dart';
import 'front_matter_exception.dart';

/// Extracts and parses YAML front matter from a [String].
///
/// Returns a [FrontMatterDocument] comprising the parsed YAML front matter
/// `data` [YamlMap], and the remaining `content` [String].
///
/// Throws a [FrontMatterException] if front matter contains invalid YAML.
FrontMatterDocument parser(String text, {required String delimiter}) {
  var doc = FrontMatterDocument(text);

  // Remove any leading whitespace.
  var value = text.trimLeft();

  // If there's no starting delimiter, there's no front matter.
  if (!value.startsWith(delimiter)) {
    return doc;
  }

  // Get the index of the closing delimiter.
  final closeIndex = value.indexOf('\n' + delimiter);

  // Get the raw front matter block between the opening and closing delimiters.
  var frontMatter = value.substring(delimiter.length, closeIndex);

  if (frontMatter.isNotEmpty) {
    try {
      // Parse the front matter as YAML.
      doc.data = loadYaml(frontMatter);
      // The content begins after the closing delimiter index.
      doc.content = value.substring(closeIndex + (delimiter.length + 1));
    } catch (e) {
      throw FrontMatterException(invalidYamlError);
    }
  }

  return doc;
}
