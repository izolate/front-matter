import 'dart:async';
import 'dart:io';
import 'package:front_matter/src/front_matter_document.dart';
import 'package:front_matter/src/front_matter_exception.dart';
import 'package:front_matter/src/parser.dart';

// Default delimiter for YAML.
const _defaultDelimiter = '---';

/// Parses a [text] string to extract the front matter.
FrontMatterDocument parse(String text,
        {String delimiter = _defaultDelimiter}) =>
    parser(text: text, delimiter: delimiter);

/// Reads a file at [path] and parses the content to extract the front matter.
Future<FrontMatterDocument> parseFile(String path,
    {String delimiter = _defaultDelimiter}) async {
  final file = File(path);

  // Throw an error if file not found.
  if (!await file.exists()) {
    throw const FrontMatterException(fileNotFoundError);
  }

  try {
    final text = await file.readAsString();
    return parser(text: text, delimiter: delimiter);
  } catch (e) {
    // Handle downstream errors, or throw one if file is not readable as text.
    if (e is FrontMatterException) {
      switch (e.message) {
        case invalidYamlError:
          rethrow;
        default:
          throw const FrontMatterException(fileTypeError);
      }
    } else if (e is FileSystemException) {
      throw const FrontMatterException(fileTypeError);
    }
    rethrow;
  }
}
