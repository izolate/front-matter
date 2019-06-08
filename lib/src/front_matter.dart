import 'dart:io';
import 'front_matter_document.dart';
import 'front_matter_exception.dart';
import 'parse_content.dart';

// Default delimiter for YAML.
const defaultDelimiter = '---';
// Error thrown when file is not found.
const fileNotFoundError = 'File not found';
// Error thrown when the file type is unsupported.
const fileTypeError = 'File type is not supported';

/// Parses an [input] string to extract the front matter.
FrontMatterDocument parse(String input,
        {String delimiter = defaultDelimiter}) =>
    parseContent(input, delimiter: delimiter);

/// Reads a file at [path] and parses the content to extract the front matter.
Future<FrontMatterDocument> parseFile(String path,
    {String delimiter = defaultDelimiter}) async {
  var file = new File(path);

  // Throw an error if file not found.
  if (!await file.exists()) {
    throw FrontMatterException(fileNotFoundError);
  }

  try {
    var contents = await file.readAsString();
    return parseContent(contents, delimiter: delimiter);
  } catch (e) {
    // Throw an error if file is not readable as text.
    throw FrontMatterException(fileTypeError);
  }
}
