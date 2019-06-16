import 'dart:async';
import 'dart:io';
import 'front_matter_document.dart';
import 'front_matter_exception.dart';
import 'parser.dart';

// Default delimiter for YAML.
const defaultDelimiter = '---';

/// Parses a [text] string to extract the front matter.
FrontMatterDocument parse(String text, {String delimiter = defaultDelimiter}) =>
    parser(text, delimiter: delimiter);

/// Reads a file at [path] and parses the content to extract the front matter.
Future<FrontMatterDocument> parseFile(String path,
    {String delimiter = defaultDelimiter}) async {
  var file = new File(path);

  // Throw an error if file not found.
  if (!await file.exists()) {
    throw FrontMatterException(fileNotFoundError);
  }

  try {
    var text = await file.readAsString();
    return parser(text, delimiter: delimiter);
  } catch (e) {
    // Handle downstream errors, or throw one if file is not readable as text.
    switch (e.message) {
      case invalidYamlError:
        rethrow;
      default:
        throw FrontMatterException(fileTypeError);
    }
  }
}
