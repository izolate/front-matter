import 'dart:async';
import 'dart:io';
import 'front_matter_document.dart';
import 'front_matter_exception.dart';
import 'parser.dart';

// Default delimiter for YAML.
const _defaultDelimiter = '---';

/// Parses a [text] string to extract the front matter.
FrontMatterDocument parse(String text,
        {String delimiter = _defaultDelimiter}) =>
    parser(text, delimiter: delimiter);

/// Reads a file at [path] and parses the content to extract the front matter.
Future<FrontMatterDocument> parseFile(String path,
    {String delimiter = _defaultDelimiter}) async {
  var file = File(path);

  // Throw an error if file not found.
  if (!await file.exists()) {
    throw FrontMatterException(fileNotFoundError);
  }

  try {
    var text = await file.readAsString();
    return parser(text, delimiter: delimiter);
  } catch (e) {
    // Handle downstream errors, or throw one if file is not readable as text.
    if (e is FrontMatterException && e.message == invalidYamlError) {
      rethrow;
    } else {
      throw FrontMatterException(fileTypeError);
    } 
  }
}
